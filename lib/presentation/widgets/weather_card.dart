import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/models/weather_model.dart';
import '../../l10n/app_localizations.dart';

/// Card displaying current weather summary with rich aesthetics and cached icon.
class WeatherCard extends StatelessWidget {
  final WeatherModel weather;
  final String unitSymbol;
  final VoidCallback? onTap;

  const WeatherCard({
    super.key,
    required this.weather,
    this.unitSymbol = '°C',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    final semanticLabel =
        '${weather.cityName}, ${weather.country}: ${weather.temperature.round()}$unitSymbol, ${weather.description}';

    return Semantics(
      label: semanticLabel,
      button: onTap != null,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: theme.brightness == Brightness.dark
                    ? const [Color(0xFF1E293B), Color(0xFF0F172A)]
                    : const [Colors.white, Color(0xFFF1F5F9)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            weather.cityName,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (weather.country.isNotEmpty)
                            Text(
                              weather.country,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                        ],
                      ),
                    ),
                    CachedNetworkImage(
                      imageUrl: AppConstants.iconUrl(weather.icon),
                      width: 64,
                      height: 64,
                      placeholder: (context, url) => const SizedBox(
                        width: 64,
                        height: 64,
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.wb_sunny_rounded,
                        size: 48,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${weather.temperature.round()}',
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                      ),
                    ),
                    Text(
                      unitSymbol,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        weather.description,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _WeatherStat(
                      icon: Icons.thermostat_rounded,
                      label: l10n?.feelsLike ?? 'Feels like',
                      value: '${weather.feelsLike.round()}$unitSymbol',
                    ),
                    _WeatherStat(
                      icon: Icons.water_drop_rounded,
                      label: l10n?.humidity ?? 'Humidity',
                      value: '${weather.humidity}%',
                    ),
                    _WeatherStat(
                      icon: Icons.air_rounded,
                      label: l10n?.windSpeed ?? 'Wind',
                      value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WeatherStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _WeatherStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
