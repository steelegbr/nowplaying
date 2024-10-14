using Auth0.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore;
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

builder.Services.AddAuth0WebAppAuthentication(
    options => {
        options.Domain = builder.Configuration["Auth0:Domain"];
        options.ClientId = builder.Configuration["Auth0:ClientId"];
        options.ClientSecret = builder.Configuration["Auth0:ClientSecret"];
    }
).WithAccessToken(
    options => {
        options.Audience = builder.Configuration["Auth0.:Audience"];
        options.UseRefreshTokens = true;
    }
);

// Register services

builder.Services.AddDbContext<NowPlayingContext>(
    options => options.UseInMemoryDatabase(builder.Configuration["DbConnectionString"])
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