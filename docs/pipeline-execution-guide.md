# Guide d'execution des pipelines

## Pipeline CI sur `dev`

### Declenchement

```bash
git switch dev
git add .
git commit -m "feat: update intranet content"
git push origin dev
```

### Ce qu'il faut verifier

1. Le job `build` construit l'image Docker.
2. Le job `scan_vulnerabilities` execute Trivy.
3. Le job `scan_secrets` execute Gitleaks.
4. Le job `push_dockerhub` pousse les tags `dev`.
5. Le job `notify` envoie l'email de synthese si SMTP est configure.

### Etat actuel

- la pipeline `ci-dev` est deja validee
- le push Docker Hub est deja operationnel
- la notification email reste conditionnee aux secrets SMTP

### Captures recommandees

- liste des jobs du workflow `ci-dev`
- detail du job `push_dockerhub`
- depot Docker Hub avec les tags `dev`

## Pipeline CD sur `prod`

### Declenchement

```bash
git switch prod
git merge dev
git push origin prod
```

Ou via declenchement manuel depuis l'onglet `Actions` grace a `workflow_dispatch`.

### Ce qu'il faut verifier

1. Le job `preflight` valide les prerequis.
2. Le job `security_gate` reconstruit et scanne l'image.
3. Le scan Trivy bloque en cas de vulnerabilite `CRITICAL`.
4. L'image `prod` est poussee sur Docker Hub.
5. Le job `deploy_prod` s'execute sur le runner `runner_prod`.
6. Le conteneur `intranet-newdeal` est relance sur le port `80`.
7. Le job `notify` envoie le recapitulatif final si SMTP est configure.

### Etat actuel

- `security_gate` est deja operationnel
- `deploy_prod` a deja ete execute avec succes sur le runner Windows
- la variable `RUNNER_PROD_READY` est desormais activee
- le seul point encore conditionnel est la notification email SMTP

### Notes d'exploitation

- sur un runner Windows, le deploiement s'appuie sur `scripts/deploy_prod.ps1`
- sur un runner Linux, le deploiement s'appuie sur `scripts/deploy_prod.sh`
- si `RUNNER_PROD_READY` est remis a `false`, le job `deploy_prod` sera ignore proprement

### Captures recommandees

- liste des jobs du workflow `cd-prod`
- detail du job `security_gate`
- detail du job `deploy_prod`
- navigateur montrant le site deployee

## Demonstration locale

Avant la soutenance, tester localement :

```bash
docker build -t intranet-newdeal:local .
docker run --rm -p 80:80 intranet-newdeal:local
```

Puis ouvrir `http://localhost/`.
