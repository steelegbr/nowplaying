using System.Security.Claims;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using NowPlaying.Database;
using NowPlaying.Repositories;
using Serilog;

var builder = WebApplication.CreateBuilder(args);
const string CORS_POLICY_NAME = "NowPlayingCorsPolicy";

// Core services

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Logging

builder.Services.AddSerilog(
    new LoggerConfiguration().WriteTo.Console().CreateLogger()
);

// Authentication

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
.AddJwtBearer(
    options => 
    {
        options.Authority = $"https://{builder.Configuration["Auth0:Domain"]}";
        options.Audience = $"https://{builder.Configuration["Auth0:Domain"]}/api/v2/";
        options.TokenValidationParameters = new TokenValidationParameters
        {
            NameClaimType = ClaimTypes.NameIdentifier
        };
    }
);

// Register services

builder.Services.AddDbContext<NowPlayingContext>(
    options => options.UseSqlite(builder.Configuration["ConnectionString"])
);
builder.Services.AddScoped<IStationRepository, EfStationRepository>();

// Configure CORS

builder.Services.AddCors(
    options =>
    {
        options.AddPolicy(
            name: CORS_POLICY_NAME,
            policy =>
            {
                policy.WithOrigins("http://localhost:3000");
            }
        );
    }
);

// Build the app

var app = builder.Build();

// Enable swagger in DEV environments

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// Enforce HTTPS

app.UseHttpsRedirection();

// AAA

app.UseAuthentication();
app.UseAuthorization();

// Enable CORS

app.UseCors(CORS_POLICY_NAME);

// Light up the controllers and run the app

app.MapControllers();
app.Run();