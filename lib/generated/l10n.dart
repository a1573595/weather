// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Weather`
  String get weather {
    return Intl.message(
      'Weather',
      name: 'weather',
      desc: '',
      args: [],
    );
  }

  /// `can't get permission`
  String get cant_get_permission {
    return Intl.message(
      'can\'t get permission',
      name: 'cant_get_permission',
      desc: '',
      args: [],
    );
  }

  /// `can't get location`
  String get cant_get_location {
    return Intl.message(
      'can\'t get location',
      name: 'cant_get_location',
      desc: '',
      args: [],
    );
  }

  /// `Day {dayTemp}° ↑ • Night {nightTemp}° ↓`
  String day_temp_night_temp(Object dayTemp, Object nightTemp) {
    return Intl.message(
      'Day $dayTemp° ↑ • Night $nightTemp° ↓',
      name: 'day_temp_night_temp',
      desc: '',
      args: [dayTemp, nightTemp],
    );
  }

  /// `Feels like {temp}°`
  String feels_like(Object temp) {
    return Intl.message(
      'Feels like $temp°',
      name: 'feels_like',
      desc: '',
      args: [temp],
    );
  }

  /// `Press again to exit.`
  String get press_again_to_exit {
    return Intl.message(
      'Press again to exit.',
      name: 'press_again_to_exit',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'TW'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
