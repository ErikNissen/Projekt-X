import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:light/light.dart';
import 'package:http/http.dart' as http;
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
  late double? direction;
  final envSen = EnvironmentSensors();
  late double? temp;
  var helper = RsaKeyHelper();
  int? lightlvl;

  var rsaKey = await helper.computeRSAKeyPair(helper.getSecureRandom());

  //Get Sensor Infos
  if(await envSen.getSensorAvailable(SensorType.AmbientTemperature)){
    envSen.temperature.listen((temperature) {
      temp = temperature;
    });
  }
  var _light = new Light();
  try{
    var _sub = _light.lightSensorStream.listen((val){lightlvl = val;});
  } on LightException catch (exp){
    print(exp);
  }

  return {'rsa_key':rsaKey.privateKey.toString(),
    'temperature': temp ?? 0.00,
    'light_lvl': lightlvl ?? 0.00};
}

Future<String> Gen_Password(Future<Map<String, dynamic>> Data, String sym) async {
  var data = await Data;
  assert(data.isNotEmpty);
  assert(data.containsKey("rsa_key"));
  assert(data.containsKey("temperature"));
  assert(data.containsKey("light_lvl"));
  assert(data["light_lvl"].runtimeType == double);
  assert(data["temperature"].runtimeType == double);
  assert(data["rsa_key"].runtimeType == String);

  var rsa_key = data["rsa_key"];
  int temperature = double.parse(data["temperature"]).round();
  int light_lvl = double.parse(data["light_lvl"]).round();

  data = {
    'rsa': rsa_key.toString().split(""),
    'temperature': int.parse(temperature.toString(), radix: 2),
    'light_lvl': int.parse(light_lvl.toString(), radix: 2)
  };

  var qrand = await http.get(Qrand({'size': 1, 'length': data['rsa'].length}));
  data.addAll({'Qrand': qrand});





  return Password.join("");
}