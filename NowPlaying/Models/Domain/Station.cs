using Microsoft.EntityFrameworkCore;

namespace NowPlaying.Models.Domain;

[Index(nameof(Name), IsUnique = true)]
public class Station
{
    public Guid Id { get; set; }
    public string Name { get; set; }
    public Song? Song { get; set; }
}