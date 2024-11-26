export type SongDto = {
    artist: string,
    title: string,
    year?: number
}

export type StationDto = {
    id: string,
    name: string,
    song?: SongDto
}

export type NowPlayingDto = {
    isPlayingASong: boolean,
    song?: SongDto
}