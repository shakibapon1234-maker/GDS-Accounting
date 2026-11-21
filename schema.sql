-- ============================================================
-- GDS Accounting — Supabase Schema
-- Supabase Dashboard > SQL Editor-এ পুরোটা paste করে Run করুন
-- ============================================================

create extension if not exists "pgcrypto";

create table if not exists public.purchases (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,
  phone       text not null,
  address     text,
  amount      numeric(12,2) not null default 0,
  payment     text not null,
  purchased_on date not null default current_date,
  access      text not null default 'Lifetime',        -- 'Lifetime' | 'Limited'
  days        integer,
  gds         text[] not null default '{}',            -- e.g. {'Galileo','Amadeus'}
  note        text,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create index if not exists purchases_purchased_on_idx on public.purchases (purchased_on desc);
create index if not exists purchases_gds_idx on public.purchases using gin (gds);

-- updated_at auto-update
create or replace function public.touch_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end $$;

drop trigger if exists purchases_touch on public.purchases;
create trigger purchases_touch before update on public.purchases
  for each row execute function public.touch_updated_at();

-- Ledger view (filters apply on top of this)
create or replace view public.ledger as
select
  id, purchased_on as date, name, phone, address,
  amount, payment, access, days, gds, note, created_at
from public.purchases
order by purchased_on desc, created_at desc;

-- ============================================================
-- Row Level Security
-- Personal/small-business app: anonymous access allowed.
-- (Secure করতে চাইলে Supabase Auth চালু করে policies বদলাবেন)
-- ============================================================
alter table public.purchases enable row level security;

drop policy if exists "anon all purchases" on public.purchases;
create policy "anon all purchases" on public.purchases
  for all using (true) with check (true);

-- ============================================================
-- Sample data (optional — test করতে)
-- ============================================================
-- insert into public.purchases (name, phone, amount, payment, purchased_on, access, days, gds, note)
-- values
--   ('রহিম উদ্দিন', '01712345678', 2500, 'bKash', current_date, 'Lifetime', null, '{Galileo,Sabre}', 'ID: G123'),
--   ('করিম bissas', '01812345678', 1500, 'Nagad', current_date - 5, 'Limited', 30, '{Amadeus}', null);
