# Madhubani Calibre — Full Control Website

Mobile-responsive Next.js storefront and owner-only admin panel backed by Supabase.

## Editable from Admin
- Add, edit, hide and delete products; set prices, stock, descriptions and image URLs.
- Edit brand name, tagline, announcement, homepage heading/description, hero image URL, story, custom enquiry section, contact details, WhatsApp, social links and footer details.
- Changes are saved in Supabase and shared across devices after setup.

## Security model
- Admin signs in using Supabase Auth email + password. There is no hardcoded default password or public sign-up page.
- Admin must also be allowlisted in `admin_users`.
- RLS policies restrict product writes and site-settings edits to allowlisted admin accounts.
- Never place a Supabase service-role key in browser code.

## Not included yet
Customer accounts, cart/checkout, payment gateway, order dashboard, shipping, direct image upload and automated emails. Product photos currently use a public image URL. Review and test before a public launch.

Follow `SETUP.md` in order.
