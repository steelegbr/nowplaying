using Microsoft.EntityFrameworkCore;
using NowPlaying.Models.Domain;

namespace NowPlaying.Database;

public class NowPlayingContext : DbContext
{
    public DbSet<Station> Stations { get; set; }
    public DbSet<Song> Songs { get; set; }
}