import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../providers/favorites_provider.dart';

/// Screen 4: Favorites screen showing locally stored favorite cities.
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final favoritesAsync = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.favoritesTitle ?? 'Saved Cities'),
      ),
      body: favoritesAsync.when(
        data: (cities) {
          if (cities.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.favorite_border_rounded,
                      size: 64,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n?.noFavorites ?? 'No favorite cities yet.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: cities.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              final city = cities[index];
              return Dismissible(
                key: Key('fav_$city'),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                  ref.read(favoritesProvider.notifier).toggleFavorite(city);
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Colors.redAccent,
                  child: const Icon(Icons.delete_rounded, color: Colors.white),
                ),
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          theme.colorScheme.primary.withValues(alpha: 0.1),
                      child: Icon(Icons.location_city_rounded,
                          color: theme.colorScheme.primary),
                    ),
                    title: Text(
                      city,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline_rounded,
                          color: Colors.redAccent),
                      tooltip: l10n?.removeFromFavorites ?? 'Remove',
                      onPressed: () {
                        ref
                            .read(favoritesProvider.notifier)
                            .toggleFavorite(city);
                      },
                    ),
                    onTap: () {
                      context.push('/detail', extra: city);
                    },
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(l10n?.errorOccurred ?? 'Failed to load favorites'),
        ),
      ),
    );
  }
}
