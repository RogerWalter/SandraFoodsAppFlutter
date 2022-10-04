import 'dart:io';
import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'package:sandra_foods_app/abas/Dados.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart';
import 'package:geocoder2/geocoder2.dart';

class Helper{

  final Uri _url = Uri.parse("whatsapp://send?phone=5547997838305&text=Ol%C3%A1%20equipe%20maravilhosa%20do%20Sandra%20Foods!");
  final String _url_web = "https://api.whatsapp.com/send?phone=5547997838305&text=Ol%C3%A1%20equipe%20maravilhosa%20do%20Sandra%20Foods!";


  void abrirWhats() async {
    try{
      if(Platform.isAndroid || Platform.isIOS){
        if (!await launchUrl(_url)) throw 'Erro ao abrir o WhatsApp: $_url';
      }
    } catch(e){
      js.context.callMethod('open', [_url_web]);
    }
  }

  int verificaPlataforma(){
    int retorno = 0;
    try{
      if(Platform.isAndroid || Platform.isIOS){
        //não é web
        retorno = 0;
      }
    } catch(e){
        //é web
      retorno = 1;
    }
    return retorno;
  }

  Future<int> verificar_conexao(BuildContext context) async
  {
    int valor = 0;
    try{
      if(Platform.isAndroid || Platform.isIOS){
        try {
          final result = await InternetAddress.lookup('example.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            valor = 1;
          }
        } on SocketException catch (_) {
          valor = 0;
        }
      }
    } catch(e){
      valor = 1;
    }
    return valor;
  }

  gerar_dialogo(BuildContext context, String texto_dialogo){
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          title: Icon(Icons.info, color: corLaranjaSF,),
          content: Text(
              texto_dialogo,
            textAlign: TextAlign.center,
            style: TextStyle(color: corMarromSF),
          ),
          actions: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: Text('Certo!', style: TextStyle(color: corLaranjaSF, fontWeight: FontWeight.bold),),
              ),
            )
          ],
        )
    );
  }

  recupera_localizacao() async{
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    double? lat = _locationData.latitude;
    double? lon = _locationData.longitude;

    //AIzaSyB-zxCP5hgtU-oE2rBc_csfqkT0uidrEdw

    GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: lat!,
        longitude: lon!,
        googleMapApiKey: "AIzaSyB-zxCP5hgtU-oE2rBc_csfqkT0uidrEdw");

    String rua = data.address.substring(0, data.address.indexOf(','));
    String start_bairro = " - ";
    String end_bairro = ", ";
    final startIndex_bairro = data.address.indexOf(start_bairro);
    final endIndex_bairro = data.address.indexOf(end_bairro, startIndex_bairro + start_bairro.length);
    String bairro = data.address.substring(startIndex_bairro + start_bairro.length, endIndex_bairro);
    String start_num = ", ";
    String end_num = " - ";
    final startIndex_num = data.address.indexOf(start_num);
    final endIndex_num = data.address.indexOf(end_num, startIndex_num + start_num.length);
    String numero = data.address.substring(startIndex_num + start_num.length, endIndex_num);
    return [rua, numero, bairro];
  }
}
