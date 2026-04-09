# intranet-newdeal

Projet d'examen DevOps : mise en place d'un pipeline CI/CD pour un intranet gouvernemental inspire du New Deal Technologique du Senegal.

## Presentation

Ce depot contient un site statique institutionnel en francais, servi par Nginx dans un conteneur Docker, avec :

- une integration personnalisee du template Forty de HTML5 UP
- une pipeline CI sur la branche `dev`
- une pipeline CD sur la branche `prod`
- un scan de vulnerabilites avec Trivy
- un scan de secrets avec Gitleaks
- un blocage en cas de vulnerabilite `CRITICAL`
- une notification email en fin de workflow
- une documentation de soutenance et un rapport `.docx`

Le site represente :

`Intranet New Deal - Ministere de la Communication, des Telecommunications et du Numerique`

## Contexte et choix techniques

- Front-end : HTML, CSS et JS issus du theme Forty, personnalises pour un intranet institutionnel senegalais.
- Serveur web : `nginx:alpine3.23-slim` pour l'image finale.
- Image de reference documentee : `nginx:alpine3.23`.
- Securite CI/CD : Trivy pour l'image Docker, Gitleaks pour les secrets.
- Publication des images : Docker Hub `djallesjr04/intranet-newdeal`.
- Deploiement production : runner GitHub Actions self-hosted labellise `runner_prod`.

Le template Forty a ete recupere depuis la source officielle HTML5 UP. Aucun fallback n'a ete necessaire.

## Etat actuel au 2026-04-09

Les elements suivants sont deja en place :

- depot GitHub cree : `https://github.com/Djamal85/intranet-newdeal`
- branches `dev` et `prod` poussees
- collaborateur `moisawade` invite avec un acces en ecriture
- depot Docker Hub cree : `djallesjr04/intranet-newdeal`
- runner self-hosted `runner_prod` configure et visible `online` dans GitHub
- workflow `ci-dev` valide avec build, scans et push Docker Hub
- workflow `cd-prod` valide avec `security_gate` operationnel
- job `deploy_prod` valide sur le runner Windows
- deploiement de production execute avec succes via GitHub Actions

Les points encore manuels sont :

- l'envoi reel d'email, qui depend des secrets SMTP
- l'ajout des secrets SMTP pour activer la notification email reelle

## Structure du depot

```text
intranet-newdeal/
|-- .github/workflows/
|-- docs/
|-- nginx/
|-- report/
|-- screenshots/
|-- scripts/
|-- site/
|-- .dockerignore
|-- .gitignore
|-- Dockerfile
`-- README.md
```

## Branches Git

- `dev` : integration continue
- `prod` : deploiement continu

Flux attendu :

1. developper et pousser sur `dev`
2. laisser la CI construire, scanner et publier l'image `dev`
3. promouvoir le code valide vers `prod`
4. laisser la CD scanner, publier l'image `prod` et deployer sur le runner self-hosted

## Execution locale sans Docker

Le site etant statique, il peut etre ouvert directement via :

- `site/index.html`

Pour une demonstration plus realiste, il est recommande d'utiliser Docker.

## Build et run Docker

```bash
docker build -t intranet-newdeal:local .
docker run --rm -p 80:80 --name intranet-newdeal intranet-newdeal:local
```

Puis ouvrir :

- `http://localhost/`

## CI sur `dev`

Workflow : `.github/workflows/ci-dev.yml`

Jobs chaines avec `needs` :

1. `build`
2. `scan_vulnerabilities`
3. `scan_secrets`
4. `push_dockerhub`
5. `notify`

Comportement :

- construction de l'image Docker
- export de l'image sous forme d'artefact
- scan Trivy avec echec si une vulnerabilite `CRITICAL` est detectee
- scan Gitleaks du depot
- push vers Docker Hub sur les tags `dev`, `dev-<sha>` et `latest-dev`
- email de synthese execute avec `if: always()`
- si Docker Hub ou SMTP ne sont pas encore configures, les jobs dependants sont ignores proprement

## CD sur `prod`

Workflow : `.github/workflows/cd-prod.yml`

Jobs :

1. `preflight`
2. `security_gate`
3. `deploy_prod`
4. `notify`

Comportement :

- reconstruction de l'image a partir de la branche `prod`
- scan Trivy bloquant sur severite `CRITICAL`
- push des tags `prod` et `prod-<sha>` sur Docker Hub
- deploiement sur un runner self-hosted etiquette `runner_prod`
- support du script PowerShell sur Windows et du script Bash sur Linux
- exposition du service sur le port `80`
- email de synthese execute avec `if: always()`

Etat actuel :

- `security_gate` est operationnel
- `deploy_prod` est operationnel sur le runner Windows
- la variable `RUNNER_PROD_READY` est maintenant activee

## Secrets GitHub a creer

Les workflows attendent les secrets suivants :

| Secret | Usage |
| --- | --- |
| `DOCKERHUB_USERNAME` | Nom d'utilisateur Docker Hub |
| `DOCKERHUB_TOKEN` | Access token Docker Hub |
| `SMTP_HOST` | Hote SMTP |
| `SMTP_PORT` | Port SMTP |
| `SMTP_USERNAME` | Compte SMTP |
| `SMTP_PASSWORD` | Mot de passe ou token SMTP |
| `MAIL_FROM` | Adresse expediteur |
| `MAIL_TO` | Adresse destinataire |

Variable GitHub :

| Variable | Usage |
| --- | --- |
| `RUNNER_PROD_READY` | Variable de garde du deploiement production. Elle est deja positionnee a `true` dans le depot |

Exemple de destinataire :

- `moussawade@groupeisi.com`

## Configuration Docker Hub

Repository utilise :

- `djallesjr04/intranet-newdeal`

Le secret `DOCKERHUB_TOKEN` doit contenir un access token Docker Hub valide.

## Configuration du runner `runner_prod`

Le runner doit :

- etre self-hosted
- porter le label `runner_prod`
- disposer de Docker fonctionnel
- pouvoir publier le port `80`

Voir `docs/runner-prod-setup.md` pour les details et le statut actuel de la machine Windows utilisee.

## Procedure de deploiement attendue

1. verifier que l'image `dev` a bien ete poussee apres la CI
2. fusionner ou pousser le code valide dans `prod`
3. verifier que le workflow `cd-prod` pousse l'image `prod`
4. verifier que le runner `runner_prod` execute le script adapte a son OS :
   - `scripts/deploy_prod.ps1` sur Windows
   - `scripts/deploy_prod.sh` sur Linux
5. controler l'acces HTTP sur le serveur de demonstration

## Captures a prevoir pour le rendu

Prevoir au minimum :

- capture du workflow `ci-dev` en succes
- capture du workflow `cd-prod` en succes
- capture du depot GitHub avec les branches `dev` et `prod`
- capture du depot Docker Hub avec les tags `dev` et `prod`
- capture du site rendu dans le navigateur

Le dossier `screenshots/` est prepare pour accueillir ces elements.

## Limites et points manuels

Dans ce workspace local :

- le depot GitHub a deja ete cree
- l'invitation du collaborateur a deja ete lancee
- l'envoi reel d'email depend encore des secrets SMTP
- le runner `runner_prod` est en ligne et le deploiement production a deja ete execute avec succes
- la seule finalisation restante concerne la notification email SMTP

Voir aussi :

- `docs/current-status.md`
- `docs/runner-prod-setup.md`
- `docs/troubleshooting.md`
