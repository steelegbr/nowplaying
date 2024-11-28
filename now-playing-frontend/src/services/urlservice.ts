import { Settings } from "@/models/settings";

export const generateUrl = (base_url: string, path: string) => {
    return `${base_url}${path}`
}

export const getSettings = async () => {
    const response = await fetch("/settings.json");
    return await response.json() as Settings;
}