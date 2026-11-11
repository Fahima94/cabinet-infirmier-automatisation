-- =====================================================================
-- Chantier 1 : fondations sécurisées
-- Cabinet infirmier libéral : demandes de passage, sans donnée de santé
-- Règle n°1 : aucun motif de soin, aucune ordonnance, aucun diagnostic.
-- =====================================================================

-- Rôles dans un cabinet
create type role_membre as enum ('admin', 'associee');

-- Statuts d'une demande (le mot « rendez-vous » est évité côté patient)
create type statut_demande as enum ('nouvelle', 'a_rappeler', 'confirmee', 'refusee');

create table cabinet (
  id          uuid primary key default gen_random_uuid(),
  nom         text not null,
  created_at  timestamptz not null default now()
);

-- Une ligne par personne habilitée ; prévu pour plusieurs associées
create table membre (
  id          uuid primary key default gen_random_uuid(),
  cabinet_id  uuid not null references cabinet(id) on delete cascade,
  user_id     uuid not null references auth.users(id) on delete cascade,
  prenom      text not null,
  role        role_membre not null default 'associee',
  unique (cabinet_id, user_id)
);

-- Demande déposée depuis la landing : le strict nécessaire pour rappeler
create table demande (
  id                uuid primary key default gen_random_uuid(),
  cabinet_id        uuid not null references cabinet(id) on delete cascade,
  prenom            text not null check (char_length(prenom) <= 60),
  telephone         text not null check (telephone ~ '^[0-9 +().-]{8,20}$'),
  commune           text not null check (char_length(commune) <= 80),
  creneau_souhaite  text check (char_length(creneau_souhaite) <= 80),
  source            text default 'landing',          -- ex. 'maps' via ?src=maps
  statut            statut_demande not null default 'nouvelle',
  prise_par         uuid references membre(id),      -- évite les doublons entre associées
  archived_at       timestamptz,                     -- chantier 5 : archive
  created_at        timestamptz not null default now()
);

create index demande_cabinet_statut on demande (cabinet_id, statut) where archived_at is null;

-- ---------------------------------------------------------------------
-- RLS : chaque membre ne voit que son cabinet ; le public ne fait qu'insérer
-- ---------------------------------------------------------------------
alter table cabinet enable row level security;
alter table membre  enable row level security;
alter table demande enable row level security;

create or replace function est_membre(c uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from membre m where m.cabinet_id = c and m.user_id = auth.uid());
$$;

create policy "membre lit son cabinet" on cabinet
  for select to authenticated using (est_membre(id));

create policy "membre lit son équipe" on membre
  for select to authenticated using (est_membre(cabinet_id));

-- Le formulaire public peut déposer une demande, et rien d'autre
create policy "public dépose une demande" on demande
  for insert to anon
  with check (statut = 'nouvelle' and prise_par is null and archived_at is null);

create policy "membre lit les demandes du cabinet" on demande
  for select to authenticated using (est_membre(cabinet_id));

create policy "membre traite les demandes du cabinet" on demande
  for update to authenticated
  using (est_membre(cabinet_id)) with check (est_membre(cabinet_id));

-- Pas de policy delete : aucune suppression depuis l'application.
-- Rappel : la clé service_role (Make, n8n) contourne la RLS. Elle reste côté serveur,
-- et les automatisations n'écrivent que les champs dont elles ont besoin.
