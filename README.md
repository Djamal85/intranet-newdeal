# intranet-newdeal

Projet d'examen DevOps: mise en place d'un pipeline CI/CD pour un intranet gouvernemental inspiré du New Deal Technologique du Sénégal.

## Présentation

Ce dépôt propose un site statique institutionnel en français, servi par Nginx dans un conteneur Docker, avec:

- une intégration personnalisée du template Forty de HTML5 UP
- une pipeline CI ciblant la branche `dev`
- une pipeline CD ciblant la branche `prod`
- un scan de vulnérabilités avec Trivy
- un scan de secrets avec Gitleaks
- un blocage explicite en cas de vulnérabilité `CRITICAL`
- une notification email de synthèse en fin de workflow
- une documentation de soutenance et un rapport `.docx`

Le site représente:

`Intranet New Deal – Ministère de la Communication, des Télécommunications et du Numérique`

## Contexte et choix techniques

- Site statique: HTML, CSS, JS issus du thème Forty et personnalisés pour un usage intranet institutionnel.
- Serveur web: `nginx:alpine3.23-slim` pour l'image finale.
- Image de référence documentée: `nginx:alpine3.23` conformément au sujet.
- Sécurité CI/CD: Trivy pour l'image Docker, Gitleaks pour les secrets.
- Publication d'images: Docker Hub `djallesjr04/intranet-newdeal`.
- Déploiement production: runner GitHub Actions self-hosted labellisé `runner_prod`.

Le template Forty a été récupéré depuis la source officielle HTML5 UP. Aucun fallback n'a été nécessaire.

## Structure du dépôt

```text
intranet-newdeal/
├── .github/workflows/
├── docs/
├── nginx/
├── report/
├── screenshots/
├── scripts/
├── site/
├── .dockerignore
├── .gitignore
├── Dockerfile
└── README.md
```

## Branches Git

- `dev`: branche d'intégration continue
- `prod`: branche de déploiement continu

Le flux attendu est le suivant:

1. Développer et pousser sur `dev`
2. Laisser la pipeline CI construire, scanner et pousser l'image `dev`
3. Promouvoir le code validé vers `prod`
4. Déclencher la pipeline CD pour scanner, pousser l'image `prod` et déployer sur le runner self-hosted

## Exécution locale sans Docker

Le site étant statique, il peut être ouvert directement via:

- `site/index.html`

Pour une démonstration plus réaliste, il est recommandé d'utiliser Docker.

## Build et run Docker

```bash
docker build -t intranet-newdeal:local .
docker run --rm -p 80:80 --name intranet-newdeal intranet-newdeal:local
```

Ensuite ouvrir:

- `http://localhost/`

## CI sur `dev`

Workflow: `.github/workflows/ci-dev.yml`

Jobs chaînés avec `needs`:

1. `build`
2. `scan_vulnerabilities`
3. `scan_secrets`
4. `push_dockerhub`
5. `notify`

Comportement:

- construction de l'image Docker
- export de l'image sous forme d'artefact
- scan Trivy avec échec si une vulnérabilité `CRITICAL` est détectée
- scan Gitleaks du dépôt
- push vers Docker Hub sur les tags `dev`, `dev-<sha>` et `latest-dev`
- email de synthèse exécuté avec `if: always()`

## CD sur `prod`

Workflow: `.github/workflows/cd-prod.yml`

Jobs:

1. `security_gate`
2. `deploy_prod`
3. `notify`

Comportement:

- reconstruction de l'image à partir de la branche `prod`
- scan Trivy bloquant sur sévérité `CRITICAL`
- push des tags `prod` et `prod-<sha>` sur Docker Hub
- déploiement sur un runner self-hosted étiqueté `runner_prod`
- exposition du service sur le port `80`
- email de synthèse exécuté avec `if: always()`

## Secrets GitHub à créer

Les workflows attendent les secrets suivants:

| Secret | Usage |
| --- | --- |
| `DOCKERHUB_USERNAME` | Nom d'utilisateur Docker Hub |
| `DOCKERHUB_TOKEN` | Access token Docker Hub |
| `SMTP_HOST` | Hôte SMTP |
| `SMTP_PORT` | Port SMTP |
| `SMTP_USERNAME` | Compte SMTP |
| `SMTP_PASSWORD` | Mot de passe ou token SMTP |
| `MAIL_FROM` | Adresse expéditrice |
| `MAIL_TO` | Adresse destinataire |

Exemples de destinataire:

- adresse de test personnelle
- `moussawade@groupeisi.com`

## Configuration Docker Hub

Créer le dépôt:

- `djallesjr04/intranet-newdeal`

Puis créer un access token Docker Hub et le renseigner dans `DOCKERHUB_TOKEN`.

## Configuration du runner `runner_prod`

Le runner doit:

- être self-hosted
- disposer de Docker fonctionnel
- porter le label `runner_prod`
- pouvoir publier le port `80`

Voir `docs/runner-prod-setup.md` pour les commandes détaillées.

## Procédure de déploiement attendue

1. Vérifier que l'image `dev` a bien été poussée après la CI.
2. Fusionner ou pousser le code validé dans `prod`.
3. Vérifier que le workflow `cd-prod` pousse l'image `prod`.
4. Vérifier que le runner `runner_prod` exécute `scripts/deploy_prod.sh`.
5. Contrôler l'accès HTTP sur le serveur de démonstration.

## Captures à prévoir pour le rendu

Prévoir au minimum:

- capture du workflow `ci-dev` en succès
- capture du workflow `cd-prod` en succès
- capture du dépôt GitHub avec les branches `dev` et `prod`
- capture du dépôt Docker Hub avec les tags `dev` et `prod`
- capture du site rendu dans le navigateur

Le dossier `screenshots/` est préparé pour accueillir ces éléments.

## Limites et points manuels

Dans ce workspace local:

- la création réelle du dépôt GitHub n'a pas été effectuée automatiquement
- l'ajout du collaborateur par email reste une étape manuelle côté GitHub
- l'envoi réel d'email dépend des secrets SMTP
- le déploiement réel sur runner self-hosted dépend d'une machine cible configurée

Toutes les étapes restantes sont documentées dans le dossier `docs/`.
