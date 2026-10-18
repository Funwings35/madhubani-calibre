import { createClient } from '@supabase/supabase-js';

const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
const anonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

export function getSupabase() {
  if (!url || !anonKey) return null;
  return createClient(url, anonKey, {
    auth: { persistSession: true, autoRefreshToken: true, detectSessionInUrl: true }
  });
}

export type Product = {
  id: string;
  name: string;
  category: string;
  description: string | null;
  price: number;
  compare_at_price: number | null;
  image_url: string | null;
  stock: number;
  is_active: boolean;
  created_at?: string;
};

export type SiteSettings = { [key: string]: string };

export const defaultSettings: SiteSettings = {
 brand_name: 'Madhubani Calibre', logo_url: '/logo.png', theme_green: '#334b3b', theme_red: '#8d2e28', collection_1_name: 'Hand-Painted Sarees', collection_1_desc: 'Wearable Mithila art', collection_2_name: 'Suits & Dupattas', collection_2_desc: 'Everyday heritage', collection_3_name: 'Mithila Wall Art', collection_3_desc: 'Stories for your home', collection_4_name: 'Craft & Accessories', collection_4_desc: 'Made with tradition', legal_name: 'Prasun Mithila Art & Crafts', tagline: 'Art • Craft • Clothing',
 announcement: 'AUTHENTIC MITHILA ART · ROOTED IN MADHUBANI, BIHAR', hero_kicker: 'A living tradition, made by hand',
 hero_title: 'Wear a story.\nCarry a heritage.', hero_description: 'Discover the expressive world of Mithila art through hand-painted sarees, thoughtful clothing and handcrafted pieces inspired by the culture of Madhubani.',
 hero_image_url: '', story_heading: 'Art that belongs to the people.', story_text: 'Madhubani Calibre celebrates the colour, symbolism and storytelling of Mithila art.\n\nFounded by artist Prasun Kumar, our journey is rooted in sharing art and keeping handmade traditions visible.', commitment_title: 'Our commitment', since_text: 'Since 1997', learners_text: '15,000+', custom_heading: 'Have a custom idea in mind?', custom_description: 'For custom sarees, gifts, wall art, bulk enquiries or collaborations, speak to us directly.', contact_email: 'madhubanicalibre@gmail.com', phone: '+91 9798406971', whatsapp: '919798406971', instagram: 'https://www.instagram.com/madhubanicalibre', youtube: 'https://youtube.com/@madhubanicalibre', threads: 'https://www.threads.com/@madhubanicalibre', facebook: 'https://www.facebook.com/share/17rpuAH9pq/', maps: 'https://maps.app.goo.gl/NBTv1sA9WPxTQf6X6', footer_note: 'Art • Craft • Clothing'
};
