-- Run the whole file in Supabase Dashboard > SQL Editor.
-- Admin users must be created in Supabase Auth, then allowlisted in admin_users.
create extension if not exists pgcrypto;

create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(name) between 1 and 120),
  category text not null default 'Other' check (char_length(category) <= 80),
  description text check (description is null or char_length(description) <= 1000),
  price numeric(12,2) not null check (price >= 0),
  compare_at_price numeric(12,2) check (compare_at_price is null or compare_at_price >= 0),
  image_url text check (image_url is null or char_length(image_url) <= 2048),
  stock integer not null default 0 check (stock >= 0),
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists products_active_created_idx on public.products (is_active, created_at desc);

-- All public website text, contact details, links and homepage copy editable from Admin > Website settings.
create table if not exists public.site_settings (
  id boolean primary key default true check (id = true),
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);
insert into public.site_settings (id, data) values (true, '{
  "brand_name":"Madhubani Calibre",
  "logo_url":"/logo.png",
  "theme_green":"#334b3b",
  "theme_red":"#8d2e28",
  "collection_1_name":"Hand-Painted Sarees",
  "collection_1_desc":"Wearable Mithila art",
  "collection_2_name":"Suits & Dupattas",
  "collection_2_desc":"Everyday heritage",
  "collection_3_name":"Mithila Wall Art",
  "collection_3_desc":"Stories for your home",
  "collection_4_name":"Craft & Accessories",
  "collection_4_desc":"Made with tradition",
  "legal_name":"Prasun Mithila Art & Crafts",
  "tagline":"Art • Craft • Clothing",
  "announcement":"AUTHENTIC MITHILA ART · ROOTED IN MADHUBANI, BIHAR",
  "hero_kicker":"A living tradition, made by hand",
  "hero_title":"Wear a story.\nCarry a heritage.",
  "hero_description":"Discover the expressive world of Mithila art through hand-painted sarees, thoughtful clothing and handcrafted pieces inspired by the culture of Madhubani.",
  "hero_image_url":"",
  "story_heading":"Art that belongs to the people.",
  "story_text":"Madhubani Calibre celebrates the colour, symbolism and storytelling of Mithila art. Our work brings this cultural language into clothing, craft and spaces—honouring the artists and the knowledge passed from one generation to the next.\n\nFounded by artist Prasun Kumar, our journey is rooted in sharing art, supporting learning and keeping handmade traditions visible.",
  "commitment_title":"Our commitment",
  "since_text":"Since 1997",
  "learners_text":"15,000+",
  "custom_heading":"Have a custom idea in mind?",
  "custom_description":"For custom sarees, gifts, wall art, bulk enquiries or collaborations, speak to us directly.",
  "contact_email":"madhubanicalibre@gmail.com",
  "phone":"+91 9798406971",
  "whatsapp":"919798406971",
  "instagram":"https://www.instagram.com/madhubanicalibre",
  "youtube":"https://youtube.com/@madhubanicalibre",
  "threads":"https://www.threads.com/@madhubanicalibre",
  "facebook":"https://www.facebook.com/share/17rpuAH9pq/",
  "maps":"https://maps.app.goo.gl/NBTv1sA9WPxTQf6X6",
  "footer_note":"Art • Craft • Clothing"
}') on conflict (id) do nothing;

alter table public.admin_users enable row level security;
alter table public.products enable row level security;
alter table public.site_settings enable row level security;
drop policy if exists "Admins can read own admin row" on public.admin_users;
create policy "Admins can read own admin row" on public.admin_users for select to authenticated using (user_id = (select auth.uid()));
drop policy if exists "Anyone can read active products" on public.products;
create policy "Anyone can read active products" on public.products for select to anon, authenticated using (is_active = true or exists (select 1 from public.admin_users a where a.user_id = (select auth.uid())));
drop policy if exists "Admins can add products" on public.products;
create policy "Admins can add products" on public.products for insert to authenticated with check (exists (select 1 from public.admin_users a where a.user_id = (select auth.uid())));
drop policy if exists "Admins can update products" on public.products;
create policy "Admins can update products" on public.products for update to authenticated using (exists (select 1 from public.admin_users a where a.user_id = (select auth.uid()))) with check (exists (select 1 from public.admin_users a where a.user_id = (select auth.uid())));
drop policy if exists "Admins can delete products" on public.products;
create policy "Admins can delete products" on public.products for delete to authenticated using (exists (select 1 from public.admin_users a where a.user_id = (select auth.uid())));
drop policy if exists "Anyone can read site settings" on public.site_settings;
create policy "Anyone can read site settings" on public.site_settings for select to anon, authenticated using (id = true);
drop policy if exists "Admins can update site settings" on public.site_settings;
create policy "Admins can update site settings" on public.site_settings for update to authenticated using (exists (select 1 from public.admin_users a where a.user_id = (select auth.uid()))) with check (exists (select 1 from public.admin_users a where a.user_id = (select auth.uid())));
create or replace function public.set_updated_at() returns trigger language plpgsql as $$ begin new.updated_at = now(); return new; end; $$;
drop trigger if exists products_set_updated_at on public.products;
create trigger products_set_updated_at before update on public.products for each row execute function public.set_updated_at();
drop trigger if exists site_settings_set_updated_at on public.site_settings;
create trigger site_settings_set_updated_at before update on public.site_settings for each row execute function public.set_updated_at();
