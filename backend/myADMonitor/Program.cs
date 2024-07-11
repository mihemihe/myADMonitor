using myADMonitor.BackgroundTasks;
using myADMonitor.Helpers;

namespace myADMonitor
{
    public class Program
    {
        public static void Main(string[] args)
        {
            //TODO Investigate kestrel disable  or optional http2
            // Initialize AD State for myADMonitor
            DirectoryState.Start();
            DirectoryState.Initialize();

            var MyAllowSpecificOrigins = "_myAllowSpecificOrigins";

            var builder = WebApplication.CreateBuilder(args);

            builder.Services.AddCors(options =>
            {
                options.AddPolicy(name: MyAllowSpecificOrigins,
                                  policy =>
                                  {
                                      policy.AllowAnyHeader()
                                      .AllowAnyOrigin()
                                      .AllowAnyMethod();
                                  });
            });

            // Add services to the container.

            builder.Services.AddControllers();
            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen();

            // myADMonitor custom services:

            builder.Services.AddHostedService<FetchADChanges>();

            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
            }

            app.UseCors(MyAllowSpecificOrigins);

            //app.UseHttpsRedirection();
            app.UseDefaultFiles();
            app.UseStaticFiles();
            app.UseAuthorization();

            app.MapControllers();
            if (DirectoryState.listenAllIPs)
            {
                app.Urls.Add("http://0.0.0.0:" + DirectoryState.tCPPort);
            }
            else
            {
                app.Urls.Add("http://localhost:" + DirectoryState.tCPPort);
            }

            app.Run();
        }
    }
}