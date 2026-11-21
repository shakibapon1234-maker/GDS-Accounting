# GDS হিসাবখাতা (GDS Accounting)

Galileo, Sabre ও Amadeus Training Mode বিক্রির Purchase/Ledger অ্যাপ।
**Tech:** Single-file HTML + [Supabase](https://supabase.com) (PostgreSQL) — কোনো install লাগে না, যেকোনো PC/মোবাইলের browser থেকে চলে।

## ফিচার

- ✨ কালারফুল গ্রেডিয়েন্ট ডিজাইন
- ☁ Supabase ক্লাউড সিঙ্ক — একবার সেটআপ করলে যেকোনো PC থেকে same ডেটা
- 📒 Ledger: GDS (Galileo/Sabre/Amadeus), Payment method, Access type, date range দিয়ে ফিল্টার
- 🖨 Print / PDF export (browser print → Save as PDF)
- ✏️ Edit / Delete, CSV export, JSON backup/restore
- 🔐 Supabase Auth login — email+password দিয়ে login, anonymous access বন্ধ (RLS authenticated-only)
- 🔌 Supabase set না থাকলে localStorage-এ local mode-এ চলে

## Quick Start (Supabase সেটআপ — একবার)

1. [supabase.com](https://supabase.com)-এ গিয়ে **Start your project** দিয়ে ফ্রি অ্যাকাউন্ট + নতুন project তৈরি করুন (password মনে রাখুন)।
2. Project ready হলে বাম পাশে **SQL Editor** → **New query** → এই repo-র `schema.sql` পুরোটা paste করে **Run** করুন।
   - এতে `purchases` টেবিল, `ledger` view, index, RLS policy তৈরি হবে।
3. বাম পাশে **Project Settings → API** (বা ড্যাশবোর্ডে **Connect**) থেকে নিন:
   - **Project URL**: `https://xxxx.supabase.co`
   - **anon public** key: `eyJhbGciOi...`
4. অ্যাপ খুলুন → header-এ **⚙ Supabase Settings** → URL + key paste করে **সংযোগ পরীক্ষা** → **Save**।
5. অন্য PC-তে: GitHub থেকে `index.html` খুলুন (বা locally চালান), একই settings দিলেই সব ডেটা সিঙ্ক হবে।

## লোকালি চালানো

`index.html` যেকোনো modern browser-এ সরাসরি open করলেই চলে। GitHub Pages-ও লাগবে না — Supabase config দেওয়ার পর `file://`-এও কাজ করে, তবে(schema.sql run করা বাধ্যতামূলক)ের জন্য local server kullanabilirsiniz:

```
npx serve .
```

## নোট

- Database-এ **RLS ON + শুধু `authenticated` role** — publishable key leak হলেও login ছাড়া কেউ data পাবে না।
- প্রথমবার অ্যাপ খুললে **"নতুন অ্যাকাউন্ট"** চাপা দিয়ে email+password দিয়ে register করুন।
- Supabase Dashboard → **Authentication → Sign In / Providers → Email**-এ "Confirm email" বন্ধ রাখলে registration-এ সাথে সাথে login হয়; চালু থাকলে email-এ confirmation link ক্লিক করতে হবে।
- `schema.sql`-এর শেষে sample data আছে (commented) — test করতে uncomment করে Run করুন।
