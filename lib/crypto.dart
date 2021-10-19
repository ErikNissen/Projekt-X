import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:light/light.dart';
import 'package:http/http.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:environment_sensors/environment_sensors.dart';

Uri Qrand(Map<String, int> param){
  assert(param.isNotEmpty);
  assert(param.containsKey("length"));
  assert(param.containsKey("size"));
  assert(param["length"]! <= 1024 && param["length"]! >= 1);
  assert(param["size"]! <= 1024 && param["size"]! >= 1);

  return Uri(
    path: "https://qrng.anu.edu.au/API/jsonI.php?length=${param["length"]}&type=hex16?size=${param["size"]}",
    queryParameters: {
      'Accept': 'application/json'
    }
  );
}

Future<Map<String, dynamic>> data() async{
  late Light _light;
  late double? direction;
  final envSen = EnvironmentSensors();

  late double? temp;
  
  //Get Sensor Infos
  if(await envSen.getSensorAvailable(SensorType.AmbientTemperature)){
    envSen.temperature.listen((temperature) {
      temp = temperature;
    });
  }

  return {'':''};
}

void main() async {
}