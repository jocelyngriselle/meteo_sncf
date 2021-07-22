// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weather _$WeatherFromJson(Map<String, dynamic> json) {
  return Weather(
    details: (json['weather'] as List<dynamic>)
        .map((e) => WeatherDetails.fromJson(e as Map<String, dynamic>))
        .toList(),
    temperature: Temperature.fromJson(json['main'] as Map<String, dynamic>),
    date: DateTime.parse(json['dt_txt'] as String),
  );
}

WeatherDetails _$WeatherDetailsFromJson(Map<String, dynamic> json) {
  return WeatherDetails(
    description: json['description'] as String,
    icon: json['icon'] as String,
  );
}

Temperature _$TemperatureFromJson(Map<String, dynamic> json) {
  return Temperature(
    moy: (json['temp'] as num).toDouble(),
    min: (json['temp_min'] as num).toDouble(),
    max: (json['temp_max'] as num).toDouble(),
  );
}
