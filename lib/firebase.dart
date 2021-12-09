import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:crypto/crypto.dart';
import 'main.dart' as main;

final _auth = FirebaseAuth.instance;
String _email = "";
String _password = "";

String _encpass(String password) {
  var _bytes = utf8.encode(password);
  return sha512.convert(_bytes).toString();
}

/*Fertig*/class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}
/*Fertig*/class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final logo = Padding(
      padding: const EdgeInsets.all(20),
      child: Hero(
          tag: 'hero',
          child: CircleAvatar(
            radius: 56.0,
            child: ColorFiltered(
              colorFilter: const ColorFilter.matrix([
                -1, 0, 0, 0,
                255, 0, -1, 0, 0,
                255, 0, 0, -1, 0,
                255, 0, 0, 0, 1, 0,
              ]),
              child: Image.network('https://www.pngkit.com/png/full/301-3012694_account-user-profile-avatar-comments-fa-user-circle.png'),
            )
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
                borderRadius: BorderRadius.circular(50.0),
            ).copyWith()
        ),
        onChanged: (value){
          _email = value;
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
          _password = _encpass(value);
        },
      ),
    );
    final buttonLogin = Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: ButtonTheme(
        height: 56,
        child: ElevatedButton(
          child: const Text('Login', style: TextStyle(fontSize: 20)),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0)
            )
          ),
          onPressed: () async {
            try {
              //print(_email);
              //print(_password);
              await _auth.signInWithEmailAndPassword(
                email: _email,
                password: _password
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
    var buttonForgotPassword = TextButton(
        child: const Text(
          'Passwort vergessen',
          style: TextStyle(
              fontSize: 16),
        ),
        onPressed: (){
          Navigator.pushNamed(context, '/forgot');
        },
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

/*TODO: Style*/class ForgotPassword extends StatefulWidget {
  @override
  _forgotpassword createState() => _forgotpassword();

}

class _forgotpassword extends State<ForgotPassword>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Email Your Email',
                style: TextStyle(fontSize: 30,),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  icon: Icon(
                    Icons.mail,
                  ),
                  focusedBorder: UnderlineInputBorder(
                  ),
                  enabledBorder: UnderlineInputBorder(
                  ),
                  errorBorder: UnderlineInputBorder(
                  ),
                ),
                onChanged: (value){
                  _email = value;
                },
              ),
              const SizedBox(height: 20),
              TextButton(
                child: const Text('Send Email'),
                onPressed: () async {
                  try{
                    await _auth.sendPasswordResetEmail(email: _email);
                  } catch (e){
                    //print("error");
                    //print(e);
                  }
                },
              ),
              TextButton(
                child: const Text('Sign In'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

/*TODO: Style*/class RegisterPage extends StatefulWidget{
  @override
  _RegisterPageState createState() => _RegisterPageState();
}
/*TODO: Style*/class _RegisterPageState extends State<RegisterPage>{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Registrieren"),
        ),
        body: Center(
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: "E-Mail"
                ),
                onChanged: (value){
                  _email = value.toString().trim();
                  //print(_email);
                },
                textAlign: TextAlign.center,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Passwort"
                ),
                obscureText: true,
                validator: (value){
                  if(value!.isEmpty){
                    return "Bitte ein Passwort vergeben.";
                  }
                },
                onChanged: (value) {
                  _password = _encpass(value);
                  //print(_password);
                },
                textAlign: TextAlign.center,
              ),
              TextButton(
                child: const Text("Registrieren"),
                onPressed: () async{
                  try{
                    //print(_email);
                    //print(_password);
                    await _auth.createUserWithEmailAndPassword(
                      email: _email,
                      password: _password
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