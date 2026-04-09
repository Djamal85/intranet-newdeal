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
- documentation principale et rapport `.docx` deja rediges

## Ce qui est pret mais pas encore active

- envoi reel d'email dans GitHub Actions
- deploiement production reel sur le runner Windows

## Pourquoi le deploiement prod n'est pas encore lance

Le job `deploy_prod` est volontairement garde en `skipped` car :

- le runner est en ligne
- le workflow est pret
- mais Docker Desktop n'est pas encore valide sur la machine du runner

Tant que ce point n'est pas regle, la variable GitHub `RUNNER_PROD_READY` doit rester a `false`.

## Point technique a reprendre plus tard

L'etape a finaliser plus tard concerne WSL moderne et Docker Desktop sur Windows.

Reference documentee :

- MSI moderne attendu : `wsl.2.6.3.0.x64.msi`
- taille attendue : `247123968` octets
- SHA256 attendu : `562c79aba6ce9b6e9170f069d31e3717f10d76dd8bfbee39b07eae0ca4a02ca0`

Une fois cette etape terminee, il faudra :

1. verifier `wsl --version`
2. verifier `docker version`
3. passer `RUNNER_PROD_READY` a `true`
4. relancer le workflow `cd-prod`

## Message de soutenance recommande

Le projet est complet sur les volets code, CI, securite, Docker Hub, documentation et preparation du runner. La seule etape reportee est la validation finale du moteur Docker du runner Windows, afin de ne pas simuler un deploiement reel non observe.
