import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Taskly'**
  String get appTitle;

  /// No description provided for @appTitleDescription.
  ///
  /// In en, this message translates to:
  /// **'Application title'**
  String get appTitleDescription;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Organize your day, achieve more'**
  String get appTagline;

  /// No description provided for @appTaglineDescription.
  ///
  /// In en, this message translates to:
  /// **'Home tagline'**
  String get appTaglineDescription;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get navHome;

  /// No description provided for @navTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get navTasks;

  /// No description provided for @navStats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get navStats;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Good day'**
  String get homeGreeting;

  /// No description provided for @addTask.
  ///
  /// In en, this message translates to:
  /// **'New task'**
  String get addTask;

  /// No description provided for @editTask.
  ///
  /// In en, this message translates to:
  /// **'Edit task'**
  String get editTask;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @markDone.
  ///
  /// In en, this message translates to:
  /// **'Mark as done'**
  String get markDone;

  /// No description provided for @unmarkDone.
  ///
  /// In en, this message translates to:
  /// **'Mark as not done'**
  String get unmarkDone;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @tasksToDo.
  ///
  /// In en, this message translates to:
  /// **'Things to do'**
  String get tasksToDo;

  /// No description provided for @todayTitle.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayTitle;

  /// No description provided for @allTasksTitle.
  ///
  /// In en, this message translates to:
  /// **'All tasks'**
  String get allTasksTitle;

  /// No description provided for @noTasks.
  ///
  /// In en, this message translates to:
  /// **'No tasks yet'**
  String get noTasks;

  /// No description provided for @noTasksHint.
  ///
  /// In en, this message translates to:
  /// **'Tap + to create your first task'**
  String get noTasksHint;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @noResultsHint.
  ///
  /// In en, this message translates to:
  /// **'Try changing your search or filters'**
  String get noResultsHint;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search tasks…'**
  String get searchPlaceholder;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @sortDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get sortDate;

  /// No description provided for @sortPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get sortPriority;

  /// No description provided for @sortTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get sortTitle;

  /// No description provided for @sortCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get sortCreated;

  /// No description provided for @ascending.
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get ascending;

  /// No description provided for @descending.
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get descending;

  /// No description provided for @statusAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get statusAll;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get statusOverdue;

  /// No description provided for @statusToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get statusToday;

  /// No description provided for @priorityAll.
  ///
  /// In en, this message translates to:
  /// **'All priorities'**
  String get priorityAll;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearFilters;

  /// No description provided for @taskTitle.
  ///
  /// In en, this message translates to:
  /// **'Task title'**
  String get taskTitle;

  /// No description provided for @taskDescription.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get taskDescription;

  /// No description provided for @taskDate.
  ///
  /// In en, this message translates to:
  /// **'Date & time'**
  String get taskDate;

  /// No description provided for @taskCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get taskCategory;

  /// No description provided for @taskPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get taskPriority;

  /// No description provided for @setReminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get setReminder;

  /// No description provided for @priorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get priorityLow;

  /// No description provided for @priorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get priorityMedium;

  /// No description provided for @priorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get priorityHigh;

  /// No description provided for @priorityUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get priorityUrgent;

  /// No description provided for @categoryPersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get categoryPersonal;

  /// No description provided for @categoryWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get categoryWork;

  /// No description provided for @categoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get categoryHealth;

  /// No description provided for @categoryShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get categoryShopping;

  /// No description provided for @categoryStudies.
  ///
  /// In en, this message translates to:
  /// **'Studies'**
  String get categoryStudies;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// No description provided for @statsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statsTitle;

  /// No description provided for @statsTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get statsTotal;

  /// No description provided for @statsDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get statsDone;

  /// No description provided for @statsActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statsActive;

  /// No description provided for @statsOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get statsOverdue;

  /// No description provided for @progressLabel.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progressLabel;

  /// No description provided for @statsByCategory.
  ///
  /// In en, this message translates to:
  /// **'By category'**
  String get statsByCategory;

  /// No description provided for @statsByPriority.
  ///
  /// In en, this message translates to:
  /// **'By priority'**
  String get statsByPriority;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @remindersEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enable reminders'**
  String get remindersEnabled;

  /// No description provided for @settingsSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & support'**
  String get settingsSupport;

  /// No description provided for @supportTitle.
  ///
  /// In en, this message translates to:
  /// **'Need help?'**
  String get supportTitle;

  /// No description provided for @supportDescription.
  ///
  /// In en, this message translates to:
  /// **'Having trouble using Taskly? Reach out to our support team and we\'ll be happy to help.'**
  String get supportDescription;

  /// No description provided for @supportEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Support email'**
  String get supportEmailLabel;

  /// No description provided for @supportEmail.
  ///
  /// In en, this message translates to:
  /// **'l.akalete20@gmail.com'**
  String get supportEmail;

  /// No description provided for @supportContactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact support'**
  String get supportContactUs;

  /// No description provided for @supportEmailCopied.
  ///
  /// In en, this message translates to:
  /// **'Support email copied to clipboard'**
  String get supportEmailCopied;

  /// No description provided for @focusTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get focusTitle;

  /// No description provided for @focusHint.
  ///
  /// In en, this message translates to:
  /// **'Focus on one task at a time'**
  String get focusHint;

  /// No description provided for @focusStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get focusStart;

  /// No description provided for @focusDone.
  ///
  /// In en, this message translates to:
  /// **'Well done!'**
  String get focusDone;

  /// No description provided for @focusNext.
  ///
  /// In en, this message translates to:
  /// **'Next task'**
  String get focusNext;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutesShort;

  /// No description provided for @tasksCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No tasks} =1{1 task} other{{count} tasks}}'**
  String tasksCount(int count);

  /// No description provided for @completedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 done} other{{count} done}}'**
  String completedCount(int count);

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Taskly'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync and secure your tasks across all your devices.'**
  String get loginSubtitle;

  /// No description provided for @loginWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get loginWithGoogle;

  /// No description provided for @loginPrivacy.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our Terms and Privacy Policy. Your data stays private and visible only to you.'**
  String get loginPrivacy;

  /// No description provided for @googleSignInError.
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed. Please check your connection and try again.'**
  String get googleSignInError;

  /// No description provided for @settingsAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccount;

  /// No description provided for @signedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as'**
  String get signedInAs;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @cloudSync.
  ///
  /// In en, this message translates to:
  /// **'Cloud sync'**
  String get cloudSync;

  /// No description provided for @cloudSyncEnabled.
  ///
  /// In en, this message translates to:
  /// **'Your tasks are synced securely to your Firebase account.'**
  String get cloudSyncEnabled;

  /// No description provided for @cloudSyncOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline mode: tasks are stored locally on this device.'**
  String get cloudSyncOffline;

  /// No description provided for @anonymousUser.
  ///
  /// In en, this message translates to:
  /// **'Unknown user'**
  String get anonymousUser;

  /// No description provided for @loginName.
  ///
  /// In en, this message translates to:
  /// **'Name (optional)'**
  String get loginName;

  /// No description provided for @loginNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get loginNameRequired;

  /// No description provided for @loginEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmail;

  /// No description provided for @loginEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get loginEmailRequired;

  /// No description provided for @loginPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPassword;

  /// No description provided for @loginPasswordShort.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get loginPasswordShort;

  /// No description provided for @loginShowPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get loginShowPassword;

  /// No description provided for @loginAction.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginAction;

  /// No description provided for @loginCreateAction.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get loginCreateAction;

  /// No description provided for @loginCreateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account to sync and secure your tasks across all your devices.'**
  String get loginCreateSubtitle;

  /// No description provided for @loginNoAccount.
  ///
  /// In en, this message translates to:
  /// **'No account yet? Create one'**
  String get loginNoAccount;

  /// No description provided for @loginHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get loginHaveAccount;

  /// No description provided for @authError.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed. Check your email/password and try again.'**
  String get authError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
