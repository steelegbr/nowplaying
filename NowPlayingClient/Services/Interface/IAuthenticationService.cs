using System.Threading.Tasks;

namespace NowPlayingClient.Services
{

    public enum AuthenticationStatus
    {
        Unauthenticated,
        Authenticating,
        Authenticated,
        AuthenticationFailed
    }

    public interface IAuthenticationService
    {
        AuthenticationStatus Status { get; }
        Task Authenticate();
        Task Logout();
    }
}