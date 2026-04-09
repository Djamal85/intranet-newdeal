# Troubleshooting

## Docker ne démarre pas localement

Symptôme:

- `docker build` ou `docker run` échoue

Actions:

- vérifier que Docker Desktop est lancé
- exécuter `docker version`
- redémarrer Docker Desktop si nécessaire
- exécuter `wsl --status`
- si le noyau WSL2 est absent, lancer `wsl --update` dans un terminal administrateur
- relancer Docker Desktop après mise à jour de WSL

## Le push Docker Hub échoue

Symptôme:

- échec du job `push_dockerhub`

Actions:

- vérifier `DOCKERHUB_USERNAME`
- vérifier `DOCKERHUB_TOKEN`
- vérifier l'existence du repository `djallesjr04/intranet-newdeal`

## Le runner `runner_prod` n'est pas pris en compte

Symptôme:

- le job `deploy_prod` reste en attente

Actions:

- vérifier que le runner est `online`
- vérifier le label `runner_prod`
- vérifier que le dépôt autorise les runners self-hosted
- vérifier que `RUNNER_PROD_READY` est à `true`
- vérifier que `docker version` fonctionne sur la machine du runner

## Le port 80 est déjà utilisé sur le serveur

Symptôme:

- échec de `docker run -p 80:80`

Actions:

- identifier le service occupant le port
- arrêter le service concerné
- ou ajuster temporairement le port hôte pour les tests

## Les emails ne partent pas

Symptôme:

- échec du job `notify`

Actions:

- vérifier `SMTP_HOST`, `SMTP_PORT`, `SMTP_USERNAME`, `SMTP_PASSWORD`
- vérifier `MAIL_FROM` et `MAIL_TO`
- vérifier que le fournisseur SMTP autorise l'envoi depuis GitHub Actions

## Trivy bloque le déploiement

Symptôme:

- le job `security_gate` échoue

Actions:

- consulter le rapport Trivy publié en artefact
- mettre à jour l'image de base ou les dépendances
- reconstruire et relancer la pipeline

## Gitleaks détecte un secret

Symptôme:

- le job `scan_secrets` échoue

Actions:

- supprimer le secret du code et de l'historique récent
- déplacer la configuration sensible dans GitHub Secrets
- relancer le workflow
