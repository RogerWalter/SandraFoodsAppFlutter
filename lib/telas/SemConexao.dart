import 'package:flutter/material.dart';
import 'package:sandra_foods_app/telas/BemVindo.dart';

import '../util/Helper.dart';

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

double _opacidade = 0;
const corLaranjaSF = const Color(0xffff6900);
const corMarromSF = const Color(0xff3d2314);
Helper helper = Helper();
double _widthBotao = 800;
double _heightBotao = 50;
double _opacidade_texto = 1;
double _opacidade_progress = 0;
Color _color = Colors.white;
String _textBotao = "Recarregar!";
double raioBotao = 25;
Curve curvaAplicada = Curves.easeInOutQuint;



class _SemConexaoState extends State<SemConexao> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1)).then((value) => setState(()
    {
      _opacidade = 1.0;
    }));
  }

  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;
    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(seconds: 1),
        alignment: Alignment.center,
        child: AnimatedOpacity(
          opacity: _opacidade,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOutQuint,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Container(
                        height: altura/4,
                        child: Image.asset("images/sem_conexao.png"),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "Sem conexão com a Internet",
                        style: TextStyle(
                          color: corMarromSF,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: AnimatedContainer(
                        margin: EdgeInsets.all(8),
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
                                _opacidade_progress = 1;
                                _opacidade_texto = 0;
                                Future.delayed(Duration(seconds: 5)).then((value) => setState(() {
                                  /*Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TelaPrincipal()
                                    )
                                );*/
                                  _widthBotao = 800;
                                  _heightBotao = 50;
                                  if(helper.verificar_conexao(context) == 0){
                                    _opacidade_progress = 0;
                                    _opacidade_texto = 1.0;
                                  }
                                  else{
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => BemVindo("Roger")
                                        )
                                    );
                                  }
                                  /*Future.delayed(Duration(milliseconds: 500)).then((value) => setState(() {
                                    _opacidade_progress = 0;
                                    _opacidade_texto = 1.0;
                                  }));*/
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
                                    opacity: _opacidade_texto,
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
                                      opacity: _opacidade_progress,
                                      curve: Curves.linear,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    //child: Icon(Icons.emoji_emotions_outlined, color: Colors.white)
                                  ),
                                ),
                              ],
                            )
                        ),
                      ),
                    ),
                  ],
                )
            ),
          )
        ),
      ),
    );
  }
}
