-- Rode isso uma vez no Supabase: painel do projeto > SQL Editor > New query > colar e "Run".

create table if not exists kv_store (
  key text primary key,
  value text not null,
  updated_at timestamptz default now()
);

-- RLS ligado (recomendado pelo Supabase), mas com políticas totalmente abertas,
-- já que o painel foi combinado para ficar acessível sem senha (link aberto).
alter table kv_store enable row level security;

drop policy if exists "kv_store_public_select" on kv_store;
create policy "kv_store_public_select" on kv_store
  for select using (true);

drop policy if exists "kv_store_public_insert" on kv_store;
create policy "kv_store_public_insert" on kv_store
  for insert with check (true);

drop policy if exists "kv_store_public_update" on kv_store;
create policy "kv_store_public_update" on kv_store
  for update using (true);

drop policy if exists "kv_store_public_delete" on kv_store;
create policy "kv_store_public_delete" on kv_store
  for delete using (true);

-- Índice pra acelerar o list(prefix) usado no app (busca por "coummar_file_v1:%")
create index if not exists kv_store_key_prefix_idx on kv_store (key text_pattern_ops);
