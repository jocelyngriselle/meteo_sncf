import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:meteo_sncf/weather/weather.dart';
import 'package:mocktail/mocktail.dart';

class MockWeatherService extends Mock implements WeatherService {}

void main() {
  group('WeatherCubit', () {
    late WeatherService weatherService;
    const weathersJson = [
      {
        'dt': 1596564000,
        'main': {
          'temp': 293.55,
          'feels_like': 293.13,
          'temp_min': 293.55,
          'temp_max': 294.05,
          'pressure': 1013,
          'sea_level': 1013,
          'grnd_level': 976,
          'humidity': 84,
          'temp_kf': -0.5
        },
        'weather': [
          {
            'id': 500,
            'main': 'Rain',
            'description': 'light rain',
            'icon': '10d',
          }
        ],
        'clouds': {'all': 38},
        'wind': {'speed': 4.35, 'deg': 309, 'gust': 7.87},
        'visibility': 10000,
        'pop': 0.49,
        'rain': {'3h': 0.53},
        'sys': {'pod': 'd'},
        'dt_txt': '2020-08-04 18:00:00'
      }
    ];
    final weathers = weathersJson.map((e) => Weather.fromJson(e)).toList();

    setUpAll(() {
      weatherService = MockWeatherService();
      GetIt.I.registerSingleton<WeatherService>(
        weatherService,
      );
      when(() => weatherService.fetchWeather()).thenAnswer(
        (_) => Future.value(weathers),
      );
    });
    test('initial state is empty', () {
      expect(WeathersCubit().state, equals(WeathersStateInitialState()));
    });

    blocTest<WeathersCubit, WeathersState>(
      'emits weathers when getWeathers is called',
      build: () => WeathersCubit(),
      act: (cubit) => cubit.getWeathers(),
      expect: () => [
        WeathersStateLoadingState(),
        WeathersStateLoadedState(weathers),
      ],
    );
  });
}
