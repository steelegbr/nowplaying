export const generateUrl = (path: string) => {
    return `${process.env.NEXT_PUBLIC_BASE_URL}${path}`
}