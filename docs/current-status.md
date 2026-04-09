# Etat actuel du projet

Date de reference : `2026-04-09`

## Ce qui est termine

- site intranet statique personnalise et integre
- conteneurisation Nginx avec `nginx:alpine3.23-slim`
- workflow `ci-dev` cree et valide
- workflow `cd-prod` cree et valide
- scan Trivy et scan Gitleaks operationnels
- push Docker Hub operationnel
- repo GitHub cree : `Djamal85/intranet-newdeal`
- repo Docker Hub cree : `djallesjr04/intranet-newdeal`
- runner self-hosted `runner_prod` en ligne
- WSL moderne installe sur la machine Windows du runner
- Docker Desktop valide sur la machine du runner
- deploiement production execute avec succes
- documentation principale et rapport `.docx` deja rediges

## Ce qui est pret mais pas encore active

- envoi reel d'email dans GitHub Actions

## Etat du deploiement production

- le job `deploy_prod` est maintenant valide
- la variable `RUNNER_PROD_READY` est activee
- le conteneur de production peut etre redeploye depuis la branche `prod`

## Point technique reporte a plus tard

Le seul point reporte concerne la configuration SMTP pour l'envoi d'email automatique.

## Message de soutenance recommande

Le projet est complet sur les volets code, CI, CD, securite, Docker Hub, documentation et deploiement. La seule etape encore non activee est l'envoi automatique d'email, faute de secrets SMTP configures.
