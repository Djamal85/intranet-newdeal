# Guide d'exécution des pipelines

## Pipeline CI sur `dev`

### Déclenchement

```bash
git switch dev
git add .
git commit -m "feat: update intranet content"
git push origin dev
```

### Ce qu'il faut vérifier

1. Le job `build` construit l'image Docker.
2. Le job `scan_vulnerabilities` exécute Trivy.
3. Le job `scan_secrets` exécute Gitleaks.
4. Le job `push_dockerhub` pousse les tags `dev`.
5. Le job `notify` envoie l'email de synthèse.

### Captures recommandées

- liste des jobs du workflow `ci-dev`
- détail du job `push_dockerhub`
- dépôt Docker Hub avec les tags `dev`

## Pipeline CD sur `prod`

### Déclenchement

```bash
git switch prod
git merge dev
git push origin prod
```

Ou via déclenchement manuel depuis l'onglet `Actions` grâce à `workflow_dispatch`.

### Ce qu'il faut vérifier

1. Le job `security_gate` reconstruit et scanne l'image.
2. Le scan Trivy bloque en cas de vulnérabilité `CRITICAL`.
3. L'image `prod` est poussée sur Docker Hub.
4. Le job `deploy_prod` s'exécute sur le runner `runner_prod`.
5. Le conteneur `intranet-newdeal` est relancé sur le port `80`.
6. Le job `notify` envoie le récapitulatif final.

Note:

- si `RUNNER_PROD_READY` est encore a `false`, le job `deploy_prod` sera ignore proprement
- sur un runner Windows, le deploiement s'appuie sur `scripts/deploy_prod.ps1`
- sur un runner Linux, le deploiement s'appuie sur `scripts/deploy_prod.sh`

### Captures recommandées

- liste des jobs du workflow `cd-prod`
- détail du job `security_gate`
- détail du job `deploy_prod`
- navigateur montrant le site déployé

## Démonstration locale

Avant la soutenance, tester localement:

```bash
docker build -t intranet-newdeal:local .
docker run --rm -p 80:80 intranet-newdeal:local
```

Puis ouvrir `http://localhost/`.
