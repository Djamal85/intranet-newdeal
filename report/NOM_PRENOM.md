# NOM PRENOM
## Mise en place d'un pipeline CI/CD pour un intranet gouvernemental

### Introduction

Ce rapport présente la conception et la réalisation d'un projet DevOps complet autour d'un intranet gouvernemental inspiré du New Deal Technologique du Sénégal. L'objectif était de produire un livrable réaliste, démontrable et cohérent avec les pratiques d'intégration continue, de sécurité et de déploiement continu attendues dans un contexte institutionnel.

### Contexte

Le ministère a besoin d'un portail interne permettant de centraliser les procédures, les actualités, les services internes et les projets stratégiques. En parallèle, l'équipe technique doit disposer d'un processus industrialisé pour construire l'image applicative, vérifier sa sécurité, publier l'image sur Docker Hub et déployer la version validée sur un environnement de production.

### Objectifs

- personnaliser un intranet institutionnel à partir du template Forty
- containeriser le site via Docker et Nginx
- mettre en place une pipeline CI sur la branche dev
- mettre en place une pipeline CD sur la branche prod
- intégrer des contrôles de sécurité avec Trivy et Gitleaks
- bloquer le déploiement en cas de vulnérabilité critique
- documenter l'ensemble du dispositif pour la soutenance

### Présentation du site intranet

Le site final s'intitule « Intranet New Deal – Ministère de la Communication, des Télécommunications et du Numérique ». Il est entièrement rédigé en français, avec un ton institutionnel et sobre. Il comprend une page d'accueil, une bannière de présentation, une section actualités, une section services internes, une page dédiée aux documents et procédures, une page sur les projets stratégiques, une page support et un footer institutionnel.

### Architecture technique

L'application est un site statique servi par Nginx à l'intérieur d'un conteneur Docker. Le code source est hébergé sur GitHub avec deux branches principales: dev et prod. Les images Docker sont publiées sur Docker Hub. Le déploiement de production est assuré via un runner self-hosted nommé runner_prod.

### Stratégie Git et branches

La branche dev est utilisée pour l'intégration continue. Chaque push sur cette branche déclenche la construction de l'image, les scans de sécurité, le push sur Docker Hub et la notification email. La branche prod sert à la mise en production. Chaque push sur cette branche déclenche un security gate puis un déploiement sur le runner de production.

### Conteneurisation Docker

Le projet utilise l'image de référence nginx:alpine3.23 pour répondre à l'exigence du sujet, et l'image finale nginx:alpine3.23-slim pour obtenir un runtime plus léger. Nginx sert les pages statiques et applique des headers de sécurité simples. Le conteneur expose le port 80.

### Pipeline CI sur dev

Le workflow ci-dev.yml est composé de cinq jobs chaînés par needs:

- build
- scan_vulnerabilities
- scan_secrets
- push_dockerhub
- notify

Le job build construit l'image Docker et l'exporte en artefact. Trivy scanne ensuite l'image et Gitleaks scanne le dépôt. Si les contrôles passent, l'image est poussée sur Docker Hub avec des tags de développement. Enfin, un email de synthèse est envoyé.

[INSÉRER CAPTURE PIPELINE DEV]

### Pipeline CD sur prod

Le workflow cd-prod.yml met en œuvre un security gate avant déploiement. L'image est reconstruite depuis la branche prod, scannée par Trivy puis poussée sur Docker Hub avec des tags de production. Le job deploy_prod s'exécute sur le runner self-hosted runner_prod et relance le conteneur Nginx sur le port 80.

[INSÉRER CAPTURE PIPELINE PROD]

### Sécurité et scans

Trivy est utilisé pour les vulnérabilités d'image et Gitleaks pour les secrets. Le niveau critique entraîne l'échec du scan et le blocage du déploiement. Cette approche répond directement à l'exigence du sujet sur l'arrêt en cas de faille CRITICAL.

### Passage à nginx:alpine3.23-slim

Le Dockerfile documente l'image de référence nginx:alpine3.23, puis bascule vers nginx:alpine3.23-slim pour le runtime final. Ce choix permet de rester conforme au sujet tout en conservant une image légère et adaptée à un site statique.

### Notification email

Les workflows utilisent des secrets SMTP pour envoyer un récapitulatif d'exécution. Cette notification permet de savoir rapidement si la pipeline a réussi, échoué ou si le déploiement a été bloqué par un scan de sécurité.

### Difficultés rencontrées

Les principales difficultés proviennent de la dépendance à des services externes: authentification GitHub, configuration Docker Hub, disponibilité du runner self-hosted et configuration SMTP. Lorsque ces éléments ne sont pas disponibles localement, il faut préparer le projet de façon rigoureuse et documenter précisément les étapes manuelles restantes.

### Conclusion

Le projet réalisé met en place une chaîne CI/CD complète, crédible et soutenable pour un intranet gouvernemental. Il combine personnalisation front-end, conteneurisation, sécurité, automatisation et documentation. L'ensemble est prêt à être poussé sur GitHub, démontré à l'oral et complété avec les captures des pipelines une fois les services externes configurés.
