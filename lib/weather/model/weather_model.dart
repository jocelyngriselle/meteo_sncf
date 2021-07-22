import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
part 'weather_model.g.dart';

@JsonSerializable(createToJson: false)
class Weather {
  Weather({
    required this.details,
    required this.temperature,
    required this.date,
  });

  factory Weather.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$WeatherFromJson(
        json,
      );

  @JsonKey(name: 'weather')
  final List<WeatherDetails> details;
  @JsonKey(name: 'main')
  final Temperature temperature;
  @JsonKey(
    name: 'dt_txt',
  )
  final DateTime date;

  String get dateToString => _formatterDate.format(date);
  String get timeToString => _formattertime.format(date);
  static final _formatterDate = DateFormat('EEEE dd MMMM yyyy');
  static final _formattertime = DateFormat('k:mm');
}

@JsonSerializable(createToJson: false)
class WeatherDetails {
  WeatherDetails({
    required this.description,
    required this.icon,
  });

  factory WeatherDetails.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$WeatherDetailsFromJson(
        json,
      );

  final String description;
  final String icon;
}

@JsonSerializable(createToJson: false)
class Temperature {
  Temperature({
    required this.moy,
    required this.min,
    required this.max,
  });

  factory Temperature.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$TemperatureFromJson(
        json,
      );

  @JsonKey(name: 'temp')
  final double moy;
  @JsonKey(name: 'temp_min')
  final double min;
  @JsonKey(name: 'temp_max')
  final double max;
}
