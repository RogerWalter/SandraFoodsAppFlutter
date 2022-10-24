import 'package:flutter/material.dart';

class Erro extends StatefulWidget {
  const Erro({Key? key}) : super(key: key);

  @override
  State<Erro> createState() => _ErroState();
}

class _ErroState extends State<Erro> {
  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.of(context).size.height/5 - 16;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
            child: Container(
                height: altura,
                width: altura,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/tela_erro.png"),
                        colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.50), BlendMode.modulate,),
                        fit: BoxFit.cover
                    )
                ),
                child: Text("")
            )
        )
      ],
    );
  }
}
