class Weather {
  dynamic name;

  dynamic id, timezone, dt;

  MainWeather getmainWeather;
  WeatherDesc weatherDesc;

  Weather(
      {required this.id,
      required this.dt,
      required this.name,
      required this.timezone,
      required this.getmainWeather,
      required this.weatherDesc});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      id: json['id'],
      dt: json['dt'],
      name: json['name'],
      timezone: json['timezone'],
      getmainWeather: MainWeather.fromJson(json['main']),
      weatherDesc: WeatherDesc.fromJson(json['weather'][0]),
    );
  }
}

class MainWeather {
  dynamic temp, feels_like, temp_min, temp_max;
  dynamic pressure, humidity;

  MainWeather({
    required this.temp,
    required this.feels_like,
    required this.temp_min,
    required this.temp_max,
    required this.pressure,
    required this.humidity,
  });

  factory MainWeather.fromJson(Map<String, dynamic> json) {
    return MainWeather(
      temp: json['temp'],
      feels_like: json['feels_like'],
      temp_min: json['temp_min'],
      temp_max: json['temp_max'],
      pressure: json['pressure'],
      humidity: json['humidity'],
    );
  }
}

class WeatherDesc {
  String main, description, icon;
  int id;

  WeatherDesc({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory WeatherDesc.fromJson(Map<String, dynamic> json) {
    return WeatherDesc(
      id: json['id'],
      main: json['main'],
      description: json['description'],
      icon: json['icon'],
    );
  }
}
