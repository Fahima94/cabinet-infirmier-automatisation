# Tickets

Un ticket = une action confiée à un seul agent, recettée avant d'être fermée.
Règle permanente : **aucune donnée de santé** (ni motif de soin, ni ordonnance) dans l'outil ou les messages.

## Feature 1 · Fondations sécurisées
- [x] Schéma : `cabinet`, `membre`, `demande` · statuts · champ d'archive — *Dev Supabase*
- [x] RLS : lecture et mise à jour limitées au cabinet du membre, dépôt public en insertion seule — *Sécurité & RGPD*
- [ ] Authentification des associées (lien magique par e-mail) — *Dev Supabase*
- [ ] Recette : un compte d'un autre cabinet ne voit rien, le public ne lit rien — *Recettage*

## Feature 2 · Être trouvé
- [x] Prototype de landing (Lovable) : appel en action principale, demande en ligne en secondaire — *Designer*
- [ ] Landing à la charte du cabinet : grands caractères, fort contraste, police Atkinson Hyperlegible — *Designer*
- [ ] Lien depuis la fiche Google avec `?src=maps` pour mesurer la provenance — *Dev*

## Feature 3 · Recevoir les demandes
- [ ] Formulaire relié à la table `demande` (prénom, téléphone, commune, créneau souhaité) — *Dev*
- [ ] Espace équipe : liste des demandes, changement de statut — *Dev*

## Feature 4 · Notifier sur WhatsApp
- [ ] T13 · Compte Meta WhatsApp Business et modèles de messages validés — *Automatisation* — **à lancer en premier (délai de validation)**
- [ ] T14 · Notification de chaque nouvelle demande, e-mail en secours — *Automatisation*
- [ ] T15 · Confirmation en un geste + message de confirmation au patient — *Dev + Automatisation*

## Feature 5 · Travailler à deux
- [ ] T16 · Une demande prise par l'une apparaît prise chez l'autre (`prise_par`) — *Dev Supabase*

## Feature 6 · Organiser les tournées avec Google Maps
- [x] Schéma : adresse, date de passage et ordre de tournée sur chaque demande confirmée — *Dev Supabase*
- [ ] Adresse vérifiée par l'API Google Maps à la confirmation (géocodage) — *Dev*
- [ ] T17 · Vue « Ma tournée » : passages du jour sur la carte, dans l'ordre, bouton Itinéraire vers Maps ou Waze — *Dev + Designer*
- [ ] Ordre de passage proposé par Google Maps (itinéraire optimisé), modifiable par l'infirmière — *Automatisation*
- [ ] Passage confirmé → événement Google Agenda (prénom, commune, créneau, rien d'autre) — *Automatisation*

## Feature 7 · Archiver
- [ ] Archivage automatique des demandes traitées (`archived_at`) — *Dev Supabase*
- [ ] Durée de conservation RGPD et purge des demandes archivées — *Sécurité & RGPD*

## Version suivante
- [ ] T18 · Rappel automatique au patient la veille — *Automatisation*
- [ ] T19 · Espace équipe installable sur le téléphone (PWA) — *Dev*

## Règles WhatsApp
- API officielle WhatsApp Business uniquement
- Modèles de messages validés par Meta
- Contenu minimal : prénom, commune, créneau, lien — jamais de motif de soin
- Quota mensuel de messages par cabinet
