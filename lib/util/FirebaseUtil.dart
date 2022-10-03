import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_machine/time_machine.dart';

import '../model/Andamento.dart';
import '../model/Parametro.dart';
import '../telas/Acompanhamento.dart';
import '../telas/BemVindo.dart';
import '../telas/Fechado.dart';
import '../telas/Identificacao.dart';
import '../telas/SemConexao.dart';

class FirebaseUtil{

  DateTime hoje = new DateTime.now();
  Parametro _parametros = Parametro();
  String? _nomeRecuperado = "";
  String? _celularRecuperado = "";

  verificarConexao(BuildContext context) async
  {
    try{
      if(Platform.isAndroid || Platform.isIOS){
        try {
          final result = await InternetAddress.lookup('example.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            horario(context);
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
    } catch(e){
      horario(context);
    }
  }

  horario(BuildContext context) async
  {
    await Firebase.initializeApp();
    await TimeMachine.initialize( { 'rootBundle': rootBundle, });
    var tzdb = await DateTimeZoneProviders.tzdb;
    var local = await tzdb["America/Sao_Paulo"];
    DateTime _myTime;
    var now = Instant.now();
    _myTime = now.inZone(local).toDateTimeLocal();
    hoje = _myTime;
    var horaFormato = new DateFormat('HH:mm:ss');
    String horaAtual = horaFormato.format(_myTime);

    recuperaParametrosFirebase(horaAtual, context);
  }

  recuperaParametrosFirebase(String horaAtual, BuildContext context) async{

    await Firebase.initializeApp();
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child("parametro").get();
    if (snapshot.exists) {
      final json = snapshot.value as Map<dynamic, dynamic>;
      _parametros = Parametro.fromJson(json);
      verificaFuncionamento(horaAtual, context);
    } else {
      print('No data available.');
    }

  }

  verificaFuncionamento(String horaAtual, BuildContext context)
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
    recuperar(_abertoOuFechado, context);
  }

  recuperar(int _abertoOuFechado, BuildContext context) async
  {
    //excluir após os teste




    _abertoOuFechado = 1;




    //excluir após os teste
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
}