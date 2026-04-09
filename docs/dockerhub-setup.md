# Docker Hub setup

## Dépôt cible

- namespace: `djallesjr04`
- repository: `intranet-newdeal`

Image complète:

- `djallesjr04/intranet-newdeal`

## Étapes de préparation

1. Se connecter à Docker Hub
2. Créer le repository `intranet-newdeal`
3. Générer un access token
4. Reporter ce token dans GitHub Actions via `DOCKERHUB_TOKEN`

## Secrets GitHub à renseigner

- `DOCKERHUB_USERNAME=djallesjr04`
- `DOCKERHUB_TOKEN=<access_token>`

## Test local du login Docker

```bash
docker login -u djallesjr04
```

## Test local du push

```bash
docker build -t djallesjr04/intranet-newdeal:local-test .
docker push djallesjr04/intranet-newdeal:local-test
```

## Tags utilisés par les workflows

### Pipeline CI sur `dev`

- `dev`
- `dev-<sha>`
- `latest-dev`

### Pipeline CD sur `prod`

- `prod`
- `prod-<sha>`

## Recommandation

Supprimer les anciens tags de test inutiles après la soutenance pour garder un historique lisible sur Docker Hub.
