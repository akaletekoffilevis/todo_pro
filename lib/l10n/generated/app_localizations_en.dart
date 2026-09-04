// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Taskly';

  @override
  String get appTitleDescription => 'Application title';

  @override
  String get appTagline => 'Organize your day, achieve more';

  @override
  String get appTaglineDescription => 'Home tagline';

  @override
  String get navHome => 'Today';

  @override
  String get navTasks => 'Tasks';

  @override
  String get navStats => 'Stats';

  @override
  String get navSettings => 'Settings';

  @override
  String get homeGreeting => 'Good day';

  @override
  String get addTask => 'New task';

  @override
  String get editTask => 'Edit task';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get complete => 'Complete';

  @override
  String get markDone => 'Mark as done';

  @override
  String get unmarkDone => 'Mark as not done';

  @override
  String get pending => 'Pending';

  @override
  String get completed => 'Completed';

  @override
  String get overdue => 'Overdue';

  @override
  String get tasksToDo => 'Things to do';

  @override
  String get todayTitle => 'Today';

  @override
  String get allTasksTitle => 'All tasks';

  @override
  String get noTasks => 'No tasks yet';

  @override
  String get noTasksHint => 'Tap + to create your first task';

  @override
  String get noResults => 'No results found';

  @override
  String get noResultsHint => 'Try changing your search or filters';

  @override
  String get searchPlaceholder => 'Search tasks…';

  @override
  String get filters => 'Filters';

  @override
  String get sortBy => 'Sort by';

  @override
  String get sortDate => 'Date';

  @override
  String get sortPriority => 'Priority';

  @override
  String get sortTitle => 'Title';

  @override
  String get sortCreated => 'Created';

  @override
  String get ascending => 'Ascending';

  @override
  String get descending => 'Descending';

  @override
  String get statusAll => 'All';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusOverdue => 'Overdue';

  @override
  String get statusToday => 'Today';

  @override
  String get priorityAll => 'All priorities';

  @override
  String get clearFilters => 'Clear';

  @override
  String get taskTitle => 'Task title';

  @override
  String get taskDescription => 'Description (optional)';

  @override
  String get taskDate => 'Date & time';

  @override
  String get taskCategory => 'Category';

  @override
  String get taskPriority => 'Priority';

  @override
  String get setReminder => 'Reminder';

  @override
  String get priorityLow => 'Low';

  @override
  String get priorityMedium => 'Medium';

  @override
  String get priorityHigh => 'High';

  @override
  String get priorityUrgent => 'Urgent';

  @override
  String get categoryPersonal => 'Personal';

  @override
  String get categoryWork => 'Work';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryShopping => 'Shopping';

  @override
  String get categoryStudies => 'Studies';

  @override
  String get categoryOther => 'Other';

  @override
  String get statsTitle => 'Statistics';

  @override
  String get statsTotal => 'Total';

  @override
  String get statsDone => 'Done';

  @override
  String get statsActive => 'Active';

  @override
  String get statsOverdue => 'Overdue';

  @override
  String get progressLabel => 'Progress';

  @override
  String get statsByCategory => 'By category';

  @override
  String get statsByPriority => 'By priority';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get language => 'Language';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get notifications => 'Notifications';

  @override
  String get remindersEnabled => 'Enable reminders';

  @override
  String get settingsSupport => 'Help & support';

  @override
  String get supportTitle => 'Need help?';

  @override
  String get supportDescription =>
      'Having trouble using Taskly? Reach out to our support team and we\'ll be happy to help.';

  @override
  String get supportEmailLabel => 'Support email';

  @override
  String get supportEmail => 'l.akalete20@gmail.com';

  @override
  String get supportContactUs => 'Contact support';

  @override
  String get supportEmailCopied => 'Support email copied to clipboard';

  @override
  String get focusTitle => 'Focus';

  @override
  String get focusHint => 'Focus on one task at a time';

  @override
  String get focusStart => 'Start';

  @override
  String get focusDone => 'Well done!';

  @override
  String get focusNext => 'Next task';

  @override
  String get minutesShort => 'min';

  @override
  String tasksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks',
      one: '1 task',
      zero: 'No tasks',
    );
    return '$_temp0';
  }

  @override
  String completedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count done',
      one: '1 done',
    );
    return '$_temp0';
  }
}
