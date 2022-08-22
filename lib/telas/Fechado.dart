import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

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

class _FechadoState extends State<Fechado> with TickerProviderStateMixin{

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
    lowerBound: 0,
    upperBound: 0.35,
  )..repeat(reverse: true, );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOutQuint,
  );

  @override
  Widget build(BuildContext context) {
    const corLaranjaSF = const Color(0xffff6900);
    const corMarromSF = const Color(0xff3d2314);

    var largura = MediaQuery
        .of(context)
        .size
        .width;


    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/wallpaper_app.png'),
                colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.2), BlendMode.modulate,),
                fit: BoxFit.cover
              )
            ),
          ),
          Center(
            child: RotationTransition(
              alignment: Alignment.topCenter,
              turns: AlwaysStoppedAnimation(345/360),
              child: RotationTransition(
                  alignment: Alignment.topCenter,
                  turns: _animation,
                  child: Container(
                    width: largura/2,
                    child: Image.asset("images/fechado.png"),
                  )
              )
            )
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            primary: corLaranjaSF,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                            child: AutoSizeText(
                              "Informações",
                              style: TextStyle(fontSize: 20,),
                              minFontSize: 10,
                            ),
                          ),
                          onPressed: (){},
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            primary: corLaranjaSF,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                            child: AutoSizeText(
                              "Cardápio",
                              style: TextStyle(fontSize: 20,),
                              minFontSize: 10,
                            ),
                          ),
                          onPressed: (){},
                        ),
                      ),
                    )
                  ],
                ),
              )
            ),
          )
        ],
      )
    );
  }
}
