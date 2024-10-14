using System.ComponentModel.DataAnnotations;

namespace NowPlaying.Models.Dto;

public class StationDto
{
    [Required]
    public string Name { get; set; }
}