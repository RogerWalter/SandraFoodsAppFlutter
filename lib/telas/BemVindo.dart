import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sandra_foods_app/telas/Principal.dart';
import 'package:sandra_foods_app/util/Helper.dart';

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


const corLaranjaSF = const Color(0xffff6900);
const corMarromSF = const Color(0xff3d2314);

class _BemVindoState extends State<BemVindo> with SingleTickerProviderStateMixin{

  late AnimationController _controllerAnimacao = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this
  );

  late Animation<double> _animation = CurvedAnimation(
      parent: _controllerAnimacao,
      curve: Curves.easeInOutQuint
  );

  Helper helper = Helper();

  double _widthBotao = 800;
  double _heightBotao = 50;
  double _opacidadeTexto = 1;
  double _opacidadeEmoji = 0;
  Color _color = Colors.white;
  String _textBotao = "Quero ser feliz!";

  double _opacidadeLogo = 1;
  Alignment _alinhamento = Alignment.bottomCenter;
  bool _visibility = true;

  double padding = 4;

  double raioBotao = 25;

  Curve curvaAplicada = Curves.slowMiddle;
  Curve curvaOpacidade = Curves.slowMiddle;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _controllerAnimacao.forward();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: AnimatedPadding(
          padding: EdgeInsets.all(padding),
          duration: Duration(milliseconds: 500),
          child:Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/wallpaper_app.png'),
                      colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.05), BlendMode.modulate,),
                      fit: BoxFit.cover
                  )
              ),
              child:ScaleTransition(
                  scale: _animation,
                  child: AnimatedContainer(
                    duration: Duration (seconds: 1),
                    color: Colors.transparent,
                    child: Stack(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        Column(
                            children: <Widget>[
                              Visibility(
                                visible: _visibility,
                                maintainSize: true,
                                maintainAnimation: true,
                                maintainState: true,
                                child: AnimatedOpacity(
                                  opacity: _opacidadeLogo,
                                  duration: Duration(seconds: 1),
                                  curve: curvaOpacidade,
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 64, 0, 32),
                                    //padding: EdgeInsets.fromLTRB(0, 32, 0, 0),
                                    height: 160,
                                    child: Image.asset("images/logo_sandra_foods.png"),
                                  ),
                                ),
                              ),

                              Visibility(
                                  visible: _visibility,
                                  maintainSize: true,
                                  maintainAnimation: true,
                                  maintainState: true,
                                  child: AnimatedOpacity(
                                    opacity: _opacidadeLogo,
                                    duration: Duration(seconds: 1),
                                    curve: curvaOpacidade,
                                    child:Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.fromLTRB(0, 32, 0, 32),
                                        child: Tooltip(
                                            message: 'Se tiver uma frase muito boa a ver com comida, manda pra gente que ela pode aparecer aqui... :D',
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(25),
                                              color: Colors.white,
                                            ),
                                            height: 50,
                                            padding: const EdgeInsets.all(8.0),
                                            preferBelow: false,
                                            textStyle: const TextStyle(
                                              fontSize: 12,
                                            ),
                                            showDuration: const Duration(seconds: 3),
                                            waitDuration: const Duration(milliseconds: 1),
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                                              child:AutoSizeText(
                                                "Saudações pessoa maravilhosa! Saudações pessoa maravilhosa! Saudações pessoa maravilhosa! Saudações pessoa maravilhosa!",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: corLaranjaSF,
                                                  fontSize: 24,
                                                ),
                                                minFontSize: 10,
                                                maxLines: 5,
                                              ),
                                            )
                                        )
                                    ),
                                  )
                              ),

                              Visibility(
                                visible: _visibility,
                                maintainSize: true,
                                maintainAnimation: true,
                                maintainState: true,
                                child: AnimatedOpacity(
                                  opacity: _opacidadeLogo,
                                  duration: Duration(seconds: 1),
                                  curve: curvaOpacidade,
                                  child: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: ElevatedButton(
                                            child: Image.asset(
                                              "images/ic_whats.png",
                                              height: 30,
                                              width: 30,
                                            ),
                                            onPressed: (){
                                              helper.abrirWhats();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              primary: corLaranjaSF,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(25),
                                              ),
                                            ),
                                          )
                                      )
                                  ),
                                ),
                              ),
                            ]
                        ),

                        AnimatedAlign(
                          alignment: _alinhamento,
                          duration: Duration(seconds: 1),
                          curve: Curves.elasticInOut,
                          child: AnimatedContainer(
                            margin: EdgeInsets.all(padding),
                            duration: Duration(seconds: 1),
                            curve: curvaAplicada,
                            width: _widthBotao,
                            height: _heightBotao,
                            color: _color,
                            child: ElevatedButton(
                                onPressed: (){
                                  setState(() {
                                    _widthBotao = 50;
                                    _heightBotao = 50;
                                    _opacidadeEmoji = 1;
                                    _opacidadeTexto = 0;

                                    Future.delayed(Duration(seconds: 1)).then((value) => setState(() {
                                      _opacidadeLogo = 0;
                                      padding = 0;
                                      curvaAplicada = Curves.fastOutSlowIn;
                                      Future.delayed(Duration(seconds: 1)).then((value) => setState(() {
                                        _visibility = false;
                                        _alinhamento = Alignment.center;
                                        Future.delayed(Duration(seconds: 1)).then((value) => setState(() {
                                          _widthBotao = 2000;
                                          _heightBotao = 3000;

                                          raioBotao = 10;
                                          Future.delayed(Duration(seconds: 1)).then((value) => setState(() {
                                            _widthBotao = 50;
                                            _heightBotao = 50;
                                            raioBotao = 25;
                                            Future.delayed(Duration(seconds: 1)).then((value) => setState(() {
                                              _controllerAnimacao.reverse();
                                              Future.delayed(Duration(seconds: 2)).then((value) => setState(() {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => TelaPrincipal()
                                                    )
                                                );
                                              }));
                                            }));
                                          }));
                                        }));
                                      }));
                                    }));
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  primary: corLaranjaSF,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(raioBotao),
                                  ),
                                ),
                                child: Stack(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.center,
                                      child: AnimatedOpacity(
                                        duration: Duration(milliseconds: 1),
                                        opacity: _opacidadeTexto,
                                        curve: Curves.linear,
                                        child: Text(_textBotao.toUpperCase(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: AnimatedOpacity(
                                          duration: Duration(milliseconds: 1),
                                          opacity: _opacidadeEmoji,
                                          curve: Curves.linear,
                                          child: Image.asset(
                                            "images/logo_sf_branca_laranja.png",
                                            width: 40,
                                            height: 40,
                                          )
                                        //child: Icon(Icons.emoji_emotions_outlined, color: Colors.white)
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          ),
                        )
                      ],
                    ),
                  )
              )
          )
      )
    );
  }
}