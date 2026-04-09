# Runner `runner_prod`

## Objectif

Configurer un runner GitHub Actions self-hosted dédié au déploiement de la branche `prod`.

## Hypothèse cible

Machine Linux ou VM Ubuntu avec:

- Docker installé
- accès réseau sortant vers GitHub et Docker Hub
- droits suffisants pour exposer le port `80`

## Création du runner

Dans le dépôt GitHub:

1. Aller dans `Settings`
2. Ouvrir `Actions`
3. Ouvrir `Runners`
4. Cliquer sur `New self-hosted runner`
5. Choisir Linux x64

## Commandes types sur la machine

Créer un dossier dédié:

```bash
mkdir -p ~/actions-runner && cd ~/actions-runner
```

Télécharger l'archive fournie par GitHub puis exécuter:

```bash
tar xzf actions-runner-linux-x64-<version>.tar.gz
./config.sh --url https://github.com/Djamal85/intranet-newdeal --token <TOKEN> --name runner_prod --labels runner_prod
```

## Lancer le runner

Pour un test interactif:

```bash
./run.sh
```

Pour l'installation en service:

```bash
sudo ./svc.sh install
sudo ./svc.sh start
sudo ./svc.sh status
```

## Docker sur le runner

Le runner doit pouvoir exécuter:

```bash
docker ps
docker pull djallesjr04/intranet-newdeal:prod
```

Si nécessaire:

```bash
sudo usermod -aG docker $USER
newgrp docker
```

## Validation du label

Le workflow `cd-prod.yml` attend exactement:

```yaml
runs-on:
  - self-hosted
  - runner_prod
```

Le runner doit donc exposer le label `runner_prod`.

## Vérifications avant soutenance

- le runner est `Idle` dans GitHub
- Docker fonctionne sans sudo dans le contexte du runner
- le port `80` est libre ou correctement redirigé
- la machine peut télécharger l'image Docker Hub
