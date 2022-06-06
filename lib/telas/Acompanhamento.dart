import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      home: Acompanhamento("","",-1)
  ));
}

class Acompanhamento extends StatefulWidget {

  String _dataPedido = "";
  String _chavePedido = "";
  int _abertoOuFechado = -1;

  Acompanhamento(this._dataPedido, this._chavePedido, this._abertoOuFechado);


  @override
  _AcompanhamentoState createState() => _AcompanhamentoState();
}

class _AcompanhamentoState extends State<Acompanhamento> {

  @override
  Widget build(BuildContext context) {

    String aouf = "";
    if(widget._abertoOuFechado == 1)
      aouf = "Aberto";
    else
      aouf = "Fechado";

    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(seconds: 1),
        alignment: Alignment.center,
        child: Text(
          "Acompanhamento: \n" + widget._dataPedido + "\n" + widget._chavePedido + "\n" + aouf,
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
