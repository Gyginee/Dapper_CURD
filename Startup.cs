using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using System.Data;
using System.Data.SqlClient;
using DapperCURD.Repository;
using DapperCURD.Model;

public class Startup
{
    public IConfiguration Configuration { get; }

    public Startup(IConfiguration configuration)
    {
        Configuration = configuration;
    }

    public void ConfigureServices(IServiceCollection services)
    {
        // Add connection string (stored in appsettings.json)
        services.AddTransient<IDbConnection>(db => new SqlConnection(
            Configuration.GetConnectionString("DefaultConnection")
        ));

        // Register Repository for dependency injection
        services.AddScoped<ProductRepository>();
        services.AddScoped<OrderRepository>();
        services.AddScoped<CategoryRepository>();
        services.AddScoped<ShipperRepository>();
        services.AddScoped<PaymentRepository>();
        services.AddScoped<CustomerRepository>();
        services.AddScoped<ShipmentRepository>();

        services.AddControllers();
    }

    public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
    {
        if (env.IsDevelopment())
        {
            app.UseDeveloperExceptionPage();
        }

        app.UseRouting();

        app.UseEndpoints(endpoints =>
        {
            endpoints.MapControllers();
        });
    }
}
