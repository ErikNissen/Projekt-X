import 'package:flutter/material.dart';
import 'crypto.dart' as crypto;
import 'firebase.dart' as firebase;
import 'package:firebase_core/firebase_core.dart';

List _pwd = [];
bool _UC = true;
bool _LC = true;
bool _num = true;
bool _sym = true;
bool _erwASCII = false;
bool darkmode = false;
bool _offlinemode = false;
double _pwlen = 8;

Future<void> main() async {
  runApp(
    MaterialApp(
      title: "Flutter ProjektX",
      initialRoute: '/',
      routes: {
        '/': (context) => firebase.LoginPage(),
        '/register': (context) => firebase.RegisterPage(),
        '/forgot': (context) => firebase.ForgotPassword(),
        '/second': (context) => const SecondScreen(),
        '/third': (context) => const ThirdScreen(),
        '/settings': (context) => const Settings(),
      },
    )
  );
  await Firebase.initializeApp();
}

/*****************************************************************
 *
 *                       Page 1
 *                      Anmeldung
 *
 ****************************************************************** */

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _homescreen createState() => _homescreen();

}

class _homescreen extends State<HomeScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkmode?Colors.black:Colors.white,
      appBar: AppBar(
        title: Text(
          'Home Screen',
          style: TextStyle(
            color: !darkmode?Colors.black:Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.grey),
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/second');
          },
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Goto Second Screen",
                  style: TextStyle(
                    color: !darkmode?Colors.black:Colors.white,
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/third');
                  },
                  child: Text(
                    'Goto Third Screen',
                    style: TextStyle(
                      color: !darkmode?Colors.black:Colors.white,
                    ),
                  ),
                )
              ]
          ),
        ),
      ),
    );
  }
}

/*****************************************************************
*
*                       Page 2
 *                   Random PW GEN
*
****************************************************************** */

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  _secondscreen createState() => _secondscreen();

}

class _secondscreen extends State<SecondScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: darkmode?Colors.black:Colors.white,
        appBar: AppBar(
          title: Text(
            "Passwort Generator",
            style: TextStyle(
              color: !darkmode?Colors.black:Colors.white,
            ),
          ),
          actions: [
            Center(
              child: IconButton(
                icon: const Icon(Icons.table_chart),
                onPressed: (){
                  Navigator.pushNamed(context, '/third');
                },
              ),
            ),
            Center(
              child: IconButton(
                icon: const Icon(Icons.settings),
                onPressed: (){
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              pwlenSlider(),
              pwOptions(),
              GenPwd()
            ],
          ),
        )
    );
  }
}

class pwlenSlider extends StatefulWidget{
  const pwlenSlider({Key? key}) : super(key: key);

  @override
  _pwlenSlider createState() => _pwlenSlider();
}

class _pwlenSlider extends State<pwlenSlider> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
                "Länge: ${_pwlen.round()}",
              style: TextStyle(
                color: !darkmode?Colors.black:Colors.white,
              ),
            ),
            Slider(
              value: _pwlen,
              min: 8,
              max: 512,
              divisions: 512-8,
              label: _pwlen.toString(),
              onChanged: (double value){
                setState(() {
                  _pwlen = value;
                });
              },
            )
          ],
        ),

      ],
    );
  }
}

class pwOptions extends StatefulWidget{
  const pwOptions({Key? key}) : super(key: key);

  @override
  _pwOptions createState() => _pwOptions();
}

class _pwOptions extends State<pwOptions> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Row(
              children: [
                Switch(
                  value: _UC,
                  onChanged: (value) {
                    setState(() {
                      _UC = value;
                    });
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
                Tooltip(
                  message: 'Alle Großbuchstaben des Alphabets (ohne Umlaute).',
                  child: Text(
                      "Großbuchstaben",
                    style: TextStyle(
                      color: !darkmode?Colors.black:Colors.white,
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: const LinearGradient(colors: <Color>[Colors.blue, Colors.lightBlue]),
                  ),
                  height: 20,
                  padding: const EdgeInsets.all(8),
                  preferBelow: false,
                  textStyle: const TextStyle(
                    fontSize: 12,
                  ),
                  showDuration: const Duration(seconds: 2),
                  waitDuration: const Duration(seconds: 1),
                )
              ],
            ),
            Row(
              children: [
                Switch(
                  value: _num,
                  onChanged: (value) {
                    setState(() {
                      _num = value;
                    });
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
                Tooltip(
                  message: 'Zahlen von 0-9.',
                  child: Text(
                      "Zahlen",
                    style: TextStyle(
                      color: !darkmode?Colors.black:Colors.white,
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: const LinearGradient(colors: <Color>[Colors.blue, Colors.lightBlue]),
                  ),
                  height: 20,
                  padding: const EdgeInsets.all(8),
                  preferBelow: false,
                  textStyle: const TextStyle(
                    fontSize: 12,
                  ),
                  showDuration: const Duration(seconds: 2),
                  waitDuration: const Duration(seconds: 1),
                )
              ],
            )
          ],
        ),
        Row(
          children: [
            Row(
              children: [
                Switch(
                  value: _sym,
                  onChanged: (value) {
                    setState(() {
                      _sym = value;
                    });
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
                Tooltip(
                  message: """!\\"§\$%&/()=?*'<>;,:.-_+#~@{[]}´`|°^""",
                  child: Text(
                      "Symbole",
                    style: TextStyle(
                      color: !darkmode?Colors.black:Colors.white,
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: const LinearGradient(colors: <Color>[Colors.blue, Colors.lightBlue]),
                  ),
                  height: 20,
                  padding: const EdgeInsets.all(8),
                  preferBelow: false,
                  textStyle: const TextStyle(
                    fontSize: 12,
                  ),
                  showDuration: const Duration(seconds: 2),
                  waitDuration: const Duration(seconds: 1),
                )
              ],
            ),
            Row(
              children: [
                Switch(
                  value: _LC,
                  onChanged: (value) {
                    setState(() {
                      _LC = value;
                    });
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
                Tooltip(
                  message: 'Alle Kleinbuchstaben des Alphabets (ohne Umlaute).',
                  child: Text(
                      "Kleinbuchstaben",
                    style: TextStyle(
                      color: !darkmode?Colors.black:Colors.white,
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: const LinearGradient(colors: <Color>[Colors.blue, Colors.lightBlue]),
                  ),
                  height: 20,
                  padding: const EdgeInsets.all(8),
                  preferBelow: false,
                  textStyle: const TextStyle(
                    fontSize: 12,
                  ),
                  showDuration: const Duration(seconds: 2),
                  waitDuration: const Duration(seconds: 1),
                )
              ],
            ),
          ],
        ),
        Row(
          children: [
            Switch(
              value: _erwASCII,
              onChanged: (value) {
                setState(() {
                  _erwASCII = value;
                });
              },
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
            ),
            Tooltip(
              message: '€‚ƒ„…†‡ˆ‰Š‹ŒŽ‘’“”•–—\n˜™š›œžŸ¡¢£¤¥¦§¨©ª«¬®\n¯±²³µ¶·¸¹º»¼½¾¿ÀÁÂÃÄ\nÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×Ø\nÙÚÛÜÝÞßàáâãäåæçèéêëì\níîïðñòóôõö÷øùúûüýþÿ',
              child: Text(
                  "Erw. ASCII",
                style: TextStyle(
                  color: !darkmode?Colors.black:Colors.white,
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: const LinearGradient(colors: <Color>[Colors.blue, Colors.lightBlue]),
              ),
              height: 20,
              padding: const EdgeInsets.all(8),
              preferBelow: false,
              textStyle: const TextStyle(
                fontSize: 12,
              ),
              showDuration: const Duration(seconds: 2),
              waitDuration: const Duration(seconds: 1),
            )
          ],
        )
      ],
    );
  }
}

class GenPwd extends StatefulWidget{
  const GenPwd({Key? key}) : super(key: key);

  @override
  _pwgen createState() => _pwgen();
}

class _pwgen extends State<GenPwd> {
  bool _isLoading = false;

  void _Loading() async {
    setState(() {
      _isLoading = !_isLoading;
    });
  }
  updatepwd(){
    pwd = _pwd[0];
  }
  String pwd = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isLoading? const CircularProgressIndicator() : TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () async {
                _Loading();
                _pwd = await crypto.Gen_Password([_UC, _LC, _num, _sym, _erwASCII], _pwlen);
                setState(() {
                  updatepwd();
                });
                _Loading();
              },
              child: const Text("Generiere Passwort"),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: (){
                setState(() {
                  //TODO: Speicher Passwort in der DB
                });
              },
              child: const Text("Speichern"),
            )
          ],
        ),
        SizedBox(
          width: 150,
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(
                    pwd,
                    overflow: TextOverflow.clip,
                    softWrap: true,
                    style: TextStyle(
                      color: darkmode?Colors.white:Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          )
        )
      ],
    );
  }
}

class UpdateText extends StatefulWidget {
  const UpdateText({Key? key}) : super(key: key);


  UpdateTextState createState() => UpdateTextState();

}

class UpdateTextState extends State<UpdateText> {
  String _textHolder = "";

  changeText() {

    setState(() {
      _textHolder = _pwd[0];
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Text(_textHolder,
                      style: TextStyle(
                          fontSize: 21,
                          backgroundColor: !darkmode?Colors.black:Colors.white,
                      )
                  )
              ),
            ]
          )
        )
    );
  }
}

/*****************************************************************
 *
 *                       Page 3
 *      ListView mit Generierten & gespeicherten PW
 *
 ****************************************************************** */

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({Key? key}) : super(key: key);

  @override
  _thirdscreen createState() => _thirdscreen();
}
class _thirdscreen extends State<ThirdScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: darkmode?Colors.black:Colors.white,
        appBar: AppBar(
          title: const Text('Third Screen'),
        ),
        body: _buildList()
    );
  }
}

Widget _buildList() => ListView(
    children: [
      _tile('CineArts at the Empire', '85 W Portal Ave', Icons.theaters),
      _tile('The Castro Theater', '429 Castro St', Icons.theaters),
      _tile('Alamo Drafthouse Cinema', '2550 Mission St', Icons.theaters),
      _tile('Roxie Theater', '3117 16th St', Icons.theaters),
      _tile('United Artists Stonestown Twin', '501 Buckingham Way', Icons.theaters),
      _tile('AMC Metreon 16', '135 4th St #3000', Icons.theaters),
      Divider(),
      _tile('K\'s Kitchen', '757 Monterey Blvd', Icons.restaurant),
      _tile('Emmy\'s Restaurant', '1923 Ocean Ave', Icons.restaurant),
      _tile('Chaiya Thai Restaurant', '272 Claremont Blvd', Icons.restaurant),
      _tile('La Ciccia', '291 30th St', Icons.restaurant),
      _tile('The Big Yummy', '123 54th St', Icons.restaurant),
      _tile('Tasty Hack', '651 Clark Ave', Icons.restaurant),
    ]);

ListTile _tile(String title, String subtitle, IconData icon) => ListTile(
  title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: !darkmode?Colors.black:Colors.white)),
  subtitle: Text(subtitle, style: TextStyle(color: !darkmode?Colors.black:Colors.white)),
  leading: Icon(icon, color: Colors.blue[500]),
);


/*
*
*                   Page "Settings"
*
*
* */
class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _Settings createState() => _Settings();
}

class _Settings extends State<Settings>{
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
          backgroundColor: darkmode?Colors.black:Colors.white,
        appBar: AppBar(
          title: const Text("Einstellungen"),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Offline Datenbank",
                  style: TextStyle(
                    color: !darkmode?Colors.black:Colors.white,
                  ),
                ),
                Switch(
                    value: _offlinemode,
                    onChanged: (value){
                      setState(() {
                        _offlinemode = value;
                      });
                    }
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                    "Darkmode",
                  style: TextStyle(
                    color: !darkmode?Colors.black:Colors.white,
                  ),
                ),
                Switch(
                    value: darkmode,
                    onChanged: (value){
                      setState(() {
                        darkmode = value;
                      });
                    }
                ),
              ],
            ),
            /*Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("C"),
                Switch(
                    value: true,
                    onChanged: null
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("D"),
                Switch(
                    value: true,
                    onChanged: null
                ),
              ],
            ),*/
          ],
        )
      ),
    );
  }

}



/****
 *
 * BLAH
 *
 **** */


