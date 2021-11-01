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
    String _verSym = "";
    String _sym = """
    ABCDEFGHIJKLMNOPQRSTUVWXYZ
    abcdefghijklmnopqrstuvwxyz
    0123456789
    !\\"§\$%&/()=?*'<>;,:.-_+#~@{[]}´`|°^
    €‚ƒ„…†‡ˆ‰Š‹ŒŽ‘’“”•–—˜™š›œžŸ¡¢£¤¥¦§¨©ª«¬®¯±²³µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ
    """.replaceAll("\n", "").replaceAll(" ", "");
    final String _erlSym = _sym.replaceAll(_verSym, "");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Passwort Generator"),
      ),
      body: Column(
        children: [
          pwlenSlider(),
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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(_pw),
        IconButton(
          icon: Icon(Icons.copy),
          onPressed: () {
            setState(() async {
              _pw = await crypto.Gen_Password(crypto.data());
            });
            Clipboard.setData(
              ClipboardData(text: _pw)
            );
          },
        )
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
    return Row(
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


