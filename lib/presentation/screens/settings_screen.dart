import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../providers/settings_provider.dart';

/// Screen 5: Settings screen for configuring language and temperature units.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.settingsTitle ?? 'Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.language_rounded,
                          color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        l10n?.language ?? 'Language',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<String>(
                      key: const Key('language_segmented_button'),
                      segments: [
                        ButtonSegment<String>(
                          value: 'fr',
                          label: Text(l10n?.french ?? 'Français'),
                          icon: const Icon(Icons.check),
                        ),
                        ButtonSegment<String>(
                          value: 'en',
                          label: Text(l10n?.english ?? 'English'),
                          icon: const Icon(Icons.check),
                        ),
                      ],
                      selected: {settings.locale.languageCode},
                      onSelectionChanged: (Set<String> newSelection) {
                        ref
                            .read(settingsProvider.notifier)
                            .setLocale(Locale(newSelection.first));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.thermostat_rounded,
                          color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        l10n?.unit ?? 'Temperature Unit',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<String>(
                      key: const Key('unit_segmented_button'),
                      segments: [
                        ButtonSegment<String>(
                          value: 'metric',
                          label: Text(l10n?.celsius ?? 'Celsius (°C)'),
                        ),
                        ButtonSegment<String>(
                          value: 'imperial',
                          label: Text(l10n?.fahrenheit ?? 'Fahrenheit (°F)'),
                        ),
                      ],
                      selected: {settings.unit},
                      onSelectionChanged: (Set<String> newSelection) {
                        ref
                            .read(settingsProvider.notifier)
                            .setUnit(newSelection.first);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
