import LowerThird from "@/components/lowerthird";

type ObsViewParams = {
    station: string
}

const ObsView = async (params: Promise<ObsViewParams>) => {
    const station = (await params).station;

    return <LowerThird />
};

export default ObsView;