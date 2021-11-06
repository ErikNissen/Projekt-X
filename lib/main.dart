import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'crypto.dart' as crypto;

void main() {
  runApp(
    MaterialApp(
      title: "Flutter ProjektX",
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/second': (context) => const SecondScreen(),
        '/third': (context) => const ThirdScreen(),
      },
    )
  );
}

/*****************************************************************
 *
 *                       Page 1
 *                      Anmeldung
 *
 ****************************************************************** */

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.grey),
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/second');
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text("Goto Second Screen"),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/third');
                },
                child: const Text('Goto Third Screen'),
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

class SecondScreen extends StatelessWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Passwort Generator"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              pwlenSlider(),

            ],
          ),
          pwOptions()
        ],
      ),
    );
  }
}

class PWText extends StatefulWidget {
  @override
  _PWText createState() => _PWText();
}

class _PWText extends State<PWText> {
  String _pw = "";
  String _verSym = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(_pw),
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () {
                setState(() async {
                  _pw = await crypto.Gen_Password(crypto.data(), _verSym);
                });
                Clipboard.setData(
                  ClipboardData(text: _pw)
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class pwlenSlider extends StatefulWidget{
  @override
  _pwlenSlider createState() => _pwlenSlider();
}

class _pwlenSlider extends State<pwlenSlider> {
  double _pwlen = 8;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text("Länge: ${_pwlen.round()}"),
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
  @override
  _pwOptions createState() => _pwOptions();
}

class _pwOptions extends State<pwOptions> {
  bool UC = true;
  bool LC = true;
  bool num = true;
  bool sym = true;
  bool erwASCII = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Switch(
              value: UC,
              onChanged: (value) {
                setState(() {
                  UC = value;
                });
              },
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
            ),
            const Text("Großbuchstaben")
          ],
        ),
        Row(
          children: [
            Switch(
              value: LC,
              onChanged: (value) {
                setState(() {
                  LC = value;
                });
              },
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
            ),
            const Text("Kleinbuchstaben")
          ],
        ),
        Row(
          children: [
            Switch(
              value: num,
              onChanged: (value) {
                setState(() {
                  num = value;
                });
              },
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
            ),
            const Text("Zahlen")
          ],
        ),
        Row(
          children: [
            Switch(
              value: sym,
              onChanged: (value) {
                setState(() {
                  sym = value;
                });
              },
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
            ),
            const Text("Symbole")
          ],
        ),
        Row(
          children: [
            Switch(
              value: erwASCII,
              onChanged: (value) {
                setState(() {
                  erwASCII = value;
                });
              },
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
            ),
            const Text("Erw. ASCII")
          ],
        )
      ],
    );
  }
}

/*****************************************************************
 *
 *                       Page 3
 *      ListView mit Generierten & gespeicherten PW
 *
 ****************************************************************** */

class ThirdScreen extends StatelessWidget {
  const ThirdScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return Scaffold(
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
  title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
  subtitle: Text(subtitle),
  leading: Icon(icon, color: Colors.blue[500]),
);



/****
 *
 * BLAH
 *
 **** */


