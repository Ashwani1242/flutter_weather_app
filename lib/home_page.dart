import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/forecast_card.dart';
import 'package:weather_app/info_card.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'Lucknow';

      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherApiKey',
        ),
      );

      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'An unexpexted Error Occured';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather = getCurrentWeather();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final data = snapshot.data!;

          final currentTemperature = (data['list'][0]['main']['temp']) - 273.15;
          final currentWeather = (data['list'][0]['weather'][0]['main']);
          final humidity = (data['list'][0]['main']['humidity']);
          final windSpeed = (data['list'][0]['wind']['speed']);
          final pressure = (data['list'][0]['main']['pressure']);
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main Card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '${currentTemperature.toStringAsFixed(1)}°C',
                                style: const TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              Icon(
                                currentWeather == 'Clear'
                                    ? Icons.wb_sunny
                                    : currentWeather == 'Rain'
                                        ? Icons.cloudy_snowing
                                        : Icons.cloud,
                                size: 70,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                currentWeather,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Spacing
                const SizedBox(
                  height: 25,
                ),
                //Weather Forecast Text
                const Text(
                  'Weather Forecast',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                //Spacing
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      final weatherForecast = data['list'][index + 1];
                      final time = DateTime.parse(weatherForecast['dt_txt']);
                      return Forecastcard(
                        time: DateFormat.j().format(time),
                        icon: (weatherForecast['weather'][0]['main']) == 'Clear'
                            ? Icons.wb_sunny
                            : (weatherForecast['weather'][0]['main']) == 'Rain'
                                ? Icons.cloudy_snowing
                                : Icons.cloud,
                        temperature:
                            (((weatherForecast['main']['temp']) - 273.15)
                                    .toStringAsFixed(0) +
                                '°C'),
                      );
                    },
                  ),
                ),
                //Spacing
                const SizedBox(
                  height: 25,
                ),
                //Additional Information Text
                const Text(
                  'Additional Information',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                //Spacing
                const SizedBox(
                  height: 5,
                ),
                //Additional Information
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InfoCards(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: '$humidity',
                    ),
                    InfoCards(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: '$windSpeed',
                    ),
                    InfoCards(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: '$pressure',
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
