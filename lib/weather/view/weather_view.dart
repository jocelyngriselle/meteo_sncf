import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:meteo_sncf/authentication/authentication.dart';
import 'package:meteo_sncf/weather/cubit/weather_cubit.dart';
import 'package:meteo_sncf/weather/weather.dart';

class WeatherListPage extends StatelessWidget {
  const WeatherListPage({Key? key}) : super(key: key);
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const WeatherListPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WeathersCubit>(
      create: (_) => WeathersCubit()..getWeathers(),
      child: const WeatherListView(),
    );
  }
}

class WeatherListView extends StatelessWidget {
  const WeatherListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeathersCubit, WeathersState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: context.select(
              (AuthenticationBloc bloc) => Text(
                'Welcome ${bloc.state.user.username ?? ''}',
              ),
            ),
            automaticallyImplyLeading: false,
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () async {
                    context.read<AuthenticationBloc>().add(
                          AuthenticationLogoutRequested(),
                        );
                  },
                  child: const Icon(
                    Icons.power_settings_new,
                  ),
                ),
              )
            ],
          ),
          body: SafeArea(
            child: _buildContent(context, state),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, WeathersState state) {
    if (state is WeathersStateLoadingState) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is WeathersStateErrorState) {
      return const Center(
        child: Icon(Icons.close),
      );
    } else if (state is WeathersStateLoadedState) {
      final weathers = state.weathers;

      return GroupedListView<Weather, DateTime>(
        elements: weathers,
        groupBy: (element) => DateTime(
          element.date.year,
          element.date.month,
          element.date.day,
        ),
        groupSeparatorBuilder: (DateTime date) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              child: Text(
                DateFormat('EEEE dd MMMM yyyy').format(date),
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
            ),
            Divider(
              color: Colors.black.withOpacity(0.5),
            ),
          ],
        ),
        itemBuilder: (context, Weather element) => _WeatherListItem(
          weather: element,
        ),
        itemComparator: (Weather item1, Weather item2) => item1.date.compareTo(
          item2.date,
        ),
      );
    } else {
      return Container();
    }
  }
}

class _WeatherListItem extends StatelessWidget {
  const _WeatherListItem({
    Key? key,
    required this.weather,
  }) : super(key: key);

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    final iconUrl = context.read<WeathersCubit>().getIconUrl(weather);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: RichText(
        text: TextSpan(
          children: [
            const WidgetSpan(
              child: Icon(
                Icons.access_time,
                size: 18.0,
              ),
            ),
            TextSpan(
              text: weather.timeToString,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      ),
      subtitle: Text(weather.details[0].description),
      leading: iconUrl != null
          ? CachedNetworkImage(
              imageUrl: iconUrl,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            )
          : null,
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'temp',
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: Theme.of(context).textTheme.caption!.color,
                ),
          ),
          Text(
            '${weather.temperature.moy.round()}°',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );
  }
}
