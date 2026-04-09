# Architecture technique

## Vue d'ensemble

Le projet repose sur une architecture volontairement simple, lisible et démontrable à l'oral.

```text
Développeur
   |
   | git push dev
   v
GitHub repository (branches dev / prod)
   |
   +--> Workflow CI (dev)
   |      - build Docker
   |      - scan Trivy
   |      - scan Gitleaks
   |      - push image dev sur Docker Hub
   |      - notification email
   |
   +--> Workflow CD (prod)
          - build Docker
          - security gate Trivy
          - push image prod sur Docker Hub
          - déploiement sur runner_prod
          - notification email
   |
   v
Docker Hub: djallesjr04/intranet-newdeal
   |
   v
Runner self-hosted runner_prod
   |
   v
Conteneur Nginx sur port 80
   |
   v
Site statique intranet institutionnel
```

## Composants

### Front-end statique

- Pages HTML statiques basées sur Forty
- Personnalisation des contenus pour un intranet institutionnel sénégalais
- CSS additionnel pour l'identité visuelle et les composants métiers

### Runtime web

- Nginx pour servir les fichiers statiques
- Configuration simple avec headers de sécurité et cache des assets
- Port exposé: `80`

### Conteneurisation

- Image de référence: `nginx:alpine3.23`
- Image finale: `nginx:alpine3.23-slim`
- Dockerfile sans secret embarqué
- Healthcheck HTTP

### Intégration continue

Sur `dev`, la CI:

- construit l'image
- exporte l'image en artefact
- scanne les vulnérabilités de l'image
- scanne les secrets du dépôt
- pousse l'image sur Docker Hub si les contrôles passent
- envoie une notification email

### Déploiement continu

Sur `prod`, la CD:

- reconstruit l'image depuis la branche de production
- applique un `security gate` Trivy bloquant sur `CRITICAL`
- pousse l'image `prod` sur Docker Hub
- déploie l'image validée via un script adapté à l'OS du runner:
  `scripts/deploy_prod.ps1` sur Windows ou `scripts/deploy_prod.sh` sur Linux
- remplace le conteneur précédent

## Stratégie de tags Docker

- `dev`
- `dev-<sha>`
- `latest-dev`
- `prod`
- `prod-<sha>`

Cette stratégie permet:

- un suivi simple pour la démonstration
- une traçabilité par commit
- un tag stable pour l'exploitation

## Sécurité

- `Trivy` sur les images Docker
- `Gitleaks` sur le dépôt Git
- blocage si vulnérabilité `CRITICAL`
- aucune donnée sensible codée en dur

## Dépendances externes

- GitHub Actions
- Docker Hub
- SMTP pour l'email
- runner self-hosted pour la production
