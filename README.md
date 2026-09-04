# Taskly (todo_pro)

[![Flutter](https://img.shields.io/badge/Flutter-3.44-blue?logo=flutter)](https://flutter.dev)
[![CI](https://github.com/akaletekoffilevis/todo_pro/actions/workflows/ci.yml/badge.svg)](https://github.com/akaletekoffilevis/todo_pro/actions/workflows/ci.yml)

**Taskly** est une application de gestion de tâches **production-ready**, au design premium inspiré d'iPhone, développée en **Flutter** pour le programme **10000Codeurs**.

Elle propose une architecture **Bloc** propre, une persistance locale **Hive**, une **internationalisation FR/EN**, l'accessibilité (semantic labels), la performance (flutter_hooks, const optimisations) et une **suite de tests complète**.

---

## ✨ Fonctionnalités

- 🕐 **Grande horloge live** sur l'accueil (heure:minute:seconde + date, hors-ligne)
- ➕ Ajout / modification / suppression de tâches
- 🗂️ **Catégories** (Personnel, Travail, Santé, Courses, Études, Autre)
- 🚦 **Priorités** (Basse, Moyenne, Haute, Urgente)
- 📅 **Date & heure d'échéance** + rappels
- 🔍 **Recherche, filtres** (statut, priorité) **et tri**
- 📊 **Statistiques** par catégorie et priorité + progression globale
- ⏱️ **Mode Focus** : chrono circulaire pour travailler sur une tâche
- 🎨 **Thème premium clair/sombre** (dégradé signature `#6C5CE7`)
- 🌍 **Bilingue français / anglais**
- 💡 **Aide & support** dans les réglages (email support, copie rapide)

## 🖼️ Écrans

| Écran | Description |
|-------|-------------|
| **Today** | Horloge live, stats rapides, tâches du jour, bouton Focus |
| **Tasks** | Toutes les tâches : recherche, filtres statut/priorité, tri, swipe pour supprimer |
| **Stats** | Progression globale + répartition par catégorie et priorité |
| **Settings** | Thème, langue, notifications, **Aide & support** |
| **Focus** | Chrono circulaire pour se concentrer sur une tâche |
| **Editor** | Ajout/édition avancé : titre, description, date, catégorie, priorité, rappel |

## 🏗️ Architecture

```
lib/
├── core/
│   ├── router/          # go_router (navigation)
│   ├── theme/           # ThemeData premium clair/sombre
│   └── widgets/         # AppNavBar, LiveClock, ResponsiveWrapper, ...
├── features/
│   ├── home/
│   │   ├── bloc/        # TaskBloc, TaskEvent, TaskState
│   │   ├── data/        # Datasource Hive + Repository
│   │   ├── domain/      # Task, TaskCategory, TaskPriority
│   │   └── presentation/
│   │       ├── screens/ # Home, Tasks, Stats, Focus, Editor
│   │       └── widgets/ # TaskCard, ...
│   └── settings/
│       ├── bloc/        # SettingsCubit (thème, langue, notifications)
│       └── presentation/screens/ # SettingsScreen
└── l10n/                # app_en.arb + app_fr.arb (i18n)
```

- **State management** : `Bloc` (task) + `Cubit` (settings)
- **Persistance** : `Hive` (stockage local)
- **Navigation** : `go_router`
- **Localisation** : `flutter gen-l10n`, FR + EN

## ✅ Qualité & Tests

| Type | Nombre | Lancer |
|------|--------|--------|
| Tests unitaires (bloc, model, repository) | 22 | `flutter test test/features` |
| Tests widgets | 5 | `flutter test test/widget_test.dart` |
| Tests d'intégration | 3 | `flutter test integration_test -d linux` |

```bash
flutter analyze          # 0 issue attendu
flutter test             # tous les tests
flutter test integration_test -d linux
```

La **CI GitHub Actions** (`.github/workflows/ci.yml`) lance `flutter analyze`, les tests unitaires/widgets et les tests d'intégration sur chaque push.

## 🚀 Démarrage

```bash
flutter pub get
flutter gen-l10n
flutter run          # choisis ton device (android/ios/linux/...)
```

### Construire l'APK (Android)

```bash
flutter build apk --release
# APK : build/app/outputs/flutter-apk/app-release.apk
```

## 🧑‍💻 Auteur

Projet réalisé par **L. Akalete** dans le cadre du programme **10000Codeurs** — Certification Flutter.

Support : l.akalete20@gmail.com