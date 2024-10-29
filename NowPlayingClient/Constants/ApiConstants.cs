namespace NowPlayingClient.Constants;

public static class ApiConstants
{
#if DEBUG
  public static readonly string BaseUrl = "http://localhost:5191";
#else
  public static readonly string BaseUrl = "https://nowplaying.solidradio.co.uk"
#endif
  public static readonly string CallbackUrlScheme = "nowplaying";
}