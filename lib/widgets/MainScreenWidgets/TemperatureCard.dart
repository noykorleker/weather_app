import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/LocationService.dart';
import '../../services/WeatherService.dart';

class TemperatureCard extends StatefulWidget {
  const TemperatureCard({super.key});

  @override
  _TemperatureCardState createState() => _TemperatureCardState();
}

class _TemperatureCardState extends State<TemperatureCard> {
  String? _city;
  double? _temperature;
  String? _errorMessage;
  bool _isLocationGranted = false;
  final WeatherService _weatherService = WeatherService();

  @override
  void initState() {
    super.initState();
    _initializeWeather();
  }

  Future<void> _initializeWeather() async {
    // Check if location permissions are granted
    final locationGranted = await LocationService.isLocationPermissionGranted();

    if (!locationGranted) {
      setState(() {
        _isLocationGranted = false;
        _errorMessage =
            'Location permission is required to fetch weather data.';
      });
      return;
    }

    setState(() {
      _isLocationGranted = true;
    });

    try {
      // Check for cached weather data
      final cachedWeather = await WeatherService.getCachedWeather();
      if (cachedWeather != null) {
        setState(() {
          _city = cachedWeather['city'];
          _temperature = cachedWeather['temp'];
        });
        return;
      }

      // Fetch current location and weather data
      final location = await LocationService.getCurrentLocationAddress();
      final locationParts = location.split(',').map((e) => e.trim()).toList();
      if (locationParts.length < 2) {
        setState(() {
          _errorMessage = 'Invalid location format.';
        });
        return;
      }

      setState(() {
        _city = locationParts[1];
      });

      final weatherData = await _weatherService.fetchWeatherData(_city!);
      final temp = weatherData['main']['temp'] as double;

      // Cache weather data
      final prefs = await SharedPreferences.getInstance();
      prefs.setDouble('cached_temperature', temp);
      prefs.setString('cached_city', _city!);

      setState(() {
        _temperature = temp;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching temperature: $e';
      });
    }
  }

  Widget _buildContent() {
    if (_errorMessage != null) {
      return Text(
        _errorMessage!,
        style: const TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
      );
    }

    if (_temperature == null || _city == null) {
      return const Text(
        "Fetching weather data...",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      );
    }

    return Column(
      children: [
        const Text(
          'Current Temperature in',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          _city!,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${_temperature!.toStringAsFixed(1)}°C',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_isLocationGranted) {
          _initializeWeather();
        }
      },
      child: Card(
        margin: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(child: _buildContent()),
        ),
      ),
    );
  }
}
