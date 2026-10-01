import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';

class SettingsState {
  final Locale locale;
  final String unit; // 'metric' or 'imperial'

  const SettingsState({
    required this.locale,
    required this.unit,
  });

  String get unitSymbol => unit == 'imperial' ? '°F' : '°C';
  String get speedSymbol => unit == 'imperial' ? 'mph' : 'm/s';

  SettingsState copyWith({
    Locale? locale,
    String? unit,
  }) {
    return SettingsState(
      locale: locale ?? this.locale,
      unit: unit ?? this.unit,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final Box<dynamic>? customBox;

  SettingsNotifier({this.customBox})
      : super(const SettingsState(locale: Locale('fr'), unit: 'metric')) {
    _loadSettings();
  }

  Box<dynamic>? _getBox() {
    if (customBox != null) return customBox;
    if (Hive.isBoxOpen(AppConstants.hiveSettingsBox)) {
      return Hive.box<dynamic>(AppConstants.hiveSettingsBox);
    }
    return null;
  }

  void _loadSettings() {
    final box = _getBox();
    if (box != null) {
      final langCode = box.get('language_code', defaultValue: 'fr') as String;
      final unit = box.get('unit', defaultValue: 'metric') as String;
      state = SettingsState(locale: Locale(langCode), unit: unit);
    }
  }

  Future<void> setLocale(Locale newLocale) async {
    state = state.copyWith(locale: newLocale);
    final box = _getBox();
    await box?.put('language_code', newLocale.languageCode);
  }

  Future<void> setUnit(String newUnit) async {
    state = state.copyWith(unit: newUnit);
    final box = _getBox();
    await box?.put('unit', newUnit);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
