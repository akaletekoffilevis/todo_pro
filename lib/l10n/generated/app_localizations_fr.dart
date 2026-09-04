// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Taskly';

  @override
  String get appTitleDescription => 'Application title';

  @override
  String get appTagline => 'Organise ta journée, accomplis plus';

  @override
  String get appTaglineDescription => 'Home tagline';

  @override
  String get navHome => 'Aujourd\'hui';

  @override
  String get navTasks => 'Tâches';

  @override
  String get navStats => 'Stats';

  @override
  String get navSettings => 'Réglages';

  @override
  String get homeGreeting => 'Bonne journée';

  @override
  String get addTask => 'Nouvelle tâche';

  @override
  String get editTask => 'Modifier la tâche';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get complete => 'Terminer';

  @override
  String get markDone => 'Marquer comme fait';

  @override
  String get unmarkDone => 'Marquer comme à faire';

  @override
  String get pending => 'À faire';

  @override
  String get completed => 'Terminée';

  @override
  String get overdue => 'En retard';

  @override
  String get tasksToDo => 'Choses à faire';

  @override
  String get todayTitle => 'Aujourd\'hui';

  @override
  String get allTasksTitle => 'Toutes les tâches';

  @override
  String get noTasks => 'Aucune tâche';

  @override
  String get noTasksHint => 'Touche + pour créer ta première tâche';

  @override
  String get noResults => 'Aucun résultat';

  @override
  String get noResultsHint => 'Modifie ta recherche ou tes filtres';

  @override
  String get searchPlaceholder => 'Rechercher des tâches…';

  @override
  String get filters => 'Filtres';

  @override
  String get sortBy => 'Trier par';

  @override
  String get sortDate => 'Date';

  @override
  String get sortPriority => 'Priorité';

  @override
  String get sortTitle => 'Titre';

  @override
  String get sortCreated => 'Création';

  @override
  String get ascending => 'Croissant';

  @override
  String get descending => 'Décroissant';

  @override
  String get statusAll => 'Toutes';

  @override
  String get statusPending => 'À faire';

  @override
  String get statusCompleted => 'Terminées';

  @override
  String get statusOverdue => 'En retard';

  @override
  String get statusToday => 'Aujourd\'hui';

  @override
  String get priorityAll => 'Toutes priorités';

  @override
  String get clearFilters => 'Effacer';

  @override
  String get taskTitle => 'Titre de la tâche';

  @override
  String get taskDescription => 'Description (optionnelle)';

  @override
  String get taskDate => 'Date et heure';

  @override
  String get taskCategory => 'Catégorie';

  @override
  String get taskPriority => 'Priorité';

  @override
  String get setReminder => 'Rappel';

  @override
  String get priorityLow => 'Basse';

  @override
  String get priorityMedium => 'Moyenne';

  @override
  String get priorityHigh => 'Haute';

  @override
  String get priorityUrgent => 'Urgente';

  @override
  String get categoryPersonal => 'Personnel';

  @override
  String get categoryWork => 'Travail';

  @override
  String get categoryHealth => 'Santé';

  @override
  String get categoryShopping => 'Courses';

  @override
  String get categoryStudies => 'Études';

  @override
  String get categoryOther => 'Autre';

  @override
  String get statsTitle => 'Statistiques';

  @override
  String get statsTotal => 'Total';

  @override
  String get statsDone => 'Faites';

  @override
  String get statsActive => 'Actives';

  @override
  String get statsOverdue => 'En retard';

  @override
  String get progressLabel => 'Progression';

  @override
  String get statsByCategory => 'Par catégorie';

  @override
  String get statsByPriority => 'Par priorité';

  @override
  String get settingsTitle => 'Réglages';

  @override
  String get settingsAppearance => 'Apparence';

  @override
  String get language => 'Langue';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get notifications => 'Notifications';

  @override
  String get remindersEnabled => 'Activer les rappels';

  @override
  String get settingsSupport => 'Aide & support';

  @override
  String get supportTitle => 'Besoin d\'aide ?';

  @override
  String get supportDescription =>
      'Vous rencontrez un problème avec Taskly ? Contactez notre équipe de support, nous serons ravis de vous aider.';

  @override
  String get supportEmailLabel => 'E-mail du support';

  @override
  String get supportEmail => 'l.akalete20@gmail.com';

  @override
  String get supportContactUs => 'Contacter le support';

  @override
  String get supportEmailCopied =>
      'E-mail du support copié dans le presse-papiers';

  @override
  String get focusTitle => 'Focus';

  @override
  String get focusHint => 'Concentre-toi sur une tâche à la fois';

  @override
  String get focusStart => 'Commencer';

  @override
  String get focusDone => 'Bravo !';

  @override
  String get focusNext => 'Tâche suivante';

  @override
  String get minutesShort => 'min';

  @override
  String tasksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tâches',
      one: '1 tâche',
      zero: 'Aucune tâche',
    );
    return '$_temp0';
  }

  @override
  String completedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count faites',
      one: '1 faite',
    );
    return '$_temp0';
  }

  @override
  String get loginTitle => 'Bienvenue sur Taskly';

  @override
  String get loginSubtitle =>
      'Connecte-toi pour synchroniser et sécuriser tes tâches sur tous tes appareils.';

  @override
  String get loginWithGoogle => 'Continuer avec Google';

  @override
  String get loginPrivacy =>
      'En continuant, tu acceptes nos conditions et notre politique de confidentialité. Tes données restent privées et visibles uniquement par toi.';

  @override
  String get googleSignInError =>
      'Échec de la connexion. Vérifie ta connexion internet et réessaie.';

  @override
  String get settingsAccount => 'Compte';

  @override
  String get signedInAs => 'Connecté en tant que';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get cloudSync => 'Synchronisation cloud';

  @override
  String get cloudSyncEnabled =>
      'Tes tâches sont synchronisées de manière sécurisée sur ton compte Firebase.';

  @override
  String get cloudSyncOffline =>
      'Mode hors-ligne : les tâches sont stockées localement sur cet appareil.';

  @override
  String get anonymousUser => 'Utilisateur inconnu';

  @override
  String get loginName => 'Nom (optionnel)';

  @override
  String get loginNameRequired => 'Merci d\'indiquer votre nom';

  @override
  String get loginEmail => 'E-mail';

  @override
  String get loginEmailRequired => 'Saisissez un e-mail valide';

  @override
  String get loginPassword => 'Mot de passe';

  @override
  String get loginPasswordShort => 'Au moins 6 caractères';

  @override
  String get loginShowPassword => 'Afficher le mot de passe';

  @override
  String get loginAction => 'Se connecter';

  @override
  String get loginCreateAction => 'Créer un compte';

  @override
  String get loginCreateSubtitle =>
      'Créez votre compte pour synchroniser et sécuriser vos tâches sur tous vos appareils.';

  @override
  String get loginNoAccount => 'Pas encore de compte ? Créer-en un';

  @override
  String get loginHaveAccount => 'Déjà un compte ? Se connecter';

  @override
  String get authError =>
      'Échec de l\'authentification. Vérifiez votre e-mail / mot de passe et réessayez.';
}
