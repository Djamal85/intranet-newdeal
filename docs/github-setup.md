# GitHub setup

## Objectif

Préparer le dépôt GitHub `intranet-newdeal`, pousser le projet et créer les branches `dev` et `prod`.

## Pré-requis

- Git installé
- GitHub CLI `gh` installé
- session GitHub ouverte avec `gh auth login`

## Initialisation locale recommandée

Depuis la racine du projet:

```bash
git init -b dev
git add .
git commit -m "feat: initial intranet newdeal project"
```

## Création du dépôt GitHub

Si l'authentification GitHub CLI est disponible:

```bash
gh repo create intranet-newdeal --public --source=. --remote=origin --push
```

Cette commande:

- crée le dépôt GitHub
- ajoute `origin`
- pousse la branche courante `dev`

## Création de la branche `prod`

```bash
git switch -c prod
git push -u origin prod
git switch dev
```

## Vérification des branches distantes

```bash
git branch -a
git remote -v
```

## Ajout du collaborateur

Le sujet fournit une adresse email: `moisawade@gmail.com`.

Dans la pratique GitHub, l'ajout automatisé via CLI ou API nécessite généralement le `username` GitHub du collaborateur. Avec uniquement l'email, la méthode la plus fiable est la suivante:

1. Ouvrir le dépôt GitHub dans le navigateur
2. Aller dans `Settings`
3. Ouvrir `Collaborators and teams`
4. Choisir `Add people`
5. Saisir `moisawade@gmail.com`
6. Envoyer l'invitation si GitHub reconnaît le compte associé

Si le `username` GitHub exact est connu, on peut alors utiliser l'API GitHub:

```bash
gh api \
  --method PUT \
  -H "Accept: application/vnd.github+json" \
  /repos/Djamal85/intranet-newdeal/collaborators/<github_username> \
  -f permission=push
```

## Si `gh` n'est pas disponible

Créer le dépôt dans l'interface GitHub puis exécuter:

```bash
git init -b dev
git add .
git commit -m "feat: initial intranet newdeal project"
git remote add origin https://github.com/Djamal85/intranet-newdeal.git
git push -u origin dev
git switch -c prod
git push -u origin prod
git switch dev
```
