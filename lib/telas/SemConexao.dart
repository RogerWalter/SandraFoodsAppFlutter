import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      home: SemConexao()
  ));
}
class SemConexao extends StatefulWidget {
  const SemConexao({Key? key}) : super(key: key);

  @override
  _SemConexaoState createState() => _SemConexaoState();
}

class _SemConexaoState extends State<SemConexao> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(seconds: 1),
        alignment: Alignment.center,
        child: Text(
          "SEM CONEXÃO COM A INTERNET",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
