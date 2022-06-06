import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sandra_foods_app/model/Andamento.dart';
import 'package:sandra_foods_app/model/Parametro.dart';
import 'package:sandra_foods_app/telas/Acompanhamento.dart';
import 'package:sandra_foods_app/telas/BemVindo.dart';
import 'package:sandra_foods_app/telas/Fechado.dart';
import 'package:sandra_foods_app/telas/Identificacao.dart';
import 'package:sandra_foods_app/telas/SemConexao.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ntp/ntp.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';

void main() async {

  //Inicializar o Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Splash(),
  ));
}
class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();

}

class _SplashState extends State<Splash>
    with SingleTickerProviderStateMixin{

  Parametro _parametros = Parametro();
  DateTime hoje = new DateTime.now();

  String nome = "vazio";
  String celular = "vazio";
  Color corMarromSF = const Color(0xff3d2314);

  String? _nomeRecuperado = "";
  String? _celularRecuperado = "";

  Alignment _alinhamento = Alignment.bottomCenter;
  Color _color = Colors.white;
  double _tamanho = 100;
  double _opacidade = 0;
  Curve _curvaopacidade = Curves.easeOutExpo;
  Duration _duracaoopacidade = Duration(seconds: 1);

  late AnimationController _controllerAnimacao = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this
  );

  late Animation<double> _animation = CurvedAnimation(
      parent: _controllerAnimacao,
      curve: Curves.easeInOutQuint
  );

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
        Future.delayed(Duration(seconds: 1)).then((value) => setState(()
        {
          _alinhamento = Alignment.topCenter;
          _tamanho = 100;
          _opacidade = 0;
          Future.delayed(Duration(seconds: 1)).then((value) => setState(()
          {
            /*Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Identificacao()
                )
            );*/
            _verificarConexao();
          }));
        }));
      }));
    }));

  }

  _verificarConexao() async
  {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _horario();
      }
    } on SocketException catch (_) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SemConexao()
          )
      );
    }
  }

  _recuperar(int _abertoOuFechado) async
  {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getString("nome") != null && prefs.getString("nome") != "")
    {
      //MONTA-SE A CHAVE DE PEDIDO DESTE CLIENTE
      _nomeRecuperado = prefs.getString("nome");
      _celularRecuperado = prefs.getString("celular");
      String celularSoNumeros = _celularRecuperado.toString().replaceAll("(", "").replaceAll(")","").replaceAll(" ", "").replaceAll("-", "");
      String nomeSoLetras = _nomeRecuperado.toString().replaceAll("/", "-").replaceAll("\\", "-").replaceAll(" ", "");
      final chavePedido = celularSoNumeros + "-" + nomeSoLetras;
      //RECUPERA-SE OS PEDIDOS EM ANDAMENTO
      int parametroFor = 0;//usado para verificar o fim do For
      List <Andamento> listaAndamento = <Andamento>[];
      Andamento _andamento;
      await Firebase.initializeApp();
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child("andamento").get();
      if (snapshot.exists) {
        for(DataSnapshot ds in snapshot.children)
          {
            final json = ds.value as Map<dynamic, dynamic>;
            _andamento = Andamento.fromJson(json);
            if(_andamento.id == chavePedido)
            {
              var dataFormato = new DateFormat('dd/MM/yyyy');
              String dia = hoje.toString().substring(8,10);
              String mes = hoje.toString().substring(5,7);
              String ano = hoje.toString().substring(0,4);
              String dataHojeString = dia + "/" + mes + "/" + ano;
              DateTime _dataHoje = dataFormato.parse(dataHojeString);
              DateTime _dataPedido = dataFormato.parse(_andamento.data);
              if(_dataHoje.isAtSameMomentAs(_dataPedido))
                {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Acompanhamento(_andamento.data, _andamento.id, _abertoOuFechado)
                      )
                  );
                  parametroFor = 1; //encontrou
                  break;
                }
            }
          }
        if(parametroFor == 0) //não encontrou nada na lista, portanto o cliente não possui pedido em andamento
          {
            if(_abertoOuFechado == 1)//Estabelecimento Aberto, mandamos ele para a tela de Bem-Vindo
            {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BemVindo(_nomeRecuperado.toString())
                  )
              );
            }
            else //Estabelecimento Fechado, mandamos ele para a tela de Estabelecimento Fechado
            {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Fechado()
                  )
              );
            }
          }
      } else {
        if(_abertoOuFechado == 1)//Estabelecimento Aberto, mandamos ele para a tela de Bem-Vindo
            {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BemVindo(_nomeRecuperado.toString())
              )
          );
        }
        else //Estabelecimento Fechado, mandamos ele para a tela de Estabelecimento Fechado
            {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Fechado()
              )
          );
        }
      }
    }
    else
    {
      if(_abertoOuFechado == 1)
      {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Identificacao()
            )
        );
      }
      else
      {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Fechado()
            )
        );
      }
    }
  }

  _horario() async
  {
    DateTime _myTime;
    _myTime = await NTP.now();
    hoje = _myTime;
    var horaFormato = new DateFormat('HH:mm:ss');
    String horaAtual = horaFormato.format(_myTime);

    _recuperaParametrosFirebase(horaAtual);
  }

  _recuperaParametrosFirebase(String horaAtual) async{

    await Firebase.initializeApp();
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child("parametro").get();
    if (snapshot.exists) {
      final json = snapshot.value as Map<dynamic, dynamic>;
      _parametros = Parametro.fromJson(json);
      _verificaFuncionamento(horaAtual);
    } else {
      print('No data available.');
    }

  }
  _verificaFuncionamento(String horaAtual)
  {
    int _abertoOuFechado = 0; //0 - FECHADO | 1 - ABERTO

    //_parametros.inicio = "09:00"; //TESTE

    String horaAbreString = _parametros.inicio + ":00";
    String horaFechaString = _parametros.fim + ":00";

    var horaFormato = new DateFormat('HH:mm:ss');

    DateTime _horaAbre = horaFormato.parse(horaAbreString);
    DateTime _horaFecha = horaFormato.parse(horaFechaString);
    DateTime _horaAtual = horaFormato.parse(horaAtual);

    if(hoje.weekday==DateTime.monday)
    {
      if(_parametros.seg == 1 && (_horaAtual.isAtSameMomentAs(_horaAbre) || (_horaAtual.isAfter(_horaAbre) && _horaAtual.isBefore(_horaFecha))))
        _abertoOuFechado = 1;//ABERTO
      else
        _abertoOuFechado = 0;//FECHADO
    }
    if(hoje.weekday==DateTime.tuesday)
    {
      if(_parametros.ter == 1 && (_horaAtual.isAtSameMomentAs(_horaAbre) || (_horaAtual.isAfter(_horaAbre) && _horaAtual.isBefore(_horaFecha))))
        _abertoOuFechado = 1;//ABERTO
      else
        _abertoOuFechado = 0;//FECHADO
    }
    if(hoje.weekday==DateTime.wednesday)
    {
      if(_parametros.qua == 1 && (_horaAtual.isAtSameMomentAs(_horaAbre) || (_horaAtual.isAfter(_horaAbre) && _horaAtual.isBefore(_horaFecha))))
        _abertoOuFechado = 1;//ABERTO
      else
        _abertoOuFechado = 0;//FECHADO
    }
    if(hoje.weekday==DateTime.thursday)
    {
      if(_parametros.qui == 1 && (_horaAtual.isAtSameMomentAs(_horaAbre) || (_horaAtual.isAfter(_horaAbre) && _horaAtual.isBefore(_horaFecha))))
        _abertoOuFechado = 1;//ABERTO
      else
        _abertoOuFechado = 0;//FECHADO
    }
    if(hoje.weekday==DateTime.friday)
    {
      if(_parametros.sex == 1 && (_horaAtual.isAtSameMomentAs(_horaAbre) || (_horaAtual.isAfter(_horaAbre) && _horaAtual.isBefore(_horaFecha))))
        _abertoOuFechado = 1;//ABERTO
      else
        _abertoOuFechado = 0;//FECHADO
    }
    if(hoje.weekday==DateTime.saturday)
    {
      if(_parametros.sab == 1 && (_horaAtual.isAtSameMomentAs(_horaAbre) || (_horaAtual.isAfter(_horaAbre) && _horaAtual.isBefore(_horaFecha))))
        _abertoOuFechado = 1;//ABERTO
      else
        _abertoOuFechado = 0;//FECHADO
    }
    if(hoje.weekday==DateTime.sunday)
    {
      if(_parametros.sab == 1 && (_horaAtual.isAtSameMomentAs(_horaAbre) || (_horaAtual.isAfter(_horaAbre) && _horaAtual.isBefore(_horaFecha))))
        _abertoOuFechado = 1;//ABERTO
      else
        _abertoOuFechado = 0;//FECHADO
    }
    _recuperar(_abertoOuFechado);
  }

  @override
  Widget build(BuildContext context) {

    const corLaranjaSF = const Color(0xffff6900);
    const corMarromSF = const Color(0xff3d2314);

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
}
