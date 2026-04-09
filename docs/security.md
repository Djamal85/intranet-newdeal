# Sécurité

## Outils utilisés

- `Trivy` pour le scan des vulnérabilités sur l'image Docker
- `Gitleaks` pour la détection de secrets dans le dépôt Git

## Ce qui est scanné

### CI sur `dev`

- l'image Docker construite à partir du projet
- l'historique et le contenu du dépôt source

### CD sur `prod`

- l'image reconstruite depuis la branche `prod` avant toute publication ou déploiement

## Logique de blocage

### Intégration continue

- Trivy échoue si une vulnérabilité `CRITICAL` est détectée
- Gitleaks échoue si un secret probable est détecté
- si un scan échoue, le job `push_dockerhub` ne démarre pas

### Déploiement continu

- le job `security_gate` échoue si Trivy détecte une vulnérabilité `CRITICAL`
- le job `deploy_prod` dépend de `security_gate`
- le déploiement est donc bloqué avant production

## Pourquoi ce choix

- Trivy est un standard du marché, simple à intégrer dans GitHub Actions
- Gitleaks est léger, rapide et adapté aux dépôts applicatifs
- le seuil `CRITICAL` correspond à l'exigence du sujet et permet une démonstration claire de la politique de blocage

## Limites

- les scans ne remplacent pas un audit de sécurité complet
- un faux positif Gitleaks peut nécessiter une revue manuelle
- certaines vulnérabilités applicatives côté contenu HTML ne sont pas couvertes par ces outils
- la sécurité SMTP dépend du fournisseur de messagerie choisi
