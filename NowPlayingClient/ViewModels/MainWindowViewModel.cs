using ReactiveUI;
using NowPlayingClient.ViewModels;

public class MainWindowViewModel : ReactiveObject
{
    public Auth0ViewModel Auth0Settings { get; }

    public MainWindowViewModel(Auth0ViewModel auth0Settings)
    {
        Auth0Settings = auth0Settings;
    }

}