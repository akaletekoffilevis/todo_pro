# Changelog

Toutes les modifications notables de **Taskly (todo_pro)**.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.1.0/),
et ce projet adhère au [Semantic Versioning](https://semver.org/lang/fr/).

## [1.0.0] - 2026-09-04

### Ajouté
- **Grand horloge live** centrée sur l'accueil (heures:minutes:secondes + date), mise à jour chaque seconde, hors-ligne.
- **Section Aide & support** dans les réglages : email support `l.akalete20@gmail.com`, description, bouton « Contacter le support » qui copie l'email dans le presse-papiers.
- **Centrage responsive** (`ResponsiveWrapper`) sur l'accueil, les statistiques et les réglages pour un rendu optimisé sur desktop/tablette.
- **Bottom navigation bar** sur l'écran Réglages (onglet n°4 manquant).
- **Bouton retour** (AppBar) sur l'écran Focus.
- **CI GitHub Actions** (`.github/workflows/ci.yml`) : `flutter analyze`, tests unitaires/widgets, tests d'intégration Linux.
- **README** complet (fonctionnalités, architecture, tests, démarrage).
- **CHANGELOG** versionné.

### Amélioré
- Interface premium : dégradé signature `#6C5CE7`, Google Fonts Inter, cartes arrondies.

## [0.3.0] - 2026-08-28

### Ajouté
- Écran **Statistiques** : progression globale, répartition par catégorie et par priorité.
- Mode **Focus** : chrono circulaire + sélection d'une tâche à accomplir.
- **Persistance Hive** complète : catégorie, priorité, échéance, rappel.
- **i18n** : génération des localisations FR/EN via `flutter gen-l10n`.

## [0.2.0] - 2026-08-20

### Ajouté
- Écran **Toutes les tâches** : recherche, filtres par statut et priorité, tri, suppression par swipe.
- Écran **éditeur de tâche** : titre, description, date/heure, catégorie, priorité, rappel.
- **TaskBloc** (Bloc) avec recherche/filtres/tri/stats et `TaskRepository`.

## [0.1.0] - 2026-08-12

### Ajouté
- Structure Flutter initiale `todo_pro`.
- Modèle **Task** enrichi : catégorie, priorité, échéance, rappel.
- Écran d'accueil « Today » avec les tâches du jour et stats rapides.
- Thème premium clair/sombre.
- Tests unitaires (bloc, modèle) et tests widgets de base.