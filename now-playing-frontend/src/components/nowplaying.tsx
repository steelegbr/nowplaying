"use client"

import { NowPlayingDto, SongDto } from "@/models/station"
import LowerThird from "./lowerthird";
import { useEffect, useState } from "react";
import { generateUrl } from "@/services/urlservice";

type NowPlayingParams = {
    station: string
}

const NowPlaying = (params: NowPlayingParams) => {
    const [song, setSong] = useState<SongDto | undefined>(undefined);

    useEffect(() => {
        const interval = setInterval(async () => {
            const response = await fetch(generateUrl(`/api/station/${params.station}/nowplaying`));
            const now_playing = await response.json() as NowPlayingDto;
            setSong(now_playing.song);
        }, 1000);
        return () => clearInterval(interval);
    }, [params.station]);

    return <LowerThird song={song} />
}

export default NowPlaying;