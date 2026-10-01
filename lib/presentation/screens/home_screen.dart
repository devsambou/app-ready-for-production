import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../l10n/app_localizations.dart';
import '../providers/settings_provider.dart';
import '../providers/weather_providers.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/weather_card.dart';

/// Screen 1: Home / Search screen displaying current weather of active search city.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final activeCity = ref.watch(searchQueryProvider);
    final unitSymbol = ref.watch(settingsProvider.select((s) => s.unitSymbol));
    final weatherAsync = ref.watch(currentWeatherProvider(activeCity));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.appTitle ?? AppConstants.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_rounded),
            tooltip: l10n?.navFavorites ?? 'Favorites',
            onPressed: () => context.push('/favorites'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            tooltip: l10n?.navSettings ?? 'Settings',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(currentWeatherProvider(activeCity));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomSearchBar(
                initialValue: activeCity,
                onSearch: (newQuery) {
                  ref.read(searchQueryProvider.notifier).state = newQuery;
                },
              ),
              const SizedBox(height: 24),
              weatherAsync.when(
                data: (weather) => Column(
                  children: [
                    WeatherCard(
                      weather: weather,
                      unitSymbol: unitSymbol,
                      onTap: () {
                        context.push('/detail', extra: weather.cityName);
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.push('/forecast', extra: weather.cityName);
                      },
                      icon: const Icon(Icons.calendar_month_rounded),
                      label: Text(l10n?.viewForecast ?? 'View 5-day forecast'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, _) {
                  final isNotFound =
                      error.toString().contains('CITY_NOT_FOUND');
                  final errorMessage = isNotFound
                      ? (l10n?.cityNotFound ?? 'City not found')
                      : (l10n?.networkError ?? 'Network error');

                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isNotFound
                                ? Icons.location_off_rounded
                                : Icons.wifi_off_rounded,
                            size: 48,
                            color: theme.colorScheme.error,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            errorMessage,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton(
                            onPressed: () => ref
                                .invalidate(currentWeatherProvider(activeCity)),
                            child: Text(l10n?.retry ?? 'Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
