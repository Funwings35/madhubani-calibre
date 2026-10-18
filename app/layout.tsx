import type { Metadata } from 'next';
import './globals.css';
export const metadata: Metadata = {
  title: 'Madhubani Calibre | Authentic Mithila Art & Clothing',
  description: 'Discover hand-painted sarees, clothing and authentic Mithila art from Madhubani Calibre.',
  metadataBase: new URL('https://example.com')
};
export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return <html lang="en"><body>{children}</body></html>;
}
