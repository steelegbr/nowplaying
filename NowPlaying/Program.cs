using System.Security.Claims;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using NowPlaying.Database;
using NowPlaying.Repositories;
using Serilog;

var builder = WebApplication.CreateBuilder(args);

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
    options => options.UseInMemoryDatabase(databaseName: builder.Configuration["DbName"])
);
builder.Services.AddScoped<IStationRepository, EfStationRepository>();

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

// Light up the controllers and run the app

app.MapControllers();
app.Run();