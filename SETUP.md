# Madhubani Calibre — secure starter (Phase 1)

This is a Next.js + Supabase starter for a public storefront and a private product-admin area. It is **not yet a complete online shop**: checkout, payments, orders, shipping, tax invoices, returns, image uploads, transactional email, monitoring and production security review still need to be added before taking online orders.

## What is included
- Responsive storefront with Madhubani Calibre branding, collections, story and contact links.
- Product catalogue loaded from Supabase.
- Email/password admin login (no public sign-up page).
- Admin role checked against `admin_users`; product CRUD uses Supabase Row Level Security (RLS).
- Basic browser security headers and `.env` exclusion from Git.

## What you need
- A computer with Node.js 20+ and npm installed.
- A Supabase account/project.
- A Vercel account (or another Node.js host) when ready to publish.
- VS Code is recommended.

## Local setup
1. Extract the ZIP and open this folder in VS Code.
2. Open a terminal in this folder and run `npm install`.
3. In Supabase, create a project. Open **Project Settings → API** (or Connect) and copy the project URL and the publishable/anon key. These are the only values used by this browser app; **never put a service-role/secret key in a `NEXT_PUBLIC_` variable or in frontend code**.
4. Copy `.env.example` to `.env.local`, then replace the two placeholder values:
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
5. In Supabase Dashboard → SQL Editor, run the complete `supabase/schema.sql` file.
6. In Supabase Dashboard → Authentication → Users, create your own user with a strong unique password. Keep public sign-ups disabled. If you enable email confirmation, confirm this user first.
7. In Authentication → Users, copy the new user's UUID. In SQL Editor run this command, replacing the example UUID with your own:

   ```sql
   insert into public.admin_users (user_id)
   values ('PASTE-YOUR-AUTH-USER-UUID-HERE');
   ```

   Do not share that UUID or your password publicly. Only add trusted administrators to `admin_users`.
8. Start the website with `npm run dev` and open `http://localhost:3000`. Visit `/login` to sign in, then use `/admin` to add products.
9. Run `npm run build` before deployment to check for build errors.

## Adding product photos
For this starter, use a publicly accessible HTTPS image URL in the Image URL field. Use only photos you own or are authorized to use. A later phase can add Supabase Storage uploads with bucket-specific policies.

## Deploying
1. Push the project to a private GitHub repository (never commit `.env.local`).
2. Import the repository into Vercel.
3. Add the same two environment variables in Vercel project settings for Production and Preview as appropriate.
4. Deploy, then test the live storefront, admin login, add/edit/delete product, sign-out, and unauthorized access.
5. Use a real domain and ensure HTTPS. Before real customers/payments, review auth settings, backups, monitoring, rate limiting, privacy/terms/returns pages, Indian consumer and tax requirements, and security testing.

## Security notes
- RLS policies are the actual database gate; hiding buttons in the UI is not security.
- Admin role assignment is manual and server-side enforced by database policies.
- Never put a Supabase service-role key, payment secret, SMTP password, or other secret in frontend code, Git, screenshots, or public messages.
- Use MFA for administrator accounts where available and a password manager.
- No code can guarantee zero hacking risk. Keep dependencies updated, back up data, and test before launch.

## Known first-phase limits
- No shopping cart/checkout, payments, orders, shipping, discounts, returns, customer accounts or inventory reservation.
- Product image URL only; no upload manager yet.
- No automated test suite has been run in this generated package. Install dependencies and run `npm run build` locally; resolve any version/build issues before deployment.
- The storefront's visual hero is a CSS illustration, not a photograph of your actual products. Replace with licensed product photography before launch.


## Full-control admin panel (additional setup notes)
1. Run the **latest full** `supabase/schema.sql` in Supabase SQL Editor. It creates `site_settings` as well as products and RLS rules.
2. In Supabase Dashboard → Authentication → Users, create the owner user using your email and a strong unique password. Do not create a public sign-up flow.
3. Copy that user's UUID. In SQL Editor run: `insert into public.admin_users (user_id) values ('PASTE-OWNER-UUID-HERE');` Replace the example with your actual UUID before running. Never paste your password into SQL.
4. In the project folder, copy `.env.example` to `.env.local`, then enter your Supabase Project URL and **anon/publishable key**. Do not use the service-role key. Restart the dev server after editing env variables.
5. Run `npm install`, then `npm run dev`, and open `http://localhost:3000`. Login at `/login`, then open `/admin`.
6. Use **Edit website content & links** to edit homepage text, brand, contact, WhatsApp, social links and hero image URL. Use **Products** to manage products.
7. To use it on both mobile and laptop outside your home network, deploy it to HTTPS hosting (for example Vercel) and configure the same environment variables there. A localhost URL only works on the computer running it.

### Important
- Admin password is your Supabase Auth password; login username is the email address you created in Supabase.
- Enable MFA where available and use a unique password. Keep recovery email secure.
- Public website settings are intentionally readable by visitors; only authorized admins can edit them. Never store private keys, passwords, customer secrets or internal notes in site settings.
- Before live sales, add and test cart, order management, payment gateway, shipping/tax, privacy/return policies and image storage. No website can be guaranteed 100% hack-proof.

Additional editable controls: logo URL, two theme colours, and the four collection card titles/descriptions are editable from Website settings. The uploaded brand logo is included at `/logo.png`.
