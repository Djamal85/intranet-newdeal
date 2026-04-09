# Troubleshooting

## Docker ne demarre pas localement

Symptome :

- `docker build` ou `docker run` echoue
- `docker version` repond `Docker Desktop is unable to start`

Actions :

- verifier que Docker Desktop est lance
- executer `docker version`
- executer `wsl --status`
- redemarrer Docker Desktop si necessaire

## Docker Desktop reste bloque sur la machine du runner

Symptome :

- le runner `runner_prod` est `online`
- `docker version` echoue encore
- `wsl --version` n'est pas reconnu

Actions :

1. verifier que le noyau WSL2 classique est installe :

```powershell
wsl --status
```

2. si le noyau WSL2 est absent, executer :

```powershell
wsl --update
```

3. si `wsl --version` reste indisponible, installer plus tard la release moderne officielle Microsoft WSL :

- fichier attendu : `wsl.2.6.3.0.x64.msi`
- taille attendue : `247123968` octets
- SHA256 attendu : `562c79aba6ce9b6e9170f069d31e3717f10d76dd8bfbee39b07eae0ca4a02ca0`

4. installer ce MSI en administrateur
5. redemarrer Docker Desktop
6. verifier ensuite :

```powershell
wsl --version
docker version
```

Statut dans ce projet :

- ce point a ete corrige
- WSL moderne est installe
- Docker Desktop repond correctement

## Le push Docker Hub echoue

Symptome :

- echec du job `push_dockerhub`

Actions :

- verifier `DOCKERHUB_USERNAME`
- verifier `DOCKERHUB_TOKEN`
- verifier l'existence du repository `djallesjr04/intranet-newdeal`

## Le runner `runner_prod` n'est pas pris en compte

Symptome :

- le job `deploy_prod` reste en attente ou en `skipped`

Actions :

- verifier que le runner est `online`
- verifier le label `runner_prod`
- verifier que le depot autorise les runners self-hosted
- verifier que `RUNNER_PROD_READY` est a `true`
- verifier que `docker version` fonctionne sur la machine du runner

## Le port 80 est deja utilise sur le serveur

Symptome :

- echec de `docker run -p 80:80`

Actions :

- identifier le service occupant le port
- arreter le service concerne
- ou ajuster temporairement le port hote pour les tests

## Les emails ne partent pas

Symptome :

- echec du job `notify`

Actions :

- verifier `SMTP_HOST`, `SMTP_PORT`, `SMTP_USERNAME`, `SMTP_PASSWORD`
- verifier `MAIL_FROM` et `MAIL_TO`
- verifier que le fournisseur SMTP autorise l'envoi depuis GitHub Actions

## Trivy bloque le deploiement

Symptome :

- le job `security_gate` echoue

Actions :

- consulter le rapport Trivy publie en artefact
- mettre a jour l'image de base ou les dependances
- reconstruire et relancer la pipeline

## Gitleaks detecte un secret

Symptome :

- le job `scan_secrets` echoue

Actions :

- supprimer le secret du code et de l'historique recent
- deplacer la configuration sensible dans GitHub Secrets
- relancer le workflow
