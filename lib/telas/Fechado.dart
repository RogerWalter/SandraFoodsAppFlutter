import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      home: Fechado()
  ));
}
class Fechado extends StatefulWidget {
  const Fechado({Key? key}) : super(key: key);

  @override
  _FechadoState createState() => _FechadoState();
}

class _FechadoState extends State<Fechado> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(seconds: 1),
        alignment: Alignment.center,
        child: Text(
          "ESTABELECIMENTO FECHADO",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
