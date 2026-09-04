# Taskly (todo_pro)

[![Flutter](https://img.shields.io/badge/Flutter-3.44-blue?logo=flutter)](https://flutter.dev)
[![CI](https://github.com/akaletekoffilevis/todo_pro/actions/workflows/ci.yml/badge.svg)](https://github.com/akaletekoffilevis/todo_pro/actions/workflows/ci.yml)

**Taskly** est une application de gestion de tâches **production-ready**, au design premium inspiré d'iPhone, développée en **Flutter** pour le programme **10000Codeurs**.

Elle propose une architecture **Bloc** propre, un **backend réel Firebase** (authentification Google + Cloud Firestore), une persistance locale **Hive** (cache hors-ligne), une **internationalisation FR/EN**, l'accessibilité (semantic labels), la performance (flutter_hooks, const optimisations) et une **suite de tests complète**.

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
- 🔐 **Compte Google (Firebase Auth)** : création de compte et connexion sécurisée
- ☁️ **Cloud Firestore** : chaque utilisateur accède à **ses propres tâches**, synchronisées sur tous ses appareils
- 📴 **Hors-ligne** : cache local par utilisateur, les tâches restent accessibles sans réseau

## 🖼️ Écrans

| Écran | Description |
|-------|-------------|
| **Today** | Horloge live, stats rapides, tâches du jour, bouton Focus |
| **Tasks** | Toutes les tâches : recherche, filtres statut/priorité, tri, swipe pour supprimer |
| **Stats** | Progression globale + répartition par catégorie et priorité |
| **Settings** | Thème, langue, notifications, **Compte (Firebase)**, **Aide & support** |
| **Login** | Connexion / création de compte avec Google |
| **Focus** | Chrono circulaire pour se concentrer sur une tâche |
| **Editor** | Ajout/édition avancé : titre, description, date, catégorie, priorité, rappel |

## 🏗️ Architecture

```
lib/
├── core/
│   ├── router/          # go_router (navigation)
│   ├── theme/           # ThemeData premium clair/sombre
│   ├── cloud_scope.dart # Expose l'utilisateur Firebase à l'arbre de widgets
│   └── widgets/         # AppNavBar, LiveClock, ResponsiveWrapper, ...
├── features/
│   ├── auth/
│   │   ├── data/        # AuthService (Google sign-in via Firebase)
│   │   ├── domain/      # AppUser
│   │   └── presentation/ # LoginScreen, AuthGate, LoginController
│   ├── home/
│   │   ├── bloc/        # TaskBloc, TaskEvent, TaskState
│   │   ├── data/        # Datasource Hive + Repository
│   │   ├── domain/      # Task, TaskCategory, TaskPriority
│   │   └── presentation/
│   │       ├── screens/ # Home, Tasks, Stats, Focus, Editor
│   │       └── widgets/ # TaskCard, ...
│   ├── settings/
│   │   ├── bloc/        # SettingsCubit (thème, langue, notifications)
│   │   └── presentation/screens/ # SettingsScreen
│   └── sync/            # FirebaseTaskDatasource + FirebaseTaskRepository
├── firebase_options.dart # Généré par flutterfire configure
└── l10n/                # app_en.arb + app_fr.arb (i18n)
```

- **State management** : `Bloc` (task) + `Cubit` (settings)
- **Backend** : `Firebase` (`firebase_auth` + `cloud_firestore` + `google_sign_in`)
- **Persistance** : `Firestore` (cloud, source de vérité) + `Hive` (cache hors-ligne, un compartiment par utilisateur)
- **Navigation** : `go_router`
- **Localisation** : `flutter gen-l10n`, FR + EN

## ✅ Qualité & Tests

| Type | Nombre | Lancer |
|------|--------|--------|
| Tests unitaires (bloc, model, repository, cache utilisateur) | 24 | `flutter test test/features` |
| Tests widgets | 5 | `flutter test test/widget_test.dart` |
| Tests d'intégration | 3 | `flutter test integration_test -d linux` |

```bash
flutter analyze          # 0 issue attendu
flutter test             # tous les tests
flutter test integration_test -d linux
```

La **CI GitHub Actions** (`.github/workflows/ci.yml`) lance `flutter analyze`, les tests unitaires/widgets et les tests d'intégration sur chaque push.

## 🔥 Configuration Firebase (backend cloud)

Le mode local fonctionne sans Firebase (idéal pour le développement Linux). Pour activer le mode cloud avec authentification Google :

### 1. Créer un projet Firebase
1. Va sur [Firebase Console](https://console.firebase.google.com)
2. Crée un projet (ex: `todo-pro`)
3. Active **Google** comme méthode de connexion dans **Authentication > Méthodes de connexion**

### 2. Configurer les plateformes

```bash
# Installe FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase pour chaque plateforme (android, ios, web, ...)
cd todo_pro
flutterfire configure
```

Ceci remplace automatiquement `lib/firebase_options.dart` avec tes vraies clés.

### 3. Fichiers de configuration supplémentaires

| Plateforme | Fichier requis (généré ou à télécharger) |
|------------|-------------------------------------------|
| **Android** | `android/app/google-services.json` (Firebase Console > Paramètres > Application Android) |
| **iOS** | `ios/Runner/GoogleService-Info.plist` (Firebase Console > Paramètres > Application iOS) |
| **Web** | Aucun fichier nécessaire (gestionné par `flutterfire configure`) |

### 4. Android — configurer le plugin

Vérifie que `android/build.gradle.kts` (ou `android/build.gradle`) contient :

```kotlin
classpath("com.google.gms:google-services:4.4.2")
```

et `android/app/build.gradle.kts` :

```kotlin
id("com.google.gms.google-services")
```

### 5. Activer Cloud Firestore

Dans la console Firebase > **Firestore Database** > Crée une base de données > lance en mode test.

> **Note** : le mode local (Linux desktop) continue de fonctionner sans aucune configuration Firebase — l'app détecte la plateforme et bascule automatiquement.

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