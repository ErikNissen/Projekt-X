import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:light/light.dart';
import 'package:http/http.dart' as http;
import 'package:environment_sensors/environment_sensors.dart';

Uri Qrand(int length){
  assert(length <= 1024 && length >= 1);

  return Uri(
      path: "https://qrng.anu.edu.au/API/jsonI.php?length=$length&type=uint8",
      queryParameters: {
        'Accept': 'application/json'
      }
  );
}

Future<Map<String, dynamic>> data() async{
  late double? direction;
  final envSen = EnvironmentSensors();
  late double? temp;
  int? lightlvl;

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

  return {
    'temperature': temp ?? 0.00,
    'light_lvl': lightlvl ?? 0.00
  };
}

Future<String> Gen_Password(Future<Map<String, dynamic>> Data, String verbotene_symbole) async {
  var data = await Data;
  assert(data.isNotEmpty);
  assert(data.containsKey("temperature"));
  assert(data.containsKey("light_lvl"));
  assert(data["light_lvl"].runtimeType == double);
  assert(data["temperature"].runtimeType == double);
  
  int temperature = double.parse(data["temperature"]).round();
  int light_lvl = double.parse(data["light_lvl"]).round();
  data = {
    'temperature': int.parse(temperature.toString(), radix: 2).toString(),
    'light_lvl': int.parse(light_lvl.toString(), radix: 2).toString()
  };
  while(data['temperature'].length < 21){
    data['temperature'] = "${data['temperature']}${Random().nextBool()=='true'?1:0}";
  }
  while(data['light_lvl'].length < 21){
    data['light_lvl'] = "${data['light_lvl']}${Random().nextBool()=='true'?1:0}";
  }

  var _symL = """
    ABCDEFGHIJKLMNOPQRSTUVWXYZ
    abcdefghijklmnopqrstuvwxyz
    0123456789
    !\\"§\$%&/()=?*'<>;,:.-_+#~@{[]}´`|°^
    €‚ƒ„…†‡ˆ‰Š‹ŒŽ‘’“”•–—˜™š›œžŸ¡¢£¤¥¦§¨©ª«¬®¯±²³µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ
    ${data['temperature'].toString()}${data['light_lvl'].toString()}
    """.replaceAll("\n", "").replaceAll(" ", "").split("");
  _symL.shuffle();
  String _sym = _symL.join("");
  String _erlSym = _sym.replaceAll(verbotene_symbole, "");

  while(_erlSym.length <= 255){
    _erlSym = "$_erlSym${_erlSym.split("")[Random().nextInt(_erlSym.length + 1)]}";
  }

  var _qrand = await http.get(Qrand(255));
  final Map _qrandD = json.decode(_qrand.body);
  var _numbers = _qrandD["data"];

  String _pwd = "";

  for(var _num in _numbers){
    _pwd = "$_pwd${_erlSym.split("")[_num]}";
  }

  return _pwd;
}