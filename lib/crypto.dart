import 'dart:convert';
import 'dart:math';
import 'package:light/light.dart';
import 'package:http/http.dart' as http;
import 'package:environment_sensors/environment_sensors.dart';

String Qrand(int length){
  assert(length <= 1024 && length >= 1);

  return "https://qrng.anu.edu.au/API/jsonI.php?length=$length&type=uint8";
}

Map data(){
  final envSen = EnvironmentSensors();
  double temp = 0.0;
  int? lightlvl;
  late bool x;
  envSen.getSensorAvailable(SensorType.AmbientTemperature).then(
      (value) {
        if(value == true){
          envSen.temperature.listen((temperature) {
            temp = temperature;
          });
        }
      }
  );
  //Get Sensor Infos
  var _light = new Light();
  try{
    var _sub = _light.lightSensorStream.listen((val){lightlvl = val;});
  } on LightException catch (exp){
    print(exp);
  }

  return {
    'temperature': temp,
    'light_lvl': lightlvl ?? 0.00
  };
}

Future<List> Gen_Password(List verbotene_symbole, double pwlen) async {
  int entropy_R = 0;
  Map Data = data();
  int temperature = Data["temperature"].round();
  int light_lvl = Data["light_lvl"].round();
  Data = {
    'temperature': int.parse(temperature.toString(), radix: 2).toString(),
    'light_lvl': int.parse(light_lvl.toString(), radix: 2).toString()
  };
  while(Data['temperature'].length < 21){
    Data['temperature'] = "${Data['temperature']}${Random().nextBool()=='true'?1:0}";
  }
  while(Data['light_lvl'].length < 21){
    Data['light_lvl'] = "${Data['light_lvl']}${Random().nextBool()=='true'?1:0}";
  }
  String versym = "";
  if(verbotene_symbole[0] == false){
    versym = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    entropy_R += versym.length;
  }
  if(verbotene_symbole[1] == false){
    versym += "abcdefghijklmnopqrstuvwxyz";
    entropy_R += versym.length;
  }
  if(verbotene_symbole[2] == false){
    versym += "0123456789";
    entropy_R += versym.length;
  }
  if(verbotene_symbole[3] == false){
    versym += """!\\"§\$%&/()=?*'<>;,:.-_+#~@{[]}´`|°^""";
    entropy_R += versym.length;
  }
  if(verbotene_symbole[4] == false){
    versym += "€‚ƒ„…†‡ˆ‰Š‹ŒŽ‘’“”•–—˜™š›œžŸ¡¢£¤¥¦§¨©ª«¬®¯±²³µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ";
    entropy_R += versym.length;
  }

  var _symL = """
    ABCDEFGHIJKLMNOPQRSTUVWXYZ
    abcdefghijklmnopqrstuvwxyz
    0123456789
    !\\"§\$%&/()=?*'<>;,:.-_+#~@{[]}´`|°^
    €‚ƒ„…†‡ˆ‰Š‹ŒŽ‘’“”•–—˜™š›œžŸ¡¢£¤¥¦§¨©ª«¬®¯±²³µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ
    """.replaceAll("\n", "").replaceAll(" ", "").split("");
  if(versym == ""){
    entropy_R = _symL.length;
  }
  String _sym = _symL.join("");
  String _erlSym = _sym;
  for(int j = 0; j < versym.length; j++){
    _erlSym = _erlSym.replaceAll(versym.split("")[j], "");
  }

    while(_erlSym.length <= 255){
      _erlSym += _erlSym.split("").join("").toString();
    }
  var _qrand = (await http.get(Uri.parse(Qrand(pwlen.toInt()>255?pwlen.toInt():255)))).body;
  final Map _qrandD = json.decode(_qrand);
  var _numbers = _qrandD["data"];

  String _pwd = "";
  if(pwlen.toInt() > _erlSym.length){
    _erlSym *= pwlen.toInt() ~/ 255;
  }
  for(var _num in _numbers){
    _pwd = "$_pwd${_erlSym.split("")[_num]}";
  }
  var entropy = log(entropy_R) * pwlen;
  return [_pwd.substring(0, pwlen.toInt()), (entropy~/1)];
}