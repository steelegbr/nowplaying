using System.ComponentModel.DataAnnotations;

namespace NowPlaying.Models.Dto;

public class NowPlayingDto
{
    [Required]
    public string Artist { get; set; }

    [Required]
    public string Title { get; set; }

    [Range(1900, 3000)]
    public int? Year { get; set; }
}