namespace NowPlaying.Models.Domain;

public class Song
{
    public Guid Id { get; set; }
    public string Artist { get; set; }
    public string Title { get; set; }
    public int? Year { get; set; }
}