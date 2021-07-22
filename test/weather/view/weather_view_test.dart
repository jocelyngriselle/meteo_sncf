// ignore_for_file: prefer_const_constructors
// ignore_for_file: lines_longer_than_80_chars

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:meteo_sncf/authentication/authentication.dart';
import 'package:meteo_sncf/weather/cubit/weather_cubit.dart';
import 'package:meteo_sncf/weather/weather.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockWeathersCubit extends MockCubit<WeathersState> implements WeathersCubit {}

class FakeWeathersState extends Fake implements WeathersState {}

class FakeAuthenticationState extends Fake implements AuthenticationState {}

class FakeAuthenticationEvent extends Fake implements AuthenticationEvent {}

class MockAuthenticationBloc extends MockBloc<AuthenticationEvent, AuthenticationState> implements AuthenticationBloc {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  const user = User('id');
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
    },
    {
      'dt': 1596564000,
      'main': {
        'temp': 12.99,
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
          'description': 'heavy rain',
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
  group('WeathersPage', () {
    late WeathersCubit weathersCubit;
    late AuthenticationBloc authenticationBloc;
    late UserRepository userRepository;

    setUpAll(() {
      registerFallbackValue<WeathersState>(FakeWeathersState());
      registerFallbackValue<AuthenticationState>(FakeAuthenticationState());
      registerFallbackValue<AuthenticationEvent>(FakeAuthenticationEvent());

      authenticationBloc = MockAuthenticationBloc();
      userRepository = MockUserRepository();
      when(() => userRepository.getUser()).thenAnswer((_) async => user);
      GetIt.I.registerSingleton<UserRepository>(
        userRepository,
      );
      weathersCubit = MockWeathersCubit();
    });

    testWidgets('renders weathers', (tester) async {
      final weathersState = WeathersStateLoadedState(weathers);
      when(() => weathersCubit.state).thenReturn(weathersState);
      final authState = AuthenticationState.authenticated(user);
      when(() => authenticationBloc.state).thenReturn(authState);
      await tester.pumpApp(
        BlocProvider.value(
          value: weathersCubit,
          child: BlocProvider.value(
            value: authenticationBloc,
            child: WeatherListView(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(WeatherListView), findsOneWidget);
      expect(find.text('294°'), findsOneWidget);
      expect(find.text('13°'), findsOneWidget);
      expect(find.text('light rain'), findsOneWidget);
      expect(find.text('heavy rain'), findsOneWidget);
    });
  });
}
