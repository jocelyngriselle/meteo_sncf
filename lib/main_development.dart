import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'package:meteo_sncf/app/app.dart';
import 'package:meteo_sncf/app/app_bloc_observer.dart';
import 'package:meteo_sncf/weather/weather.dart';

import 'authentication/authentication.dart';

void main() {
  Bloc.observer = AppBlocObserver();
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };
  GetIt.I.registerSingleton<AuthenticationService>(
    AuthenticationService(),
  );
  GetIt.I.registerSingleton<UserRepository>(
    UserRepository(),
  );
  GetIt.I.registerSingleton<WeatherService>(
    WeatherService(),
  );
  runZonedGuarded(
    () => runApp(const App()),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
