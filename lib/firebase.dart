import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:steel_crypt/steel_crypt.dart';
import 'main.dart' as main;

final _auth = FirebaseAuth.instance;
String email = "";
String password = "";

String _encpass(String password) {
  var _fortunaKey = CryptKey().genFortuna();
  var _nonce = CryptKey().genDart(len: 12);
  var _aesEncrypter = AesCrypt(
    key: _fortunaKey,
    padding: PaddingAES.pkcs7
  );
  return _aesEncrypter.gcm.encrypt(
    inp: password,
    iv: _nonce
  );
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final logo = Padding(
      padding: const EdgeInsets.all(20),
      child: Hero(
          tag: 'hero',
          child: CircleAvatar(
            radius: 56.0,
            child: Image.network('https://www.pngkit.com/png/full/301-3012694_account-user-profile-avatar-comments-fa-user-circle.png'),
          )
      ),
    );
    final inputEmail = Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            hintText: 'Email',
            contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0)
            )
        ),
        onChanged: (value){
          email = value;
        },
      ),
    );
    final inputPassword = Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Passwort',
            contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0)
            )
        ),
        onChanged: (value) async {
          password = _encpass(value);
        },
      ),
    );
    final buttonLogin = Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: ButtonTheme(
        height: 56,
        child: RaisedButton(
          child: const Text('Login', style: TextStyle(color: Colors.white, fontSize: 20)),
          color: Colors.black87,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50)
          ),
          onPressed: () async {
            try {
              await _auth.signInWithEmailAndPassword(
                email: email,
                password: password
              );
              Navigator.pushNamed(context, '/second');
            } on FirebaseAuthException catch (e){
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Login fehlgeschlagen."),
                  content: Text('${e.message}'),
                )
              );
            }
          },
        ),
      ),
    );
    const buttonForgotPassword = FlatButton(
        child: Text('Passwort vergessen', style: TextStyle(color: Colors.grey, fontSize: 16),),
        onPressed: null
    );
    return SafeArea(
        child: Scaffold(
          body: Center(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: <Widget>[
                logo,
                inputEmail,
                inputPassword,
                buttonLogin,
                TextButton(
                  child: const Text("Registrieren"),
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                ),
                buttonForgotPassword
              ],
            ),
          ),
        )
    );
  }
}



class RegisterPage extends StatefulWidget{
  @override
  _RegisterPageState createState() => _RegisterPageState();
}
class _RegisterPageState extends State<RegisterPage>{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              const Text("Registrieren"),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value){
                  email = value.toString().trim();
                },
                textAlign: TextAlign.center,
              ),
              TextFormField(
                obscureText: true,
                validator: (value){
                  if(value!.isEmpty){
                    return "Bitte ein Passwort vergeben.";
                  }
                },
                onChanged: (value) {
                  password = _encpass(value);
                },
                textAlign: TextAlign.center,
              ),
              TextButton(
                child: const Text("Registrieren"),
                onPressed: () async{
                  try{
                    await _auth.createUserWithEmailAndPassword(
                      email: email,
                      password: password
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Erfolgreich registriert.")
                      )
                    );
                  } on FirebaseAuthException catch (e){
                    showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Registrierung fehlgeschlagen"),
                          content: Text('${e.message}'),
                        )
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}




/*
* TODO: Datenbank einbindung
* */

class DatenbankView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Row(
                children: const [
                  Text("Notiz"),
                  Text("Passwort")
                ],
              ),
              ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemExtent: 20.0,
                itemBuilder: (BuildContext context, int index){
                  return Row(
                    children: const [
                      Text("")
                    ],
                  );
                },
              )
            ],
          )
        ),
      ),
    );
  }
}