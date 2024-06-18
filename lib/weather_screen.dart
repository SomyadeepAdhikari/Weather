import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/secrets.dart';

import 'add_info_item.dart';
import 'hourly_forecast_item.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  double temp=0.0;
  @override
  void initState(){
    super.initState();
    weather = getCurrentWeather();
  }
  Future<Map<String,dynamic>> getCurrentWeather() async{
    try {
      String cityName = 'Kolkata';
      final res = await http.get(Uri.parse(
          'http://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherApiKey'
        ),
      );
      final data=jsonDecode(res.body);
      if(data['cod']!= '200'){
        throw data['message'];
      }
      return data;

    }catch(e){
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions:[
          /* GestureDetector(
            onTap: () {
              print('Refresh');
            },
              child: const Icon(Icons.refresh)
          ), */
          /* InkWell(
              onTap: () {
                print('Refresh');
              },
              child: const Icon(Icons.refresh)
          ), */
          IconButton(
            onPressed: () {
              setState(() {
                weather=getCurrentWeather();
              });
          },
          icon: const Icon(Icons.refresh)),
        ],
      ),
      body:
      FutureBuilder(
        future: weather,
        builder: (context,snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()));
          }
          final data=snapshot.data!;
          final currentWeatherData=data['list'][0];
          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky= currentWeatherData['weather'][0]['main'];
          final humidity=currentWeatherData['main']['humidity'];
          final windSpeed = currentWeatherData['wind']['speed'];
          final currentPressure=currentWeatherData['main']['pressure'];
          return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //main card
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text('$currentTemp K',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16,),
                          Icon(
                            currentSky == 'Clouds' || currentSky == 'Rain'?Icons.cloud: Icons.sunny,
                            size: 64,
                          ),
                          const SizedBox(height: 16,),
                          Text(currentSky,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                )
              ),
              const SizedBox(height: 20,),
              //weather forecast cards
              const Text('Weather Forecast', style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              /*const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    HourlyForecastItem(time: '00:00',icon: Icons.cloud,tempertaure: '301.44'),
                    HourlyForecastItem(time: '01:00',icon: Icons.sunny,tempertaure: '312.44'),
                    HourlyForecastItem(time: '02:00',icon: Icons.cloud,tempertaure: '301.44'),
                    HourlyForecastItem(time: '03:00',icon: Icons.sunny,tempertaure: '312.44'),
                    HourlyForecastItem(time: '04:00',icon: Icons.cloud,tempertaure: '306.44'),
                  ],
                ),
              ),*/
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context,index){
                    final hourlyForecast=data['list'][index+1];
                    final time=DateTime.parse(hourlyForecast['dt_txt']);
                    return HourlyForecastItem(
                        time: DateFormat.Hm().format(time),
                        tempertaure: hourlyForecast['main']['temp'].toString(),
                        icon: hourlyForecast['weather'][0]['main'] == 'Clouds' || hourlyForecast['weather'][0]['main'] == 'Rain'?Icons.cloud: Icons.sunny
                    );
                }),
              ),
              const SizedBox(height: 20,),
              //weather forecast cards
              const Text('Additional Information', style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditionalInfoItem(icon: Icons.water_drop,label: 'Humidity',value: humidity.toString(),),
                  AdditionalInfoItem(icon: Icons.air,label: 'Wind Speed',value: windSpeed.toString(),),
                  AdditionalInfoItem(icon: Icons.beach_access,label: 'Pressure',value: currentPressure.toString(),)
                ],
              )
            ],
          ),
        );
        },
      )
    );
  }
}


