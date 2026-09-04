import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../core/theme/app_theme.dart';

/// Grande horloge en temps réel (heures:minutes:secondes) + date.
/// Fonctionne hors-ligne, mise à jour chaque seconde.
class LiveClock extends HookWidget {
  const LiveClock({super.key});

  static const _daysFr = [
    'lundi',
    'mardi',
    'mercredi',
    'jeudi',
    'vendredi',
    'samedi',
    'dimanche',
  ];
  static const _daysEn = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  static const _monthsFr = [
    'janvier',
    'février',
    'mars',
    'avril',
    'mai',
    'juin',
    'juillet',
    'août',
    'septembre',
    'octobre',
    'novembre',
    'décembre',
  ];
  static const _monthsEn = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    final now = useNowUpdater();
    final time = now.toLocal();

    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    final seconds = time.second.toString().padLeft(2, '0');

    final isFr = Localizations.localeOf(context).languageCode == 'fr';
    final days = isFr ? _daysFr : _daysEn;
    final months = isFr ? _monthsFr : _monthsEn;
    final dateText =
        '${days[time.weekday - 1]} ${time.day} ${months[time.month - 1]} ${time.year}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        gradient: AppTheme.gradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C5CE7).withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$hours:$minutes',
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -2,
                    color: Colors.white,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
                TextSpan(
                  text: ':$seconds',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.85),
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            dateText[0].toUpperCase() + dateText.substring(1),
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withValues(alpha: 0.95),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Hook qui retourne l'heure actuelle, rafraîchie chaque seconde.
DateTime useNowUpdater() {
  final now = useState(DateTime.now());
  useEffect(() {
    final timer = Timer.periodic(const Duration(seconds: 1), (_) {
      now.value = DateTime.now();
    });
    return timer.cancel;
  }, const []);
  return now.value;
}
