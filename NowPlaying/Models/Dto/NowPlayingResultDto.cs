namespace NowPlaying.Models.Dto;

public class NowPlayingResultDto
{
    public bool IsPlayingASong { get; set; }
    public NowPlayingDto? Song { get; set; }
}