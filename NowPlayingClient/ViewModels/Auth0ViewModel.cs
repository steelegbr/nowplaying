using ReactiveUI;
using System;
using System.IO;
using System.Text.Json;

namespace NowPlayingClient.ViewModels
{
    public class Auth0ViewModel : ReactiveObject
    {
        private string _refreshToken = string.Empty;
        private string _auth0Domain = string.Empty;
        private string _auth0ClientId = string.Empty;

        public string RefreshToken
        {
            get => _refreshToken;
            set => this.RaiseAndSetIfChanged(ref _refreshToken, value);
        }

        public string Auth0Domain
        {
            get => _auth0Domain;
            set => this.RaiseAndSetIfChanged(ref _auth0Domain, value);
        }

        public string Auth0ClientId
        {
            get => _auth0ClientId;
            set => this.RaiseAndSetIfChanged(ref _auth0ClientId, value);
        }

        private static string SettingsPath => 
            Path.Combine(
                Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData),
                "NowPlayingClient",
                "settings.json"
            );

        public Auth0ViewModel()
        {
        }

        private void Save()
        {
            var directory = Path.GetDirectoryName(SettingsPath);
            if (!Directory.Exists(directory))
                Directory.CreateDirectory(directory!);

            var json = JsonSerializer.Serialize(this);
            File.WriteAllText(SettingsPath, json);
        }

        private void Load()
        {
            if (!File.Exists(SettingsPath))
                return;

            var json = File.ReadAllText(SettingsPath);
            var settings = JsonSerializer.Deserialize<Auth0ViewModel>(json);
            if (settings != null)
            {
                RefreshToken = settings.RefreshToken;
                Auth0Domain = settings.Auth0Domain;
                Auth0ClientId = settings.Auth0ClientId;
            }
        }
    }
}