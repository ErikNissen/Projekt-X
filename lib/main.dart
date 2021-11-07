import 'package:flutter/material.dart';
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
          pwlenSlider(),
          pwOptions(),
          GenPwd()
        ],
      ),
    );
  }
}

class Variables {
  String pwd = "";
  bool UC = true;
  bool LC = true;
  bool num = true;
  bool sym = true;
  bool erwASCII = false;
  double pwlen = 8;
}

class pwlenSlider extends StatefulWidget{
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
            Text("Länge: ${Variables().pwlen.round()}"),
            Slider(
              value: Variables().pwlen,
              min: 8,
              max: 512,
              divisions: 512-8,
              label: Variables().pwlen.toString(),
              onChanged: (double value){
                setState(() {
                  Variables().pwlen = value;
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Switch(
              value: Variables().UC,
              onChanged: (value) {
                setState(() {
                  Variables().UC = value;
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
              value: Variables().LC,
              onChanged: (value) {
                setState(() {
                  Variables().LC = value;
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
              value: Variables().num,
              onChanged: (value) {
                setState(() {
                  Variables().num = value;
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
              value: Variables().sym,
              onChanged: (value) {
                setState(() {
                  Variables().sym = value;
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
              value: Variables().erwASCII,
              onChanged: (value) {
                setState(() {
                  Variables().erwASCII = value;
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

class GenPwd extends StatefulWidget{
  @override
  _pwgen createState() => _pwgen();
}

class _pwgen extends State<GenPwd> {
  updatepwd(){
    pwd = Variables().pwd;
  }
  String pwd = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
          onPressed: () async {
            Variables().pwd = crypto.Gen_Password([Variables().UC, Variables().LC, Variables().num, Variables().sym, Variables().erwASCII], Variables().pwlen);
            setState(() {
              updatepwd();
            });
          },
          child: const Text("Generiere Passwort"),
        ),
        SizedBox(
          width: 200,
          child: Text(
            pwd,
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        )
      ],
    );
  }
}

class UpdateText extends StatefulWidget {

  UpdateTextState createState() => UpdateTextState();

}

class UpdateTextState extends State {

  String textHolder = "";

  changeText() {

    setState(() {
      textHolder = Variables().pwd;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: Column(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Text('$textHolder',
                      style: TextStyle(fontSize: 21))),
            ]))
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


