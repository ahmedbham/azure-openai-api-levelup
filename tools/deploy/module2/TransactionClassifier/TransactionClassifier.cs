// Default URL for triggering event grid function in the local environment.
// http://localhost:7071/runtime/webhooks/EventGrid?functionName={functionname}
using System;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.EventGrid.Models;
using Microsoft.Azure.WebJobs.Extensions.EventGrid;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json.Linq;
using System.Globalization;
using System.IO;
using CsvHelper;
using System.Linq;
using Azure.AI.OpenAI;
using Azure;
using static System.Environment;

namespace TransactionClassification
{
    public static class TransactionClassifier
    {
        private const string prompt = @"You are a data expert working for the National Library of Scotland.
You are analysing all transactions over £25,000 in value and classifying them into one of five categories.
The five categories are Building Improvement, Literature & Archive, Utility Bills, Professional Services and Software/IT.
If you can't tell what it is, say Could not classify

Transaction:

Supplier: SUPPLIER_NAME
Description: DESCRIPTION_TEXT
Value: TRANSACTION_VALUE

The classification is:";

        [FunctionName("TransactionClassifier")]
        public static void Run([EventGridTrigger] EventGridEvent eventGridEvent, ILogger log)
        {
            // Get the blob information from the event grid event.
            var data = ((JObject)eventGridEvent.Data).ToObject<StorageBlobCreatedEventData>();
            // retrieve continer name from URL field ("https://egblobstore.blob.core.windows.net/{containername}/blobname.jpg") of the event grid event
            var containerName = data.Url.Split('/')[3];
            // retrieve blob name from URL field ("https://egblobstore.blob.core.windows.net/containername/{blobname}.jpg") of the event grid event
            var blobName = data.Url.Split('/')[4];

            var connectionString = GetEnvironmentVariable("STORAGE_ACCOUNT_CONNECTION_STRING");
                
            // Retrieve the blob from the storage account.
            var blobClient = new Azure.Storage.Blobs.BlobClient(connectionString, containerName, blobName);
            var blobContent = blobClient.DownloadContent();
            
            // convert from system.binary to system.io.stream
            var stream = new MemoryStream(blobContent.Value.Content.ToArray());

            // set up connection to Azure OpenAI API client
            string endpoint = GetEnvironmentVariable("OPENAI_API_BASE");
            string key = GetEnvironmentVariable("OPENAI_API_KEY");           
            OpenAIClient client = new OpenAIClient(new Uri(endpoint), new AzureKeyCredential(key));

            // read content of uploaded csv file
            using var reader = new StreamReader(stream);
            using var csv = new CsvReader(reader, CultureInfo.InvariantCulture);
            var records = csv.GetRecords<dynamic>().ToList();

            string prompt = TransactionClassifier.prompt;

            // for each csv record, set value in the column named "classification" to response from Azure OpenAI API Completion API
            foreach (var record in records)
            {
                string classification = ClassifyTransaction(record, prompt, client);
                
                record.classification = classification;
            }
            
            // create a new file to store updated csv file
            using (var writer = new StringWriter())
            {
                using (var acsv = new CsvWriter(writer, CultureInfo.InvariantCulture))
                {
                    acsv.WriteRecords(records);

                    String str1 = writer.ToString();
                }

                // convert StringWriter to a Stream so it could be uploaded via BlobClient
                var stream2 = new MemoryStream(System.Text.Encoding.UTF8.GetBytes(writer.ToString()));
                var outputBlobClient = new Azure.Storage.Blobs.BlobClient(connectionString, "output", blobName);
                outputBlobClient.Upload(stream2);
            }
            
        }
                
        private static string ClassifyTransaction(dynamic transaction, string prompt, OpenAIClient client)
        {
            prompt = prompt.Replace("SUPPLIER_NAME", transaction.Supplier);
            prompt = prompt.Replace("DESCRIPTION_TEXT", transaction.Description);
            prompt = prompt.Replace("TRANSACTION_VALUE", transaction.Transaction_value);

            string engine = GetEnvironmentVariable("OPENAI_API_MODEL");

            // call the Azure OpenAI API Completion API
            Response<Completions> completionsResponse = client.GetCompletions(engine, prompt);
            string completion = completionsResponse.Value.Choices[0].Text;

            return completion;
        }

    }

}
