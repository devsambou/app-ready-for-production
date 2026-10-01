import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/models/forecast_day_model.dart';

/// Card item displaying a single day forecast.
class ForecastItemCard extends StatelessWidget {
  final ForecastDayModel forecastDay;
  final String unitSymbol;

  const ForecastItemCard({
    super.key,
    required this.forecastDay,
    this.unitSymbol = '°C',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final dateFormatted = DateFormat.MMMEd(locale).format(forecastDay.date);

    final semanticText =
        '$dateFormatted: ${forecastDay.description}, min ${forecastDay.minTemp.round()}$unitSymbol, max ${forecastDay.maxTemp.round()}$unitSymbol';

    return Semantics(
      label: semanticText,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateFormatted,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      forecastDay.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              CachedNetworkImage(
                imageUrl: AppConstants.iconUrl(forecastDay.icon),
                width: 44,
                height: 44,
                placeholder: (context, url) => const SizedBox(
                  width: 44,
                  height: 44,
                  child:
                      Center(child: CircularProgressIndicator(strokeWidth: 2)),
                ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.wb_cloudy_rounded),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${forecastDay.maxTemp.round()}$unitSymbol',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${forecastDay.minTemp.round()}$unitSymbol',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
