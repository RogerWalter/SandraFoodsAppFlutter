import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BemVindo(""),
  ));
}

class BemVindo extends StatefulWidget {
  String nome;
  BemVindo(this.nome);

  @override
  _BemVindoState createState() => _BemVindoState();
}

class _BemVindoState extends State<BemVindo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: AnimatedContainer(
        duration: Duration(seconds: 1),
        alignment: Alignment.center,
        child: Text(
            "Olá " + widget.nome,
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
            ),
        ),
      ),

    );
  }
}
