using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using NowPlaying.Models.Domain;
using NowPlaying.Models.Dto;
using NowPlaying.Repositories;

namespace NowPlaying.Controllers;

[Route("api/station")]
[ApiController]
[Authorize]
public class StationController : Controller
{
    private ILogger<StationController> logger;
    private IStationRepository stationRepository;

    public StationController(ILogger<StationController> logger, IStationRepository stationRepository)
    {
        this.logger = logger;
        this.stationRepository = stationRepository;
    }

    [HttpGet("{name}")]
    public IActionResult GetStationByName([FromRoute] string name)
    {
        var station = stationRepository.GetStationByName(name);
        if (station == null)
        {
            return NotFound();
        }

        return Ok(station);
    }

    [AllowAnonymous]
    [HttpGet]
    public List<Station> GetStations()
    {
        return stationRepository.GetAll();
    }

    [HttpPut]
    public IActionResult CreateStation([FromBody] StationDto stationDto)
    {
        var existingStation = stationRepository.GetStationByName(stationDto.Name);
        if (existingStation != null)
        {
            return Conflict();
        }

        return Ok(stationRepository.Create(stationDto.Name));
    }

    [HttpPut("{name}/nowplaying")]
    public IActionResult SetNowPlaying([FromRoute] string name, NowPlayingDto? nowPlayingDto)
    {
        var station = stationRepository.GetStationByName(name);
        if (station == null)
        {
            return NotFound();
        }

        var song = nowPlayingDto == null ? null : new Song 
        { 
            Artist = nowPlayingDto.Artist, 
            Title = nowPlayingDto.Title, 
            Year = nowPlayingDto.Year 
        };
        stationRepository.SetNowPlaying(station, song);
        return Ok(song);
    }

    [AllowAnonymous]
    [HttpGet("{name}/nowplaying")]
    public IActionResult GetNowPlaying([FromRoute] string name)
    {
        var station = stationRepository.GetStationByName(name);
        if (station == null)
        {
            return NotFound();
        }

        if (station.Song == null)
        {
            return Ok(
                new NowPlayingResultDto { IsPlayingASong = false }
            );
        }

        return Ok(
            new NowPlayingResultDto
            {
                IsPlayingASong = true,
                Song = new NowPlayingDto
                {
                    Artist = station.Song.Artist,
                    Title = station.Song.Title,
                    Year = station.Song.Year
                }
            }
        );

    }

}