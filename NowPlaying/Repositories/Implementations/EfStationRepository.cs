using NowPlaying.Database;
using NowPlaying.Models.Domain;

namespace NowPlaying.Repositories;

public class EfStationRepository : IStationRepository
{
    private ILogger<EfStationRepository> logger;
    private NowPlayingContext nowPlayingContext;
    private bool disposed = false;

    public EfStationRepository(ILogger<EfStationRepository> logger, NowPlayingContext nowPlayingContext)
    {
        this.logger = logger;
        this.nowPlayingContext = nowPlayingContext;
    }

    public Station Create(string name)
    {
        var station = new Station
        {
            Id = Guid.NewGuid(),
            Name = name
        };
        logger.LogInformation("Creating station {name} with ID {id}", station.Name, station.Id);

        nowPlayingContext.Stations.Add(station);
        nowPlayingContext.SaveChanges();
        return station;
    }

    protected virtual void Dispose(bool disposing)
    {
        if (!disposed)
        {
            if (disposing)
            {
                nowPlayingContext.Dispose();
            }
            disposed = true;
        }
    }

    public void Dispose()
    {
        Dispose(true);
        GC.SuppressFinalize(this);
    }

    public List<Station> GetAll()
    {
        return nowPlayingContext.Stations.OrderBy(station => station.Name).ToList();
    }

    public Station? GetStationByName(string name)
    {
        return nowPlayingContext.Stations.FirstOrDefault(station => station.Name == name);
    }

    public void SetNowPlaying(Station station, Song? song)
    {
        if (station.Song != null)
        {
            logger.LogInformation("Removing existing song ID {id} from station {name}", station.Song.Id, station.Name);
            var oldSong = station.Song;
            station.Song = null;
            nowPlayingContext.Stations.Update(station);
            nowPlayingContext.Songs.Remove(oldSong);
            nowPlayingContext.SaveChanges();
        }

        if (song != null)
        {
            logger.LogInformation("Setting song to {artist} - {title} for station {name}", song.Artist, song.Title, station.Name);
            station.Song = song;
            nowPlayingContext.Songs.Add(song);
            nowPlayingContext.Stations.Update(station);
            nowPlayingContext.SaveChanges();
        }
    }
}