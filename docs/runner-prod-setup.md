# Runner `runner_prod`

## Objectif

Configurer un runner GitHub Actions self-hosted dedie au deploiement de la branche `prod`.

## Statut actuel

Au 2026-04-09, le runner `runner_prod` est deja :

- enregistre dans le depot `Djamal85/intranet-newdeal`
- visible `online` dans GitHub
- etiquete `runner_prod`
- compatible avec le workflow `cd-prod.yml`

Le workflow de production a ete adapte pour accepter :

- `scripts/deploy_prod.ps1` sur Windows
- `scripts/deploy_prod.sh` sur Linux

## Machine cible retenue

La machine actuellement preparee pour ce projet est une machine Windows avec :

- GitHub Actions Runner installe localement
- Docker Desktop
- WSL2 pour les conteneurs Linux

## Ce qui a deja ete fait

- installation du runner GitHub Actions
- enregistrement du runner avec le label `runner_prod`
- verification du statut `online`
- adaptation du workflow `cd-prod.yml` au cas Windows
- ajout du script `scripts/deploy_prod.ps1`
- installation du noyau WSL2 classique via `wsl --update`
- installation de WSL moderne `2.6.3`
- validation de `docker version`
- execution reelle du job `deploy_prod` avec succes

## Etat actuel

Le runner de production est maintenant completement operationnel.

Verifications validees :

```powershell
wsl --version
docker version
docker pull djallesjr04/intranet-newdeal:prod
```

La variable GitHub suivante a egalement ete activee :

```bash
gh variable set RUNNER_PROD_READY --body true --repo Djamal85/intranet-newdeal
```

## Rappel du ciblage GitHub Actions

Le workflow attend exactement :

```yaml
runs-on:
  - self-hosted
  - runner_prod
```

Le runner doit donc rester visible `online` dans GitHub avec le label `runner_prod`.

## Verifications avant soutenance

- le runner est `online` dans GitHub
- le job `security_gate` passe sur `prod`
- `docker version` fonctionne sur la machine du runner
- la machine peut telecharger l'image Docker Hub
- `RUNNER_PROD_READY` est passe a `true`
- le job `deploy_prod` passe en succes
