# 🩺 Cabinet infirmier libéral : être joignable, organisé et notifié, sans donnée de santé

![Supabase](https://img.shields.io/badge/Supabase-3FCF8E?style=flat-square&logo=supabase&logoColor=white)
![WhatsApp](https://img.shields.io/badge/WhatsApp_Business_API-25D366?style=flat-square&logo=whatsapp&logoColor=white)
![Google Workspace](https://img.shields.io/badge/Google_Agenda_·_Maps_·_Sheets-4285F4?style=flat-square&logo=google&logoColor=white)
![Lovable](https://img.shields.io/badge/Prototype-Lovable-FF6B6B?style=flat-square)
![Statut](https://img.shields.io/badge/Statut-Chantier_1_en_cours-orange?style=flat-square)

> **Mission freelance (Horizons Datas), de l'audit au cadrage puis à la construction.**
> Deux infirmières libérales associées, spécialisées dans le suivi des patients chroniques, perdaient des patients faute d'être **trouvables** et **joignables**. Leur organisation tenait sur un agenda papier, une note partagée et WhatsApp.

*Projet anonymisé : aucun nom, aucune donnée de patient dans ce dépôt.*

---

## 🖥️ Démonstration en ligne

**[Ouvrir la démonstration](https://fahima94.github.io/cabinet-infirmier-automatisation/)** — données fictives, aucun nom ni information de santé.

- **Tournée du jour horodatée** : neuf passages sur Ivry-sur-Seine, Vitry-sur-Seine et Choisy-le-Roi, avec temps de soin sur place, temps de trajet et heures d'arrivée calculées.
- **Mode de déplacement** : en voiture (+10 min de stationnement par passage) ou en trottinette, avec recalcul immédiat de la fin de tournée.
- **Vue carte** : ordre des passages, tracé du trajet, itinéraire Google Maps et Waze à chaque étape.
- **Frais** : kilomètres multipliés par un barème modifiable, plus le stationnement, prêts pour la note de frais.
- **Validation pour facturation** : les actes, les kilomètres et les frais sont figés au moment de la validation, avec date et heure.
- **Envoi à l'infirmière** : planning complet et notes urgentes transmis par WhatsApp en un clic.

## 🔍 Ce que l'audit a montré

La demande de départ était « une application ». L'entretien terrain a montré que **le premier besoin était ailleurs**.

| Constat | Conséquence |
|---|---|
| Le cabinet est introuvable en ligne sans fiche Google | Les patients appellent rarement en direct, tout passe par une plateforme tierce |
| Chaque nouveau patient impose un rappel téléphonique | Du temps pris entre deux soins, en pleine tournée |
| L'information est éparpillée : papier, note partagée, WhatsApp | Risque d'oubli, pas de vision commune entre associées |
| Ce sont des données de santé | Tout outil doit rester conforme RGPD |

## ⚖️ La décision qui structure tout : pas d'hébergement HDS

Un hébergement certifié données de santé (HDS) coûterait plus cher qu'un logiciel du marché pour un cabinet de deux personnes. **J'ai donc choisi de concevoir un outil qui ne touche à aucune donnée de santé :**
- le médical reste dans la plateforme métier déjà utilisée par le cabinet ;
- l'outil ne gère que **prénom, téléphone, commune, créneau souhaité** ;
- les messages WhatsApp ne contiennent **jamais** de motif de soin.

## 🏗️ Architecture cible

```
Fiche Google Maps ──► Landing (charte lisible par des seniors)
                          │  demande de passage
                          ▼
                 Supabase : auth · rôles · RLS
                 table demande (nouvelle → à rappeler → confirmée / refusée → archive)
                    │                    │                        │
                    ▼                    ▼                        ▼
            WhatsApp Business      Google Agenda          Google Maps : « Ma tournée »
            (notification,         (passage confirmé :    passages du jour dans l'ordre,
             confirmation)          prénom, créneau)      itinéraire en un geste
```

**Google Maps sert deux fois :** pour être **trouvé** (la fiche du cabinet) et pour **organiser les tournées** (les passages du jour placés sur la carte, dans l'ordre, avec l'itinéraire). C'est ce second usage qui remplace le cahier papier.

## 🗺️ Plan d'action : Epic › Features › Tickets

**Epic : un cabinet infirmier joignable, organisé et notifié sur WhatsApp, sans donnée de santé.**

| # | Feature | Contenu | Statut |
|---|---|---|---|
| 1 | **Fondations sécurisées** | Auth, rôles admin / associée, RLS, table des demandes | 🟠 en cours ([schéma](supabase/migrations/001_fondations.sql)) |
| 2 | **Être trouvé** | Landing à la charte du cabinet, lien depuis la fiche Google | 🟡 prototype Lovable fait |
| 3 | **Recevoir les demandes** | Formulaire relié à Supabase, statuts | ⚪ à faire |
| 4 | **Notifier sur WhatsApp** | Compte Meta et modèles, notification, confirmation en un geste | ⚪ à faire |
| 5 | **Travailler à deux** | Une demande prise par l'une apparaît prise chez l'autre | ⚪ à faire |
| 6 | **Organiser les tournées avec Google Maps** | Passages du jour sur la carte, ordre de passage, itinéraire ; export Agenda | ⚪ à faire |
| 7 | **Archiver** | Demandes traitées archivées, durée de conservation RGPD | ⚪ à faire |

Le détail ticket par ticket est dans [docs/TICKETS.md](docs/TICKETS.md).

## 📅 Historique

| Date | Étape |
|---|---|
| Sept. 2026 | Entretien terrain et audit des besoins |
| 21 sept. 2026 | Fiche Google Business créée (en attente de validation) |
| Sept. 2026 | v0 : formulaire de demande relié à un tableau privé · prototype de landing sous Lovable |
| Nov. 2026 | Arbitrage HDS (refus) · tickets WhatsApp et « Ma tournée » · offre de service définie |
| Nov. 2026 | Chantier 1 : schéma Supabase et règles RLS |

## 🔐 Sécurité, en bref

- **RLS sur toutes les tables** : une associée ne voit que les demandes de son cabinet.
- **Le public peut seulement déposer** une demande, jamais la lire ni la modifier.
- **Aucune suppression** depuis l'application.
- La clé `service_role` des automatisations reste côté serveur, car elle contourne la RLS.

## 🧭 Méthode

Travail **au ticket**, chaque ticket confié à un seul agent IA spécialisé (Designer, Dev Supabase, Sécurité & RGPD, Automatisation, Recettage), avec recette avant chaque livraison. C'est la même structure que mon dossier de mission MediConnect.

## 💡 Ce que ce projet montre

- **Le terrain avant l'outil** : l'audit a déplacé le besoin d'« une app » vers « être joignable ».
- **La conformité comme critère de conception**, pas comme contrôle final.
- **Une offre réplicable** à d'autres cabinets infirmiers.

---

<div align="center">

**Fahima Behillil** · Cheffe de projet IA & Automatisation · *Business Tech Bridge*

[LinkedIn](https://www.linkedin.com/in/fahima-be/) · [Prendre RDV (Horizons Datas)](https://calendly.com/horizonsdatas/30min) · [Tous mes projets](https://github.com/Fahima94)

</div>
