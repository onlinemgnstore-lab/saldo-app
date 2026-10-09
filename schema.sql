-- Saldo — schema do banco (Supabase / Postgres)
--
-- Como rodar: no painel do seu projeto Supabase, abra "SQL Editor" →
-- "New query", cole este arquivo inteiro e clique em "Run". Só precisa
-- rodar uma vez.
--
-- O que isto cria:
--   1. Tabela "transactions" — todos os lançamentos (receitas/despesas).
--   2. Tabela "billTemplates" — as contas fixas cadastradas (nome entre
--      aspas de propósito: mantém o mesmo nome que o app já usa).
--   3. Row Level Security (RLS) em ambas: cada linha só pode ser lida ou
--      alterada por quem é o dono (user_id = o usuário autenticado) —
--      é essa regra que isola os dados de cada cliente, mesmo todos
--      compartilhando o mesmo banco.

create extension if not exists pgcrypto;

create table if not exists transactions (
  id text primary key default gen_random_uuid()::text,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  type text not null,
  amount numeric not null default 0,
  category text,
  payment_method text,
  gross_amount numeric,
  inss numeric,
  irrf numeric,
  template_id text,
  original_date date,
  estimated boolean not null default false,
  note text,
  date date not null,
  created_at bigint
);

create table if not exists "billTemplates" (
  id text primary key default gen_random_uuid()::text,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  name text not null,
  category text,
  estimated_amount numeric,
  due_day integer,
  type text not null default 'expense'
);

alter table transactions enable row level security;
alter table "billTemplates" enable row level security;

create policy "transactions: dono pode ver" on transactions
  for select using (auth.uid() = user_id);
create policy "transactions: dono pode inserir" on transactions
  for insert with check (auth.uid() = user_id);
create policy "transactions: dono pode atualizar" on transactions
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "transactions: dono pode excluir" on transactions
  for delete using (auth.uid() = user_id);

create policy "billTemplates: dono pode ver" on "billTemplates"
  for select using (auth.uid() = user_id);
create policy "billTemplates: dono pode inserir" on "billTemplates"
  for insert with check (auth.uid() = user_id);
create policy "billTemplates: dono pode atualizar" on "billTemplates"
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "billTemplates: dono pode excluir" on "billTemplates"
  for delete using (auth.uid() = user_id);

create index if not exists transactions_user_date_idx on transactions (user_id, date desc);
create index if not exists billtemplates_user_idx on "billTemplates" (user_id);
