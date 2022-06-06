import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/material/icons.dart';
import 'package:flutter/src/painting/alignment.dart';
import 'package:sandra_foods_app/telas/Principal.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Identificacao(),
  ));
}
class Identificacao extends StatefulWidget {
  const Identificacao({Key? key}) : super(key: key);

  @override
  _IdentificacaoState createState() => _IdentificacaoState();
}

class _IdentificacaoState extends State<Identificacao>
        with SingleTickerProviderStateMixin {

  late AnimationController _controllerAnimacao = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this
  );

  late Animation<double> _animation = CurvedAnimation(
      parent: _controllerAnimacao,
      curve: Curves.easeInOutQuint
  );

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

  var mascaraCelular = new MaskTextInputFormatter(
    mask: '(##)#####-####',
    filter: { "#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _controllerAnimacao.forward();
  }

  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerCelular = TextEditingController();

  final FocusNode focoNome = FocusNode();
  final FocusNode focoCelular = FocusNode();
  
  //final Uri _url = Uri.parse("https://api.whatsapp.com/send?phone=5547997838305&text=Ol%C3%A1%20equipe%20maravilhosa%20do%20Sandra%20Foods!");
  final Uri _url = Uri.parse("whatsapp://send?phone=5547997838305&text=Ol%C3%A1%20equipe%20maravilhosa%20do%20Sandra%20Foods!");



  @override
  Widget build(BuildContext context) {

    const corLaranjaSF = const Color(0xffff6900);
    const corMarromSF = const Color(0xff3d2314);

    var dataFormato = new DateFormat('dd/MM/yyyy');
    String dataAtual = dataFormato.format(DateTime.now());

    void _abrirWhats() async {
      if (!await launchUrl(_url)) throw 'Erro ao abrir o WhatsApp: $_url';
    }

    bool validaCampos()
    {
      bool validacao = true;

      if(_controllerNome.text.isEmpty)
        validacao = false;
      else if(_controllerCelular.text.isEmpty)
        validacao = false;
      else if(_controllerCelular.text.length != 14)
        validacao = false;

      return validacao;
    }

    void _salvaDados() async
    {
      String valorNome = _controllerNome.text;
      String valorCelular = _controllerCelular.text;

      final prefs = await SharedPreferences.getInstance();
      prefs.setString("nome", valorNome);
      prefs.setString("celular", valorCelular);
      prefs.setString("rua", "");
      prefs.setString("numero", "");
      prefs.setString("bairro", "");
      prefs.setString("referencia", "");
      prefs.setString("primeiroacesso", "0");
      prefs.setString("ultimoacesso", dataAtual);
    }

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
            statusBarColor: corLaranjaSF,
        )
    );

    return Scaffold(
      backgroundColor: _color,
      resizeToAvoidBottomInset: false,
      body: AnimatedPadding(
        padding: EdgeInsets.all(padding),
        duration: Duration(milliseconds: 500),
        child: Container(
            padding: EdgeInsets.all(padding),
            color: Colors.white,
            child: ScaleTransition(
                scale: _animation,
                child: AnimatedContainer(
                  duration: Duration (seconds: 1),
                  color: _color,
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
                                margin: EdgeInsets.fromLTRB(0, 64, 0, 0),
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
                                  margin: EdgeInsets.fromLTRB(0, 32, 0, 0),
                                  child: Text("Saudações pessoa maravilhosa!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: corLaranjaSF,
                                      fontSize: 24,
                                    ),
                                  ),
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
                                  child:Container(
                                      margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                                      child:Text("Como podemos lhe chamar?",
                                        style: TextStyle(
                                            color: corLaranjaSF,
                                            fontSize: 16
                                        ),
                                      )
                                  )
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
                              child:Container(
                                margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                                child: TextField(
                                  controller: _controllerNome,
                                  focusNode: focoNome,
                                  keyboardType: TextInputType.name,
                                  textCapitalization: TextCapitalization.words,
                                  textInputAction: TextInputAction.next,
                                  maxLength: 40,
                                  cursorColor: corLaranjaSF,
                                  style: TextStyle(
                                    color: corMarromSF,
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    counterText: "",
                                    contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    labelText: "O nome dessa pessoa linda!",
                                    labelStyle: TextStyle(color: corMarromSF),
                                    fillColor: Colors.white,
                                    hoverColor: corLaranjaSF,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(width: 2, color: corLaranjaSF),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(width: 2, color: corMarromSF),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    prefixIcon: Icon(Icons.emoji_emotions_outlined, color:corLaranjaSF),
                                    suffixIcon: Icon(Icons.emoji_emotions_outlined, color:corLaranjaSF),
                                  ),
                                ),
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
                                margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                                child: Text("Qual o seu número de celular?",
                                  style: TextStyle(
                                      color: corLaranjaSF,
                                      fontSize: 16
                                  ),
                                ),
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
                                margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                                child: TextField(
                                  controller: _controllerCelular,
                                  focusNode: focoCelular,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  inputFormatters: [mascaraCelular],
                                  maxLength: 14,
                                  cursorColor: corLaranjaSF,
                                  style: TextStyle(
                                    color: corMarromSF,
                                    fontSize: 16,

                                  ),
                                  decoration: InputDecoration(
                                    counterText: "",
                                    contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    labelText: "O celular dessa pessoa linda!",
                                    labelStyle: TextStyle(color: corMarromSF),
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(width: 2, color: corLaranjaSF),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(width: 2, color: corMarromSF),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    prefixIcon: Icon(Icons.call, color:corLaranjaSF),
                                    suffixIcon: Icon(Icons.call, color:corLaranjaSF),
                                  ),
                                ),
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
                                          _abrirWhats();
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
                                  if(validaCampos() == true)
                                    {
                                      _salvaDados();

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
                                            _widthBotao = 600;
                                            _heightBotao = 800;
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
                                    }
                                  else
                                    {
                                      final snackBar = SnackBar(
                                        backgroundColor: corLaranjaSF,
                                        content: Text(
                                          'Eita, parece que existe algo de errado com o preenchimento de seus dados. Verifique e tente novamente.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white
                                          ),
                                        ),
                                        action: SnackBarAction(
                                          label: 'Ok',
                                          textColor: corMarromSF,
                                          onPressed: () {
                                            if(_controllerNome.text.isEmpty)
                                              FocusScope.of(context).requestFocus(focoNome);
                                            else
                                              FocusScope.of(context).requestFocus(focoCelular);
                                          },
                                        ),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    }
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
        ),
      )
    );
  }
}