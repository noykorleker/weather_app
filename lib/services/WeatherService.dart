import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'LocationService.dart';

class WeatherService {
  final String _apiKey = '87a72fe56009dc17d4898aa2cd32f615';
  static const String _cachedTemperatureKey = 'cached_temperature';
  static const String _cachedCityKey = 'cached_city';

  // Initialize weather with cached location
  static Future<void> initializeWeather() async {
    try {
      final location = await LocationService.getCachedLocation();

      if (location != null) {
        final prefs = await SharedPreferences.getInstance();
        final weatherService = WeatherService();
        final weatherData = await weatherService.fetchWeatherByCoordinates(
          latitude: location.latitude,
          longitude: location.longitude,
        );

        // Cache the weather data
        prefs.setDouble(_cachedTemperatureKey, weatherData['main']['temp']);
        prefs.setString(_cachedCityKey, weatherData['name']);
      } else {
        print("No cached location found. Unable to initialize weather.");
      }
    } catch (e) {
      print("Error initializing weather: $e");
    }
  }

  // Fetch weather data by city name
  Future<Map<String, dynamic>> fetchWeatherData(String city) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print('Error fetching weather data: $e');
      rethrow;
    }
  }

  // Fetch weather data by coordinates
  Future<Map<String, dynamic>> fetchWeatherByCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print('Error fetching weather data: $e');
      rethrow;
    }
  }

  // Get cached weather data
  static Future<Map<String, dynamic>?> getCachedWeather() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_cachedTemperatureKey) &&
        prefs.containsKey(_cachedCityKey)) {
      return {
        'city': prefs.getString(_cachedCityKey),
        'temp': prefs.getDouble(_cachedTemperatureKey),
      };
    }
    return null;
  }
}

/*
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'LocationService.dart';

class WeatherService {
  final String _apiKey = '87a72fe56009dc17d4898aa2cd32f615';

  static Future<void> initializeWeather() async {
    try {
      final location = await LocationService.getCachedLocation();

      if (location != null) {
        // Fetch weather data based on the cached location
        print(
          "Initializing weather with cached location: ${location.latitude}, ${location.longitude}",
        );
        // Add your weather API call here using the location
      } else {
        print("No cached location found. Unable to initialize weather.");
      }
    } catch (e) {
      print("Error initializing weather: $e");
    }
  }

  // Fetch weather data from the API
  Future<Map<String, dynamic>> fetchWeatherData(String city) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print('Error fetching weather data: $e');
      rethrow;
    }
  }
}
*/
