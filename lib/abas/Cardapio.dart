import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const corLaranjaSF = const Color(0xffff6900);

class Cardapio extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

  Cardapio();

  @override
  Widget build(BuildContext context) {
    return _buildCardapio();
  }

  Widget _buildCardapio() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cardápio', style: TextStyle(fontWeight: FontWeight.bold),),
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
