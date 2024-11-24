"use client"

import { SongDto } from "@/models/station"
import style from "@/components/lowerthird.module.css";
import { roboto } from "@/fonts";

type LowerThirdParams = {
    song?: SongDto
}

const LowerThird = (params: LowerThirdParams) => {
    return <div className={style.wrapper}>
        <div className={`${style.lowerthird} ${roboto.className}`}>
            <p className={style.title}>Under Pressure</p>
            <p className={style.artist}>Queen and David Bowie (1981)</p>
        </div>
    </div>
}

export default LowerThird;