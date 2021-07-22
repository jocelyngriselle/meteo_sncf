import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meteo_sncf/weather/weather.dart';

class WeatherService {
  static const _apiKey = '9f6c37aca68ed1e4bc55b2e51aefd724';
  static const _cityName = 'Paris';
  final JsonDecoder _decoder = const JsonDecoder();

  Future<List<Weather>?> fetchWeather() async {
    final response = await http.get(buildUrl());
    final jsonBody = response.body;
    final statusCode = response.statusCode;
    if (statusCode != 200) {
      return null;
    }
    final results = _decoder.convert(jsonBody)?['list'] as List;
    if (results.isEmpty) return null;
    return results.map((e) => Weather.fromJson(e)).toList();
  }

  Uri buildIconUrl(String icon) =>
      Uri.parse('http://openweathermap.org/img/w/$icon.png');
  Uri buildUrl() => Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?q=$_cityName&appid=$_apiKey&units=metric');
}
