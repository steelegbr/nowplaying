import type { Metadata } from "next";
import 'bootstrap/dist/css/bootstrap.css';

export const metadata: Metadata = {
  title: "Now Playing",
  description: "An OBS overlay of Now Playing information",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body>
        {children}
      </body>
    </html>
  );
}
