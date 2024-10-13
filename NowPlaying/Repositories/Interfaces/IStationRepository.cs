using NowPlaying.Models.Domain;

namespace NowPlaying.Repositories;

public interface IStationRepository : IDisposable
{
    public Station? GetStationByName(string name);
    public List<Station> GetAll();
    public Station Create(string name);
    public void SetNowPlaying(Station station, Song? song);
}