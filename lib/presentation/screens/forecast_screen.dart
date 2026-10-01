import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../providers/settings_provider.dart';
import '../providers/weather_providers.dart';
import '../widgets/forecast_item_card.dart';

/// Screen 3: 5-Day Forecast screen displaying daily aggregated weather.
class ForecastScreen extends ConsumerWidget {
  final String cityName;

  const ForecastScreen({super.key, required this.cityName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unitSymbol = ref.watch(settingsProvider.select((s) => s.unitSymbol));
    final forecastAsync = ref.watch(forecastProvider(cityName));

    return Scaffold(
      appBar: AppBar(
        title: Text('${l10n?.forecastTitle ?? "Forecast"} - $cityName'),
      ),
      body: forecastAsync.when(
        data: (days) {
          if (days.isEmpty) {
            return Center(
              child: Text(l10n?.errorOccurred ?? 'No forecast data available.'),
            );
          }

          return ListView.builder(
            itemCount: days.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              final day = days[index];
              return ForecastItemCard(
                forecastDay: day,
                unitSymbol: unitSymbol,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n?.errorOccurred ?? 'Failed to load forecast'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.invalidate(forecastProvider(cityName)),
                child: Text(l10n?.retry ?? 'Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
