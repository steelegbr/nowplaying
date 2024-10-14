using System.ComponentModel.DataAnnotations;

namespace NowPlaying.Models.Dto;

public class AuthenticationSchemeDto
{
    [AllowedValues("Auth0")]
    public string Scheme { get; set; }
}