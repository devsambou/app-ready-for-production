# WeatherApp Pro — Application Météo Production-Ready

[![Lint & Analysis](https://github.com/votre-compte/weather_app/actions/workflows/lint.yml/badge.svg)](https://github.com/votre-compte/weather_app/actions/workflows/lint.yml)
[![Automated Tests](https://github.com/votre-compte/weather_app/actions/workflows/tests.yml/badge.svg)](https://github.com/votre-compte/weather_app/actions/workflows/tests.yml)
[![Release Build](https://github.com/votre-compte/weather_app/actions/workflows/build.yml/badge.svg)](https://github.com/votre-compte/weather_app/actions/workflows/build.yml)

Application météo moderne, réactive et prête pour la production, développée avec **Flutter**, architecturée selon les principes de la **Clean Architecture**, motorisée par **Riverpod 2.x** et **GoRouter**, et connectée à l'API **OpenWeatherMap**.

Ce projet respecte les plus hauts standards d'ingénierie logicielle mobile : couverture de tests complète (unitaires, widgets, intégration), zéro warning `flutter analyze`, accessibilité native (`Semantics`), internationalisation dynamique (FR / EN), et pipeline CI/CD automatisé via GitHub Actions.

---

## 📱 Fonctionnalités et Écrans

L'application intègre 5 écrans indépendants et communicants :

1. **Accueil / Recherche (`HomeScreen`)** :
   - Barre de recherche intuitive avec validation et debounce.
   - Affichage immédiat de la météo de la ville recherchée (ou dernière ville/Paris par défaut).
   - Accès direct vers les détails complets et les prévisions.
2. **Détail de la ville (`CityDetailScreen`)** :
   - Données météorologiques complètes : température, ressenti thermique, humidité, pression atmosphérique, vitesse du vent, min/max.
   - Bouton d'ajout / retrait des favoris avec confirmation visuelle (`SnackBar`).
   - Icône météo dynamique avec mise en cache réseau.
3. **Prévisions météorologiques (`ForecastScreen`)** :
   - Prévisions agrégées sur 5 jours calculées à partir des tranches de 3 heures de l'API.
   - Liste optimisée avec `ListView.builder` garantissant 60 FPS constants.
4. **Villes Favorites (`FavoritesScreen`)** :
   - Gestion de la liste des favoris persistée localement avec **Hive**.
   - Suppression fluide par glissement (`Dismissible`) ou bouton dédié.
   - Gestion élégante de l'état vide.
5. **Paramètres (`SettingsScreen`)** :
   - Sélecteur de langue en temps réel : Français (`fr`) ou Anglais (`en`).
   - Sélecteur d'unité thermique : Celsius (`°C`) ou Fahrenheit (`°F`).
   - Persistance automatique des préférences utilisateur.

---

## 🏗️ Architecture du Projet

Le projet applique une séparation stricte des responsabilités selon la **Clean Architecture** :

```text
lib/
├── core/                         # Utilitaires transverses et constantes
│   ├── constants/app_constants.dart
│   ├── network/weather_dio_client.dart
│   └── theme/app_theme.dart
├── data/                         # Implémentation des sources de données & repos
│   ├── datasources/
│   │   ├── favorites_local_data_source.dart
│   │   └── weather_remote_data_source.dart
│   └── repositories/
│       ├── favorites_repository.dart
│       ├── forecast_repository.dart
│       └── weather_repository.dart
├── domain/                       # Logique métier pure (entités et interfaces)
│   ├── models/
│   │   ├── forecast_day_model.dart
│   │   ├── forecast_item_model.dart
│   │   └── weather_model.dart
│   └── repositories/
│       ├── favorites_repository_interface.dart
│       ├── forecast_repository_interface.dart
│       └── weather_repository_interface.dart
├── l10n/                         # Internationalisation (fichiers ARB)
│   ├── app_en.arb
│   └── app_fr.arb
└── presentation/                 # Interface utilisateur et State Management
    ├── providers/
    │   ├── favorites_provider.dart
    │   ├── settings_provider.dart
    │   └── weather_providers.dart
    ├── router/app_router.dart
    ├── screens/
    │   ├── city_detail_screen.dart
    │   ├── favorites_screen.dart
    │   ├── forecast_screen.dart
    │   ├── home_screen.dart
    │   └── settings_screen.dart
    └── widgets/
        ├── custom_search_bar.dart
        ├── forecast_item_card.dart
        └── weather_card.dart
```

### Principes architecturaux clés :
- **Navigation GoRouter** : Seules des valeurs primitives (`cityName: String`) sont transmises via `extra`, évitant ainsi le couplage fort et les désynchronisations de modèles.
- **Favoris légers (Hive)** : Seuls les identifiants/noms de villes sont enregistrés localement, les conditions météorologiques sont systématiquement rafraîchies à l'ouverture de l'écran détail.
- **Scoping fin Riverpod** : Utilisation intensive de `.select()` pour limiter les rebuilds aux seules données modifiées.

---

## 🌐 API OpenWeatherMap

L'application consomme l'API gratuite d'OpenWeatherMap :
- `GET /data/2.5/weather?q={city}&appid={key}&units={metric|imperial}` : conditions météo actuelles.
- `GET /data/2.5/forecast?q={city}&appid={key}&units={metric|imperial}` : tranches météo 3h sur 5 jours.
- `https://openweathermap.org/img/wn/{icon}@2x.png` : icônes météo officielles.

### Obtenir une clé API :
1. Créez un compte gratuit sur [OpenWeatherMap](https://openweathermap.org/).
2. Accédez à votre section **API Keys**.
3. Copiez votre clé et insérez-la dans le fichier `.env` à la racine du projet.

---

## 🚀 Installation & Configuration

### Prérequis
- Flutter SDK (≥ 3.24.0 / 3.44.x)
- Dart SDK (≥ 3.5.0 / 3.12.x)

### 1. Cloner et installer les dépendances
```bash
git clone https://github.com/votre-compte/weather_app.git
cd weather_app
flutter pub get
```

### 2. Configurer la clé d'API
Créez un fichier `.env` à la racine (ou dupliquez `.env.example`) :
```env
OPENWEATHER_API_KEY=votre_cle_api_ici
```

### 3. Lancer l'application
```bash
flutter run
```

---

## 🧪 Tests & Qualité de Code

Le projet intègre une suite de tests exhaustive validée à 100% :

### 1. Tests unitaires et de widgets
```bash
flutter test
```
*Résultat : 24 tests exécutés avec succès (17 tests unitaires métier, 7 tests de widgets).*

### 2. Couverture de code
```bash
flutter test --coverage
```
*Le rapport LCOV est généré dans `coverage/lcov.info`.*

### 3. Tests d'intégration
Les tests d'intégration simulent les parcours utilisateurs bout-en-bout :
```bash
# Sur émulateur ou appareil connecté :
flutter test integration_test/search_to_favorite_test.dart
flutter test integration_test/language_switch_test.dart
```

### 4. Analyse statique stricte
```bash
flutter analyze
dart format --output=none --set-exit-if-changed .
```
*Résultat : 0 warning, 0 information requise.*

---

## ⚡ Performance, Accessibilité & Internationalisation

- **Performance** :
  - Widgets `const` généralisés sur tous les composants immuables.
  - `CachedNetworkImage` pour la mise en cache mémoire et disque des visuels météo.
  - Découpage avec `ListView.builder` pour le recyclage efficient des cellules.
- **Accessibilité (A11y)** :
  - Widgets enveloppés dans des balises `Semantics` avec descriptions explicites lues par les lecteurs d'écran (TalkBack, VoiceOver).
- **Internationalisation (i18n)** :
  - Fichiers `.arb` natifs sans texte en dur dans les écrans.
  - Support multilingue Français (`fr`) et Anglais (`en`).

---

## 🔄 CI / CD (GitHub Actions)

3 pipelines indépendants sont configurés dans `.github/workflows/` :
- **`lint.yml`** : Formattage Dart et analyse statique (`flutter analyze`).
- **`tests.yml`** : Exécution automatique de l'ensemble des tests unitaires et widgets avec export de couverture.
- **`build.yml`** : Compilation de l'APK Release lors des push sur la branche principale et sur les tags de version `v*.*.*`.

---

## 📄 Licence

Ce projet est sous licence MIT. Libre d'utilisation pour des fins académiques ou commerciales.
