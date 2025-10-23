using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Net.Http;
using System.Threading.Tasks;
using ReactiveUI;

namespace NowPlayingClient.Services
{
    enum Auth0AuthenticationStatus
    {
        Unauthenticated,
        Error,
        DeviceCode,
        AwaitingUserAuth,
        TimedOut,
        Authenticated
    }
    
    public class Auth0AuthenticationService : ReactiveObject, IAuthenticationService
    {
        private readonly HttpClient _httpClient;
        private readonly ReactiveAuthSettings _settings;
        private Auth0AuthenticationStatus _auth0Status = Auth0AuthenticationStatus.Unauthenticated;
        private string _accessToken = string.Empty;

        public AuthenticationStatus Status => _auth0Status switch
        {
            Auth0AuthenticationStatus.Unauthenticated => AuthenticationStatus.Unauthenticated,
            Auth0AuthenticationStatus.Error => AuthenticationStatus.AuthenticationFailed,
            Auth0AuthenticationStatus.DeviceCode => AuthenticationStatus.Authenticating,
            Auth0AuthenticationStatus.AwaitingUserAuth => AuthenticationStatus.Authenticating,
            Auth0AuthenticationStatus.TimedOut => AuthenticationStatus.AuthenticationFailed,
            Auth0AuthenticationStatus.Authenticated => AuthenticationStatus.Authenticated,
            _ => throw new System.NotImplementedException(),
        };

        public Auth0AuthenticationService(HttpClient httpClient, ReactiveAuthSettings settings)
        {
            _httpClient = httpClient;
            _settings = settings;
        }

        public async Task Authenticate()
        {
            if (_auth0Status == Auth0AuthenticationStatus.Error ||
                _auth0Status == Auth0AuthenticationStatus.Unauthenticated)
            {
                var refreshToken = _settings.RefreshToken;
                if (!string.IsNullOrEmpty(refreshToken))
                {
                    _accessToken = await GetAccessTokenWithRefreshToken(refreshToken);
                    if (!string.IsNullOrEmpty(_accessToken))
                    {
                        _auth0Status = Auth0AuthenticationStatus.Authenticated;
                        return;
                    }
                }

                // If no refresh token, start device code flow
            }
        }

        private async Task<string> GetAccessTokenWithRefreshToken(string refreshToken)
        {
            var url = $"https://{_settings.Auth0Domain}/oauth/token";
            var requestBody = new Dictionary<string, string>
            {
                { "grant_type", "refresh_token" },
                { "client_id", _settings.Auth0ClientId },
                { "refresh_token", refreshToken }
            };

            Trace.WriteLine($"Requesting new access token using refresh token from URL: {url}.");

            var response = await _httpClient.PostAsync(url, new FormUrlEncodedContent(requestBody));
            if (response.IsSuccessStatusCode)
            {
                var content = await response.Content.ReadAsStringAsync();
                Trace.WriteLine("Successfully obtained new access token.");
                return content;
            }
            else
            {
                Trace.WriteLine($"Failed to obtain new access token. Status Code: {response.StatusCode}. Error message: {await response.Content.ReadAsStringAsync()}");
                return string.Empty;
            }
        }

        private async Task<string> DeviceFlow(string refreshToken)
        {
            throw new NotImplementedException();
        }

        private async Task<string> GetDeviceCode(string deviceCode)
        {
            var url = $"https://{Properties.Settings.Default.Auth0Domain}/oauth/device/code";
            var requestBody = new Dictionary<string, string>
            {
                {"audience", $"https://{Properties.Settings.Default.Auth0Domain}/api/v2/"},
                { "client_id", Properties.Settings.Default.Auth0ClientId },
                { "scope", "openid profile" }
            };

            Trace.WriteLine($"Requesting device code from URL: {url}.");
            
            var response = await _httpClient.PostAsync(url, new FormUrlEncodedContent(requestBody));
            if (response.IsSuccessStatusCode)
            {
                var content = await response.Content.ReadAsStringAsync();
                Trace.WriteLine("Successfully obtained device code.");
                return content;
            }
            else
            {
                Trace.WriteLine($"Failed to obtain device code. Status Code: {response.StatusCode}. Error message: {await response.Content.ReadAsStringAsync()}");
                return string.Empty;
            }
        }

        public void Logout()
        {
            throw new System.NotImplementedException();
        }

        Task IAuthenticationService.Logout()
        {
            throw new System.NotImplementedException();
        }
    }
}