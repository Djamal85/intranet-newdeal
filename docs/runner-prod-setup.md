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

## Point bloquant actuel

Le noyau WSL2 classique est bien present, mais Docker Desktop considere encore WSL comme trop ancien sur cette machine.

Indices observes :

- `wsl --status` fonctionne
- `wsl --version` n'est pas reconnu
- `docker version` repond encore `Docker Desktop is unable to start`

Conclusion :

- le runner est pret
- le workflow est pret
- Docker Desktop n'est pas encore valide
- `RUNNER_PROD_READY` doit rester a `false` tant que `docker version` ne repond pas

## Action manuelle a faire plus tard

Installer la version moderne de WSL depuis la release stable Microsoft WSL.

Reference retenue :

- fichier : `wsl.2.6.3.0.x64.msi`
- source : release officielle `microsoft/WSL`
- taille attendue : `247123968` octets
- SHA256 attendu : `562c79aba6ce9b6e9170f069d31e3717f10d76dd8bfbee39b07eae0ca4a02ca0`

Tant que ce MSI n'est pas telecharge completement et installe, il ne faut pas l'utiliser.

## Procedure de reprise plus tard

1. Telecharger completement `wsl.2.6.3.0.x64.msi`.
2. Verifier la taille et le hash.
3. Lancer l'installation en administrateur.
4. Redemarrer Docker Desktop.
5. Verifier :

```powershell
wsl --version
docker version
docker pull djallesjr04/intranet-newdeal:prod
```

6. Activer ensuite la variable GitHub :

```bash
gh variable set RUNNER_PROD_READY --body true --repo Djamal85/intranet-newdeal
```

7. Relancer le workflow `cd-prod`.

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
- le job `deploy_prod` ne reste plus en `skipped`
