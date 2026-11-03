-- 1) Cria a tabela que guarda o estado da Fantasy.
create table if not exists public.fantasy_state (
  id integer primary key check (id = 1),
  data jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.fantasy_state enable row level security;

-- 2) Todos podem consultar os dados do site.
drop policy if exists "Public can read fantasy state" on public.fantasy_state;
create policy "Public can read fantasy state"
  on public.fantasy_state for select
  to anon, authenticated
  using (true);

-- 3) Apenas utilizadores autenticados cujo app_metadata.role = 'admin' podem gravar.
drop policy if exists "Only fantasy admins can write" on public.fantasy_state;
create policy "Only fantasy admins can write"
  on public.fantasy_state for all
  to authenticated
  using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
  with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

-- 4) Inserção inicial. Os pontos atuais (Jornada 3) são tratados como base histórica.
insert into public.fantasy_state (id, data)
values (1, '{
  "players": [
    {"name":"Kubota","total":309,"scores":{}},
    {"name":"Tetra","total":223,"scores":{}},
    {"name":"Jackass","total":296,"scores":{}},
    {"name":"McNamara","total":254,"scores":{}},
    {"name":"Nélson","total":287,"scores":{}},
    {"name":"Alexandre","total":258,"scores":{}},
    {"name":"Marco","total":206,"scores":{}},
    {"name":"André","total":238,"scores":{}},
    {"name":"Rafa","total":299,"scores":{}},
    {"name":"Nuno","total":217,"scores":{}}
  ],
  "baselineRound": 3,
  "rounds": [],
  "palmares": [
    ["Mundial 2022","Tetra"],
    ["Liga dos Campeões 2023/24","Tetra"],
    ["Euro 2024","Kubota"],
    ["Liga dos Campeões 2024/25","Kubota"],
    ["Mundial de Clubes 2025","Kubota"],
    ["Liga dos Campeões 2025/26","Jackass"],
    ["Mundial 2026","Kubota"],
    ["Liga dos Campeões 2026/27","Em disputa"]
  ],
  "awards": {"mvp":"","mvpRound":0,"moment":"","momentOwner":"","cry":"Tetra","cryRound":3,"cryKing":"Por decidir","cryQuote":"A vestie está-me a rebentar a fantasy"}
}'::jsonb)
on conflict (id) do nothing;

-- 5) Depois de criares o utilizador administrador em Authentication > Users,
-- substitui o email abaixo e executa esta instrução para lhe atribuir o papel admin.
-- update auth.users
-- set raw_app_meta_data = coalesce(raw_app_meta_data, '{}'::jsonb) || '{"role":"admin"}'::jsonb
-- where email = 'O_TEU_EMAIL_AQUI';
