using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using System.Text;
using ChoETL;
using System.Collections.Generic;
using System.Net;
using JsonSerializer = System.Text.Json.JsonSerializer;

namespace Lumii.GetCovid19ZATimelineTests
{
    public static class HttpTriggerZACovidTimelineTesting
    {
        [FunctionName("GetCovidTimeline")]
        public static async Task<IActionResult> GetCovidTimeline(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            string csv = GetData("https://raw.githubusercontent.com/dsfsi/covid19za/master/data/covid19za_timeline_testing.csv");

            StringBuilder stringBuilderCsv = new StringBuilder();
            stringBuilderCsv.Append(csv);

            List<Covid19ZATimeline> covid19ZATimeline = new List<Covid19ZATimeline>();
            foreach (var e in new ChoCSVReader<Covid19ZATimeline>(stringBuilderCsv).WithFirstLineHeader())
            {
                covid19ZATimeline.Add(e);
            }
            var json = JsonSerializer.Serialize(covid19ZATimeline);

            return new OkObjectResult(json);
        }

        [FunctionName("GetProvincialCumulativeTimeline")]
        public static async Task<IActionResult> GetProvincialCumulativeTimeline(
               [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)] HttpRequest req,
               ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            string csv = GetData("https://raw.githubusercontent.com/dsfsi/covid19za/master/data/covid19za_provincial_cumulative_timeline_confirmed.csv");

            StringBuilder stringBuilderCsv = new StringBuilder();
            stringBuilderCsv.Append(csv);

            List<ProvincialCumulativeTimeline> provincialCumulativeTimeline = new List<ProvincialCumulativeTimeline>();
            foreach (var e in new ChoCSVReader<ProvincialCumulativeTimeline>(stringBuilderCsv).WithFirstLineHeader())
            {
                provincialCumulativeTimeline.Add(e);
            }

            var json = JsonSerializer.Serialize(provincialCumulativeTimeline);

            return new OkObjectResult(json);
        }

        [FunctionName("GetRegulation")]
        public static async Task<IActionResult> GetRegulation(
               [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)] HttpRequest req,
               ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            string json = GetData("https://raw.githubusercontent.com/GeorgeLekala/ZACovid19Lockdown/master/data/regulation.json");

            return new OkObjectResult(json);
        }

        [FunctionName("GetRegulationRule")]
        public static async Task<IActionResult> GetRegulationRule(
               [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)] HttpRequest req,
               ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            string json = GetData("https://raw.githubusercontent.com/GeorgeLekala/ZACovid19Lockdown/master/data/regulationrule.json");

            return new OkObjectResult(json);
        }

        [FunctionName("GetSuburb")]
        public static async Task<IActionResult> GetSuburb(
               [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)] HttpRequest req,
               ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            string json = GetData("https://raw.githubusercontent.com/GeorgeLekala/ZACovid19Lockdown/master/data/subplacelokuptable.json");

            return new OkObjectResult(json);
        }

        private static string GetData(string url)
        {
            HttpWebRequest req = (HttpWebRequest)WebRequest.Create(url);
            HttpWebResponse resp = (HttpWebResponse)req.GetResponse();

            StreamReader sr = new StreamReader(resp.GetResponseStream());
            string results = sr.ReadToEnd();
            sr.Close();

            return results;
        }
    }
}