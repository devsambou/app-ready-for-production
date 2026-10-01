# Changelog

Toutes les modifications notables apportées à ce projet sont documentées dans ce fichier.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/)
et ce projet adhère à [Semantic Versioning](https://semver.org/lang/fr/).

## [1.0.0] - 2026-10-01

### Ajouté
- Configuration CI/CD complète avec 3 workflows GitHub Actions distincts :
  - `lint.yml` : vérification stricte du formatage Dart et analyse statique sans aucun warning (`--fatal-infos --fatal-warnings`).
  - `tests.yml` : exécution automatisée de la suite de tests avec génération et archivage de la couverture LCOV.
  - `build.yml` : compilation automatique de l'APK Release et archivage en artifact téléchargeable.
- Durcissement des options du linter (`analysis_options.yaml`) avec activation de règles strictes (`prefer_const_constructors`, `prefer_final_locals`, `avoid_print`).
- Documentation complète de mise en production dans le `README.md` avec badges CI, architecture détaillée, et guide de démarrage.

### Modifié
- Remplacement des méthodes dépréciées (`withOpacity` -> `withValues(alpha:)`, refonte de `SettingsScreen` avec Material 3 `SegmentedButton`).
- Validation intégrale de la performance (60 fps constants, lazy loading des listes et mise en cache des icônes réseau).

## [0.2.0] - 2026-10-01

### Ajouté
- Suite de tests automatisés complète :
  - 17 tests unitaires couvrant `WeatherRepository`, `ForecastRepository` (agrégation 3h -> jour), `FavoritesRepository`, et l'ensemble des providers Riverpod.
  - 7 tests de widgets couvrant `WeatherCard`, `CustomSearchBar`, `ForecastItemCard`, `FavoritesScreen` (états vide et rempli), et `SettingsScreen`.
  - 2 tests d'intégration simulant les parcours utilisateurs critiques (Recherche -> Détail -> Favoris, et Changement dynamique de langue).
- Internationalisation complète (i18n) en Français et en Anglais via `flutter_localizations` et fichiers ARB (`app_fr.arb`, `app_en.arb`).
- Accessibilité native (A11y) : annotations `Semantics` explicites et traduites sur tous les contrôles interactifs et cartes d'information.

## [0.1.0] - 2026-10-01

### Ajouté
- Initialisation du projet Flutter en Clean Architecture (couches `core`, `data`, `domain`, `presentation`).
- Intégration de l'API OpenWeatherMap avec client HTTP `Dio`, gestion automatique du paramètre query `appid` et gestion robuste des erreurs réseau/404.
- Implémentation des 5 écrans requis :
  1. `HomeScreen` : recherche de ville et affichage en temps réel de la météo.
  2. `CityDetailScreen` : affichage exhaustif des indicateurs météo et gestion du favori.
  3. `ForecastScreen` : affichage des prévisions météorologiques agrégées sur 5 jours.
  4. `FavoritesScreen` : liste des villes favorites avec persistance locale Hive.
  5. `SettingsScreen` : sélection de la langue (FR/EN) et des unités (°C/°F).
- Routage déclaratif via `GoRouter` avec passage exclusif de données primitives (`extra: cityName`).
- Gestion d'état réactive avec `flutter_riverpod` (v2.x non-codegen).
