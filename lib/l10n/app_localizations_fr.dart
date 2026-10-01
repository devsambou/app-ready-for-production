// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Météo Pro';

  @override
  String get navHome => 'Accueil';

  @override
  String get navFavorites => 'Favoris';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get navForecast => 'Prévisions';

  @override
  String get searchHint => 'Rechercher une ville (ex: Paris, Tokyo)...';

  @override
  String get searchLabel => 'Champ de recherche de ville';

  @override
  String get searchAction => 'Rechercher';

  @override
  String get defaultCity => 'Paris';

  @override
  String get favoritesTitle => 'Villes Favorites';

  @override
  String get noFavorites =>
      'Aucune ville favorite pour le moment. Ajoutez-en depuis le détail !';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get language => 'Langue';

  @override
  String get unit => 'Unité de température';

  @override
  String get celsius => 'Celsius (°C)';

  @override
  String get fahrenheit => 'Fahrenheit (°F)';

  @override
  String get english => 'Anglais';

  @override
  String get french => 'Français';

  @override
  String get weatherDetails => 'Détails météo';

  @override
  String get feelsLike => 'Ressenti';

  @override
  String get humidity => 'Humidité';

  @override
  String get windSpeed => 'Vitesse du vent';

  @override
  String get pressure => 'Pression';

  @override
  String get forecastTitle => 'Prévisions sur 5 jours';

  @override
  String get addToFavorites => 'Ajouter aux favoris';

  @override
  String get removeFromFavorites => 'Retirer des favoris';

  @override
  String get favoriteAdded => 'Ville ajoutée aux favoris';

  @override
  String get favoriteRemoved => 'Ville retirée des favoris';

  @override
  String get retry => 'Réessayer';

  @override
  String get errorOccurred =>
      'Une erreur est survenue lors du chargement des données météo.';

  @override
  String get cityNotFound =>
      'Ville non trouvée. Veuillez vérifier l\'orthographe.';

  @override
  String get networkError =>
      'Erreur réseau. Veuillez vérifier votre connexion internet.';

  @override
  String get viewForecast => 'Voir les prévisions 5 jours';

  @override
  String get lastUpdated => 'Mis à jour à l\'instant';
}
