import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:meteo_sncf/weather/weather.dart';

abstract class WeathersState extends Equatable {
  @override
  List<Object> get props => [];
}

class WeathersStateInitialState extends WeathersState {}

class WeathersStateLoadingState extends WeathersState {}

class WeathersStateErrorState extends WeathersState {}

class WeathersStateLoadedState extends WeathersState {
  WeathersStateLoadedState(this.weathers);
  final List<Weather> weathers;

  @override
  List<Object> get props => [weathers];
}

class WeathersCubit extends Cubit<WeathersState> {
  WeathersCubit() : super(WeathersStateInitialState());

  final weatherService = GetIt.instance.get<WeatherService>();

  String? getIconUrl(Weather weather) => weatherService
      .buildIconUrl(
        weather.details.first.icon,
      )
      .toString();

  void getWeathers() async {
    try {
      emit(WeathersStateLoadingState());
      final weathers = await weatherService.fetchWeather();
      if (weathers == null || weathers.isEmpty) {
        emit(WeathersStateErrorState());
      } else {
        emit(WeathersStateLoadedState(weathers));
      }
    } catch (e) {
      emit(WeathersStateErrorState());
    }
  }
}
