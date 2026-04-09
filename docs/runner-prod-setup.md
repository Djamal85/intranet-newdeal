# Runner `runner_prod`

## Objectif

Configurer un runner GitHub Actions self-hosted dedie au deploiement de la branche `prod`.

## Cible retenue pour ce projet

Le runner actuellement configure pour le depot `Djamal85/intranet-newdeal` est une machine Windows avec:

- GitHub Actions Runner installe localement
- label personnalise `runner_prod`
- Docker Desktop comme moteur Docker
- WSL2 requis pour les conteneurs Linux

Le workflow `cd-prod.yml` a ete adapte pour accepter:

- `scripts/deploy_prod.ps1` sur Windows
- `scripts/deploy_prod.sh` sur Linux

## Creation du runner Windows

Dans le depot GitHub:

1. Aller dans `Settings`
2. Ouvrir `Actions`
3. Ouvrir `Runners`
4. Cliquer sur `New self-hosted runner`
5. Choisir `Windows`

## Commandes type sur la machine Windows

Creer un dossier dedie, par exemple:

```powershell
New-Item -ItemType Directory -Force C:\Users\user\actions-runner-runner_prod
Set-Location C:\Users\user\actions-runner-runner_prod
```

Telecharger l'archive du runner puis decompresser:

```powershell
Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v2.333.1/actions-runner-win-x64-2.333.1.zip -OutFile actions-runner-win-x64-2.333.1.zip
Expand-Archive .\actions-runner-win-x64-2.333.1.zip -DestinationPath .
```

Configurer le runner:

```powershell
.\config.cmd --url https://github.com/Djamal85/intranet-newdeal --token <TOKEN> --name runner_prod --labels runner_prod --unattended --replace --work _work
```

Lancer le runner en interactif:

```powershell
.\run.cmd
```

## Verification cote GitHub

Le workflow attend exactement:

```yaml
runs-on:
  - self-hosted
  - runner_prod
```

Le runner doit donc etre visible `online` dans GitHub avec le label `runner_prod`.

## Docker sur le runner Windows

Le runner doit pouvoir executer:

```powershell
docker version
docker pull djallesjr04/intranet-newdeal:prod
```

Si `docker version` repond `Docker Desktop is unable to start`, verifier les points suivants:

- Docker Desktop est ouvert
- le moteur Linux Docker Desktop est demarre
- WSL2 est installe
- le noyau WSL2 est a jour

Commande utile:

```powershell
wsl --status
wsl --update
```

Sur cette machine, `wsl --update` a detecte qu'une elevation administrateur etait necessaire. Tant que cette mise a jour n'est pas faite, Docker Desktop reste bloque en phase `starting`.

## Variable GitHub a activer ensuite

Quand le runner est en ligne et que Docker repond correctement, activer la variable GitHub suivante:

```bash
gh variable set RUNNER_PROD_READY --body true --repo Djamal85/intranet-newdeal
```

## Verifications avant soutenance

- le runner est `online` dans GitHub
- `docker version` fonctionne sur la machine du runner
- le port `80` est libre ou correctement redirige
- la machine peut telecharger l'image Docker Hub
- la variable `RUNNER_PROD_READY` est a `true`
