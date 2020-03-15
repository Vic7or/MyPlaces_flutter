import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
  }

  static String get appTitle => 'MyPlaces';

  String get today => Intl.message(
    'Today',
    name: 'today',
    args: <String>[],
    locale: locale.toString(),
  );

  String get tomorrow => Intl.message(
    'Tomorrow',
    name: 'tomorrow',
    args: <String>[],
    locale: locale.toString(),
  );

  String get yesterday => Intl.message(
    'Yesterday',
    name: 'yesterday',
    args: <String>[],
    locale: locale.toString(),
  );

  String get games => Intl.message(
    'Games',
    name: 'games',
    args: <String>[],
    locale: locale.toString(),
  );


  String courtsList(String task) => Intl.message(
    'Courts: $task',
    name: 'courtsList',
    args: <String>[task],
    locale: locale.toString(),
  );


  String gameDeleted(String task) => Intl.message(
    'Deleted "$task"',
    name: 'gameDeleted',
    args: <String>[task],
    locale: locale.toString(),
  );
}

class AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  @override
  Future<AppLocalizations> load(Locale locale) =>
      Future<AppLocalizations>(() => AppLocalizations(locale));

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode.toLowerCase().contains('en');
}
