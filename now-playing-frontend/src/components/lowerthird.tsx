"use client"

import { SongDto } from "@/models/station"
import style from "@/components/lowerthird.module.css";
import { roboto } from "@/fonts";
import { useState } from "react";

type LowerThirdParams = {
    song?: SongDto
}

const LowerThird = (params: LowerThirdParams) => {
    const [lastSong, setLastSong] = useState<SongDto>({ artist: "", title: "" });

    if (params.song) {
        setLastSong(params.song);
    }

    return <div className={style.wrapper}>
        <div className={`${params.song ? style.lowerthird : style.lowerthirdoff} ${roboto.className}`}>
            <p className={style.title}>{lastSong.title}</p>
            <p className={style.artist}>{lastSong.artist} {lastSong.year ? `(${lastSong.year})` : ""}</p>
        </div>
    </div>
}

export default LowerThird;