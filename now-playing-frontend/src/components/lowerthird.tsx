"use client"

import { NowPlayingDto, SongDto } from "@/models/station"
import style from "@/components/lowerthird.module.css";
import { roboto } from "@/fonts";
import { useEffect, useState } from "react";
import useSWR from "swr";
import { generateUrl, getSettings } from "@/services/urlservice";

type LowerThirdParams = {
    station: string
}

const fetcher = (url: string) => fetch(url).then(res => res.json())

const LowerThird = (params: LowerThirdParams) => {
    const [lastSong, setLastSong] = useState<SongDto>({ artist: "", title: "" });
    const [song, setSong] = useState<SongDto | undefined>(undefined);
    const [baseUrl, setBaseUrl] = useState<string>("");

    const { data, isLoading } = useSWR(
        generateUrl(baseUrl, `/api/station/${params.station}/nowplaying`),
        fetcher,
        { refreshInterval: 1000 }
    );

    useEffect(() => {
        if (!isLoading) {
            const api_song = (data as NowPlayingDto).song;
            setSong(api_song);

            if (api_song) {
                setLastSong(api_song);
            }
        }
    }, [data, isLoading]);

    useEffect(() => {
        if (!baseUrl) {
            getSettings().then(
                (settings) => {
                    setBaseUrl(settings.base_url);
                }
            );
        }
    }, [baseUrl])

    return <div className={style.wrapper}>
        <div className={`${song ? style.lowerthird : style.lowerthirdoff} ${roboto.className}`}>
            <p className={style.title}>{lastSong.title}</p>
            <p className={style.artist}>{lastSong.artist} {lastSong.year ? `(${lastSong.year})` : ""}</p>
        </div>
    </div>
}

export default LowerThird;