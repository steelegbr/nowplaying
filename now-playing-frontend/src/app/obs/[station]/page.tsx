import NowPlaying from "@/components/nowplaying";

type ObsViewParams = {
    params: Promise<{ station: string }>
}

const ObsView = async (params: ObsViewParams) => {
    const station = (await params.params).station;

    return <NowPlaying station={station} />
};

export default ObsView;