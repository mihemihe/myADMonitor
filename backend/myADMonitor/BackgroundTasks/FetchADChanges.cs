using myADMonitor.Helpers;

namespace myADMonitor.BackgroundTasks
{
    public class FetchADChanges : IHostedService
    {
        public Task StartAsync(CancellationToken cancellationToken)
        {
            Task.Run(async () =>
            {
                while (!cancellationToken.IsCancellationRequested)
                {
                    Console.WriteLine("\r\n--------- STARTING DELTA: " + DirectoryState.TotalDeltas +  "------------------");

                    if (DirectoryState.GetDBInitialized() == false)
                    {
                        Console.WriteLine("INFO\tDo nothing yet, db not init");
                        // Do nothing because it is initial sync
                        // It never gets here but just in case
                    }
                    else
                    {
                        if (DirectoryState.GetDeltaRunning() == false)
                        {
                            DirectoryState.SetDeltaRunningTrue();
                            { // Block for style only
                                // Fetch delta changes
                                Console.WriteLine("INFO\tFetching delta changes...START");
                                DirectoryState.FetchDeltaChanges();
                                Console.WriteLine("INFO\tFetching delta changes...COMPLETED");

                                // Calculate header stats
                                int every = 5;
                                if (DirectoryState.TotalDeltas % every == 0)
                                {
                                    Console.WriteLine("INFO\tCalculating stats. (Every {0} deltas)", every);
                                    Console.WriteLine("INFO\tTotal deltas executed: " + DirectoryState.TotalDeltas);
                                    DirectoryState.UpdateHeaderDataInfo();
                                    Console.WriteLine("INFO\tStats completed. Total objects {0}", DirectoryState.RetrieveHeaderData().ObjectsInDatabase);
                                }

                                DirectoryState.TotalDeltas += 1;
                            }

                            DirectoryState.SetDeltaRunningFalse();
                        }
                    }
                    int seconds = 5;
                    Console.WriteLine("\r\n--------- END ------------------ | Waiting {0} seconds", seconds);
                    await Task.Delay(new TimeSpan(0, 0, seconds)); // 5 second delay
                }
            }).ContinueWith((t) =>
            {
                if (t.IsFaulted) throw t.Exception;
                //optionally do some work);
            });
            //TODO: Rewrite the background service to actually handle exceptions inside the task. Right now it fails silently.
            Console.WriteLine("INFO\tStarting background scheduler");
            return Task.CompletedTask;
        }

        public Task StopAsync(CancellationToken cancellationToken)
        {
            return Task.CompletedTask;
        }
    }
}