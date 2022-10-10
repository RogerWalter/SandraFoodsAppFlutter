import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sandra_foods_app/telas/Principal.dart';
import 'package:sandra_foods_app/util/FirebaseUtil.dart';
import 'package:sandra_foods_app/util/Helper.dart';
import '../telas/BemVindo.dart';
import '../firebase_options.dart';
import '../util/Controller.dart';
import 'SemConexao.dart';

void main() async {
  Helper helper = Helper();
  //Inicializar o Firebase
  WidgetsFlutterBinding.ensureInitialized();
  if(helper.verificaPlataforma() == 1){
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  runApp(
      MultiProvider(
        providers: [
          Provider<Controller>(
            create: (_) => Controller(),
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Splash(),
        ),
      )
  );
}
class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash>
    with SingleTickerProviderStateMixin{

  FirebaseUtil fbutil = FirebaseUtil();

  Alignment _alinhamento = Alignment.bottomCenter;
  Color _color = Colors.white;
  double _tamanho = 100;
  double _opacidade = 0;
  Curve _curvaopacidade = Curves.easeOutExpo;
  Duration _duracaoopacidade = Duration(seconds: 1);

  Controller controller_mobx = Controller();

  late AnimationController _controllerAnimacao = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this
  );

  late Animation<double> _animation = CurvedAnimation(
      parent: _controllerAnimacao,
      curve: Curves.easeInOutQuint
  );

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    controller_mobx = Provider.of(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1)).then((value) => setState(()
    {
      _opacidade = 1;
      Future.delayed(Duration(seconds: 1)).then((value) => setState(()
      {
        _alinhamento = Alignment.center;
        _tamanho = 200;
        _curvaopacidade = Curves.easeOutCirc;
        _duracaoopacidade = Duration(milliseconds: 250);
        recupera_dados_app();
        Future.delayed(Duration(seconds: 1)).then((value) => setState(()
        {
          _alinhamento = Alignment.topCenter;
          _tamanho = 100;
          _opacidade = 0;
          Future.delayed(Duration(seconds: 1)).then((value) => setState(()
          {
            fbutil.verificarConexao(context);
            /*Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BemVindo("Roger")
                )
            );
            Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => TelaPrincipal()
                )
            );*/
          }));
        }));
      }));
    }));
  }
  @override
  Widget build(BuildContext context) {
    const corLaranjaSF = const Color(0xffff6900);

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: corLaranjaSF,
        )
    );

    return Scaffold(
      body: AnimatedOpacity(
        opacity: _opacidade,
        duration: _duracaoopacidade,
        curve: _curvaopacidade,
        child: AnimatedContainer(
            duration: Duration(seconds: 1),
            color: _color,
            curve: Curves.fastOutSlowIn,
            child: AnimatedAlign(
                duration: Duration(seconds: 1),
                alignment: _alinhamento,
                curve: Curves.easeOutCirc,
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  curve: Curves.easeOutCirc,
                  height: _tamanho,
                  width: _tamanho,
                  child: Image.asset(
                    "images/logo_sandra_foods.png",
                  ),
                )
            )
        ),
      )
    );
  }
  recupera_dados_app() async{
    await controller_mobx.preenche_listas_cardapio();
    await controller_mobx.preenche_lista_filtro();
  }
}
