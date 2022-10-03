import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const corLaranjaSF = const Color(0xffff6900);

class Pedido extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

  Pedido();

  @override
  Widget build(BuildContext context) {
    return _buildPedido();
  }

  Widget _buildPedido() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedido', style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: corLaranjaSF,
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

}