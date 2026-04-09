$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
$outputPath = Join-Path $projectRoot "report\\NOM_PRENOM.docx"

$sections = @(
    @{ Kind = "title"; Text = "NOM PRENOM" },
    @{ Kind = "subtitle"; Text = "Mise en place d'un pipeline CI/CD pour un intranet gouvernemental" },
    @{ Kind = "normal"; Text = "Projet d'examen DevOps - Licence 3 IAGE" },
    @{ Kind = "normal"; Text = "Theme: Mise en place d'un pipeline CI/CD pour un Intranet gouvernemental" },
    @{ Kind = "normal"; Text = "Annee academique: 2025-2026" },
    @{ Kind = "normal"; Text = "Etudiant: NOM PRENOM" },
    @{ Kind = "pagebreak"; Text = "" },
    @{ Kind = "heading"; Text = "Introduction" },
    @{ Kind = "normal"; Text = "Ce rapport presente la conception et la realisation d'un projet DevOps complet autour d'un intranet gouvernemental inspire du New Deal Technologique du Senegal. L'objectif etait de produire un livrable realiste, demonstrable et coherent avec les pratiques d'integration continue, de securite et de deploiement continu attendues dans un contexte institutionnel." },
    @{ Kind = "heading"; Text = "Contexte" },
    @{ Kind = "normal"; Text = "Le ministere a besoin d'un portail interne permettant de centraliser les procedures, les actualites, les services internes et les projets strategiques. En parallele, l'equipe technique doit disposer d'un processus industrialise pour construire l'image applicative, verifier sa securite, publier l'image sur Docker Hub et deployer la version validee sur un environnement de production." },
    @{ Kind = "heading"; Text = "Objectifs" },
    @{ Kind = "normal"; Text = "Les objectifs du projet etaient les suivants:" },
    @{ Kind = "bullet"; Text = "Personnaliser un intranet institutionnel a partir du template Forty" },
    @{ Kind = "bullet"; Text = "Containeriser le site via Docker et Nginx" },
    @{ Kind = "bullet"; Text = "Mettre en place une pipeline CI sur la branche dev" },
    @{ Kind = "bullet"; Text = "Mettre en place une pipeline CD sur la branche prod" },
    @{ Kind = "bullet"; Text = "Integrer des controles de securite avec Trivy et Gitleaks" },
    @{ Kind = "bullet"; Text = "Bloquer le deploiement en cas de vulnerabilite critique" },
    @{ Kind = "bullet"; Text = "Documenter l'ensemble du dispositif pour la soutenance" },
    @{ Kind = "heading"; Text = "Presentation du site intranet" },
    @{ Kind = "normal"; Text = "Le site final s'intitule Intranet New Deal - Ministere de la Communication, des Telecommunications et du Numerique. Il est entierement redige en francais, avec un ton institutionnel et sobre. Il comprend une page d'accueil, une banniere de presentation, une section actualites, une section services internes, une page dediee aux documents et procedures, une page sur les projets strategiques, une page support et un footer institutionnel." },
    @{ Kind = "heading"; Text = "Architecture technique" },
    @{ Kind = "normal"; Text = "L'application est un site statique servi par Nginx a l'interieur d'un conteneur Docker. Le code source est heberge sur GitHub avec deux branches principales: dev et prod. Les images Docker sont publiees sur Docker Hub. Le deploiement de production est assure via un runner self-hosted nomme runner_prod." },
    @{ Kind = "heading"; Text = "Strategie Git et branches" },
    @{ Kind = "normal"; Text = "La branche dev est utilisee pour l'integration continue. Chaque push sur cette branche declenche la construction de l'image, les scans de securite, le push sur Docker Hub et la notification email. La branche prod sert a la mise en production. Chaque push sur cette branche declenche un security gate puis un deploiement sur le runner de production." },
    @{ Kind = "heading"; Text = "Conteneurisation Docker" },
    @{ Kind = "normal"; Text = "Le projet utilise l'image de reference nginx:alpine3.23 pour repondre a l'exigence du sujet, et l'image finale nginx:alpine3.23-slim pour obtenir un runtime plus leger. Nginx sert les pages statiques et applique des headers de securite simples. Le conteneur expose le port 80." },
    @{ Kind = "heading"; Text = "Pipeline CI sur dev" },
    @{ Kind = "normal"; Text = "Le workflow ci-dev.yml est compose de cinq jobs chaines par needs: build, scan_vulnerabilities, scan_secrets, push_dockerhub et notify. Le job build construit l'image Docker et l'exporte en artefact. Trivy scanne ensuite l'image et Gitleaks scanne le depot. Si les controles passent, l'image est poussee sur Docker Hub avec des tags de developpement. Enfin, un email de synthese est envoye." },
    @{ Kind = "normal"; Text = "[INSERER CAPTURE PIPELINE DEV]" },
    @{ Kind = "heading"; Text = "Pipeline CD sur prod" },
    @{ Kind = "normal"; Text = "Le workflow cd-prod.yml met en oeuvre un security gate avant deploiement. L'image est reconstruite depuis la branche prod, scannee par Trivy puis poussee sur Docker Hub avec des tags de production. Le job deploy_prod s'execute sur le runner self-hosted runner_prod et relance le conteneur Nginx sur le port 80." },
    @{ Kind = "normal"; Text = "[INSERER CAPTURE PIPELINE PROD]" },
    @{ Kind = "heading"; Text = "Securite et scans" },
    @{ Kind = "normal"; Text = "Trivy est utilise pour les vulnerabilites d'image et Gitleaks pour les secrets. Le niveau critique entraine l'echec du scan et le blocage du deploiement. Cette approche repond directement a l'exigence du sujet sur l'arret en cas de faille CRITICAL." },
    @{ Kind = "heading"; Text = "Passage a nginx:alpine3.23-slim" },
    @{ Kind = "normal"; Text = "Le Dockerfile documente l'image de reference nginx:alpine3.23, puis bascule vers nginx:alpine3.23-slim pour le runtime final. Ce choix permet de rester conforme au sujet tout en conservant une image legere et adaptee a un site statique." },
    @{ Kind = "heading"; Text = "Notification email" },
    @{ Kind = "normal"; Text = "Les workflows utilisent des secrets SMTP pour envoyer un recapitulatif d'execution. Cette notification permet de savoir rapidement si la pipeline a reussi, echoue ou si le deploiement a ete bloque par un scan de securite." },
    @{ Kind = "heading"; Text = "Difficultes rencontrees" },
    @{ Kind = "normal"; Text = "Les principales difficultes proviennent de la dependance a des services externes: authentification GitHub, configuration Docker Hub, disponibilite du runner self-hosted et configuration SMTP. Lorsque ces elements ne sont pas disponibles localement, il faut preparer le projet de facon rigoureuse et documenter precisement les etapes manuelles restantes." },
    @{ Kind = "heading"; Text = "Conclusion" },
    @{ Kind = "normal"; Text = "Le projet realise met en place une chaine CI/CD complete, credible et soutenable pour un intranet gouvernemental. Il combine personnalisation front-end, conteneurisation, securite, automatisation et documentation. L'ensemble est pret a etre pousse sur GitHub, demontre a l'oral et complete avec les captures des pipelines une fois les services externes configures." }
)

function Set-ParagraphFormatting {
    param(
        $selection,
        [string]$kind
    )

    $selection.ParagraphFormat.Alignment = 0
    $selection.Font.Name = "Calibri"
    $selection.Font.Bold = 0
    $selection.Font.Size = 11

    switch ($kind) {
        "title" {
            $selection.ParagraphFormat.Alignment = 1
            $selection.Font.Bold = 1
            $selection.Font.Size = 20
        }
        "subtitle" {
            $selection.ParagraphFormat.Alignment = 1
            $selection.Font.Bold = 1
            $selection.Font.Size = 14
        }
        "heading" {
            $selection.Font.Bold = 1
            $selection.Font.Size = 14
        }
        "bullet" {
            $selection.Font.Size = 11
        }
        default {
            $selection.Font.Size = 11
        }
    }
}

$word = New-Object -ComObject Word.Application
$word.Visible = $false
$document = $word.Documents.Add()
$selection = $word.Selection

foreach ($section in $sections) {
    if ($section.Kind -eq "pagebreak") {
        $selection.InsertBreak(7) | Out-Null
        continue
    }

    Set-ParagraphFormatting -selection $selection -kind $section.Kind

    if ($section.Kind -eq "bullet") {
        $selection.TypeText("- " + $section.Text)
    } else {
        $selection.TypeText($section.Text)
    }

    $selection.TypeParagraph()
}

$document.SaveAs([string]$outputPath, [int]16)
$document.Close()
$word.Quit()

Write-Output "Report generated: $outputPath"
