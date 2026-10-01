import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/presentation/providers/settings_provider.dart';

void main() {
  test('SettingsNotifier defaults to fr and metric', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final settings = container.read(settingsProvider);
    expect(settings.locale.languageCode, equals('fr'));
    expect(settings.unit, equals('metric'));
    expect(settings.unitSymbol, equals('°C'));
  });

  test('setLocale updates the active language and setUnit updates unit',
      () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(settingsProvider.notifier);

    await notifier.setLocale(const Locale('en'));
    expect(container.read(settingsProvider).locale.languageCode, equals('en'));

    await notifier.setUnit('imperial');
    expect(container.read(settingsProvider).unit, equals('imperial'));
    expect(container.read(settingsProvider).unitSymbol, equals('°F'));
    expect(container.read(settingsProvider).speedSymbol, equals('mph'));
  });
}
