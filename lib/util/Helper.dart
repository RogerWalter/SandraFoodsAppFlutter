import 'dart:io';
//import 'dart:js' as js;
import 'package:url_launcher/url_launcher.dart';

class Helper{

  final Uri _url = Uri.parse("whatsapp://send?phone=5547997838305&text=Ol%C3%A1%20equipe%20maravilhosa%20do%20Sandra%20Foods!");
  final String _url_web = "https://api.whatsapp.com/send?phone=5547997838305&text=Ol%C3%A1%20equipe%20maravilhosa%20do%20Sandra%20Foods!";


  void abrirWhats() async {
    try{
      if(Platform.isAndroid || Platform.isIOS){
        if (!await launchUrl(_url)) throw 'Erro ao abrir o WhatsApp: $_url';
      }
    } catch(e){
      //js.context.callMethod('open', [_url_web]);
    }
  }
}
