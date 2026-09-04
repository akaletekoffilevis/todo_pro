# Changelog

Toutes les modifications notables de **Taskly (todo_pro)**.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.1.0/),
et ce projet adhère au [Semantic Versioning](https://semver.org/lang/fr/).

## [1.1.0] - 2026-09-04

### Ajouté
- **Backend réel Firebase** : authentification Google (création de compte + connexion) via `firebase_core`, `firebase_auth` et `google_sign_in`.
- **Synchronisation Cloud Firestore** : chaque utilisateur dispose de sa propre collection privée de tâches (`users/<uid>/tasks`) et n'accède qu'à ses données.
- **Mode hors-ligne** : cache local Hive par utilisateur avec relecture automatique si Firestore est indisponible.
- **Écran de connexion** premium avec bouton « Continuer avec Google ».
- **Section Compte** dans les Réglages : avatar, email, statut de synchronisation, déconnexion.
- **AuthGate** : bascule automatique connexion ↔ application selon l'état d'authentification (avec fallback local sur desktop Linux).
- **isolation par utilisateur testée** : unit tests du cache Hive `users/<uid>` (29 tests au total).

### Amélioré
- Architecture : `AuthService`, `AuthGate`, `LoginController`, `FirebaseTaskDatasource`, `FirebaseTaskRepository`, `CloudScope`.

### Configuration requise
- Remplacer `lib/firebase_options.dart` par la sortie de `flutterfire configure`, activer la connexion Google dans la console Firebase et fournir `google-services.json` (Android) / `GoogleService-Info.plist` (iOS).

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