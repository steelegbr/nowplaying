import LowerThird from "@/components/lowerthird";

type ObsViewParams = {
    params: Promise<{ station: string }>
}

const ObsView = async (params: ObsViewParams) => {
    const station = (await params.params).station;

    return <LowerThird station={station} />
};

export default ObsView;