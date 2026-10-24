
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

const fetcher = (url: string): Promise<NowPlayingDto> =>
    fetch(url).then(res => res.json());

const LowerThird = (params: LowerThirdParams) => {
    const [lastSong, setLastSong] = useState<SongDto>({ artist: "", title: "" });
    const [baseUrl, setBaseUrl] = useState<string>("");

    const { data } = useSWR<NowPlayingDto>(
        generateUrl(baseUrl, `/api/station/${params.station}/nowplaying`),
        fetcher,
        {
            refreshInterval: 1000,
            onSuccess: (response) => {
                if (response.song) {
                    setLastSong(response.song);
                }
            }
        }
    );

    const song = data?.song;

    useEffect(() => {
        if (!baseUrl) {
            getSettings().then((settings) => {
                setBaseUrl(settings.base_url);
            });
        }
    }, [baseUrl]);

    return <div className={style.wrapper}>
        <div className={`${song ? style.lowerthird : style.lowerthirdoff} ${roboto.className}`}>
            <p className={style.title}>{lastSong.title}</p>
            <p className={style.artist}>{lastSong.artist} {lastSong.year ? `(${lastSong.year})` : ""}</p>
        </div>
    </div>
}

export default LowerThird;
