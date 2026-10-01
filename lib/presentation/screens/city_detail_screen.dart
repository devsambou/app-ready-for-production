import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../l10n/app_localizations.dart';
import '../providers/favorites_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/weather_providers.dart';

/// Screen 2: City Detail screen displaying full weather attributes and favorite toggle.
class CityDetailScreen extends ConsumerWidget {
  final String cityName;

  const CityDetailScreen({super.key, required this.cityName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final unitSymbol = ref.watch(settingsProvider.select((s) => s.unitSymbol));
    final speedSymbol =
        ref.watch(settingsProvider.select((s) => s.speedSymbol));
    final weatherAsync = ref.watch(currentWeatherProvider(cityName));

    final isFav = ref.watch(favoritesProvider).value?.any(
              (c) => c.toLowerCase() == cityName.trim().toLowerCase(),
            ) ??
        false;

    return Scaffold(
      appBar: AppBar(
        title: Text(cityName),
        actions: [
          IconButton(
            key: const Key('favorite_toggle_button'),
            icon: Icon(
              isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isFav ? Colors.redAccent : null,
            ),
            tooltip: isFav
                ? (l10n?.removeFromFavorites ?? 'Remove from favorites')
                : (l10n?.addToFavorites ?? 'Add to favorites'),
            onPressed: () async {
              await ref
                  .read(favoritesProvider.notifier)
                  .toggleFavorite(cityName);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 2),
                    content: Text(
                      isFav
                          ? (l10n?.favoriteRemoved ??
                              'City removed from favorites')
                          : (l10n?.favoriteAdded ?? 'City added to favorites'),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: weatherAsync.when(
        data: (weather) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: AppConstants.iconUrl(weather.icon),
                  width: 100,
                  height: 100,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.wb_sunny_rounded, size: 80),
                ),
                Text(
                  '${weather.temperature.round()}$unitSymbol',
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  weather.description.toUpperCase(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${weather.cityName}, ${weather.country}',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _DetailRow(
                          icon: Icons.thermostat_rounded,
                          label: l10n?.feelsLike ?? 'Feels like',
                          value: '${weather.feelsLike.round()}$unitSymbol',
                        ),
                        const Divider(),
                        _DetailRow(
                          icon: Icons.arrow_upward_rounded,
                          label: 'Min / Max',
                          value:
                              '${weather.tempMin.round()}$unitSymbol / ${weather.tempMax.round()}$unitSymbol',
                        ),
                        const Divider(),
                        _DetailRow(
                          icon: Icons.water_drop_rounded,
                          label: l10n?.humidity ?? 'Humidity',
                          value: '${weather.humidity}%',
                        ),
                        const Divider(),
                        _DetailRow(
                          icon: Icons.compress_rounded,
                          label: l10n?.pressure ?? 'Pressure',
                          value: '${weather.pressure} hPa',
                        ),
                        const Divider(),
                        _DetailRow(
                          icon: Icons.air_rounded,
                          label: l10n?.windSpeed ?? 'Wind Speed',
                          value:
                              '${weather.windSpeed.toStringAsFixed(1)} $speedSymbol',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.push('/forecast', extra: cityName);
                    },
                    icon: const Icon(Icons.calendar_month_rounded),
                    label: Text(l10n?.viewForecast ?? 'View 5-day forecast'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n?.errorOccurred ?? 'Error loading details'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () =>
                    ref.invalidate(currentWeatherProvider(cityName)),
                child: Text(l10n?.retry ?? 'Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 22, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Text(label, style: theme.textTheme.bodyMedium),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
