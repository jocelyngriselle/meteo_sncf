// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:meteo_sncf/app/app.dart';
import 'package:meteo_sncf/authentication/authentication.dart';
import 'package:meteo_sncf/weather/weather.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationService extends Mock implements AuthenticationService {}

class MockUserRepository extends Mock implements UserRepository {}

class MockWeatherService extends Mock implements WeatherService {}

void main() {
  const user = User('id');
  group('App', () {
    late AuthenticationService authenticationRepository;
    late UserRepository userRepository;
    late WeatherService weatherService;

    setUpAll(() {
      authenticationRepository = MockAuthenticationService();
      GetIt.I.registerSingleton<AuthenticationService>(
        authenticationRepository,
      );

      userRepository = MockUserRepository();
      GetIt.I.registerSingleton<UserRepository>(
        userRepository,
      );
      weatherService = MockWeatherService();
      GetIt.I.registerSingleton<WeatherService>(
        weatherService,
      );
    });

    testWidgets('renders LoginPage when not authenticated', (tester) async {
      when(() => authenticationRepository.status).thenAnswer(
        (_) => Stream.value(AuthenticationStatus.unauthenticated),
      );
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('renders WeatherListPage when authenticated', (tester) async {
      when(() => authenticationRepository.status).thenAnswer(
        (_) => Stream.value(AuthenticationStatus.authenticated),
      );
      when(() => userRepository.getUser()).thenAnswer((_) async => user);
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      expect(find.byType(WeatherListPage), findsOneWidget);
    });
  });
}
