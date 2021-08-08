using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Net;
using System.Text;
using turn_based_api.Models;
using turn_based_api.Services;
using turn_based_api.Services.Interface;

namespace turn_based_api
{
    public class Startup
    {
        public IConfiguration Configuration { get; }

        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        // add services to the DI container
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddCors();
            services.AddControllers();

            // configure strongly typed settings object
            services.Configure<AppSettings>(Configuration.GetSection("AppSettings"));

            services
                .AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
                .AddJwtBearer(options =>
                {
                    var awsConfigs = Configuration.GetSection("AwsConfigs").Get<AWSConfigs>();

                    options.SaveToken = true;

                    options.TokenValidationParameters = new TokenValidationParameters
                    {
                        IssuerSigningKeyResolver = (s, securityToken, identifier, parameters) =>
                        {
                            // get JsonWebKeySet from AWS
                            var json = new WebClient().DownloadString(parameters.ValidIssuer + "/.well-known/jwks.json");
                            // serialize the result
                            var keys = JsonConvert.DeserializeObject<JsonWebKeySet>(json).Keys;
                            // cast the result to be the type expected by IssuerSigningKeyResolver
                            return (IEnumerable<SecurityKey>)keys;
                        },
                        ValidIssuer = $"https://cognito-idp.{awsConfigs.Region}.amazonaws.com/{awsConfigs.PoolId}",
                        ValidateIssuerSigningKey = true,
                        ValidateIssuer = true,
                        ValidateLifetime = true,
                        ValidAudience = awsConfigs.AppClientId,
                        ValidateAudience = true,
                    };
                });

            // configure DI for application services
            services.AddScoped<IUserService, UserService>();
            services.AddScoped<ITurnbasedService, TurnbasedService>();
        }

        // configure the HTTP request pipeline
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            // global cors policy
            app.UseCors(
                builder => builder
                     .AllowAnyHeader()
                     .AllowAnyMethod()
                     .SetIsOriginAllowed((host) => true)
                     .AllowCredentials()
            );

            app.UseRouting();

            app.UseAuthentication();
            app.UseAuthorization();

            app.UseEndpoints(x => x.MapControllers());
        }
    }
}
