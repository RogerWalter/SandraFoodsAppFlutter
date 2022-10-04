import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../util/Controller.dart';

class Cardapio extends StatefulWidget {
  const Cardapio({Key? key}) : super(key: key);

  @override
  State<Cardapio> createState() => _CardapioState();
}

class _CardapioState extends State<Cardapio> {

  Controller controller_mobx = Controller();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    Future<String> waitLoadCardapio() async{
      await controller_mobx.preenche_listas_cardapio();
      //await Future.delayed(Duration(seconds: 3));
      return "Carregado";
    }

    double largura = MediaQuery.of(context).size.width - 24;
    double altura = MediaQuery.of(context).size.height/6;

    return FutureBuilder<String>(
        future: waitLoadCardapio(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot){
          if(snapshot.hasData){
            return Scaffold(
              appBar: AppBar(
                title: Text('Cardápio', style: TextStyle(fontWeight: FontWeight.bold),),
                backgroundColor: corLaranjaSF,
                automaticallyImplyLeading: false,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
              ),
              backgroundColor: Colors.transparent,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: ScrollConfiguration(
                          behavior: ScrollBehavior(),
                          child: GlowingOverscrollIndicator(
                            axisDirection: AxisDirection.down,
                            color: corLaranjaSF.withOpacity(0.20),
                            child:ListView.builder(
                              itemCount: controller_mobx.lista_itens_cardapio.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext, index){
                                return Card(
                                  child: ListTile(
                                    leading:  CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.restaurant, color: corLaranjaSF,
                                      ),
                                    ),
                                    title: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 4, 0, 2),
                                      child: Text(
                                        controller_mobx.lista_itens_cardapio[index].nome,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: corMarromSF,
                                          fontSize: (14),
                                        ),
                                      ),
                                    ),
                                    subtitle: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                                          child: Text(
                                            controller_mobx.lista_itens_cardapio[index].desc_item,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: corLaranjaSF,
                                              fontSize: (16),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: Padding(
                                      padding: EdgeInsets.all(0),
                                      child: Text(
                                        NumberFormat.simpleCurrency(locale: 'pt_BR').format(controller_mobx.lista_itens_cardapio[index].valor),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: corMarromSF,
                                          fontSize: (16),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                      )
                  ),
                ],
              ),
              resizeToAvoidBottomInset: false,
            );
          }else if(snapshot.hasError){
            return Text('Erro');
          }else{
            return Scaffold(
              appBar: AppBar(
                title: Text('Cardápio', style: TextStyle(fontWeight: FontWeight.bold),),
                backgroundColor: corLaranjaSF,
                automaticallyImplyLeading: false,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
              ),
              backgroundColor: Colors.transparent,
              body: Center(
                child: Container(
                  alignment: FractionalOffset.center,
                  color: Colors.transparent,
                  height: altura,
                  width: altura,
                  padding: const EdgeInsets.all(20.0),
                  child:  new Image.asset(
                    'images/loading_gif.gif',
                    fit: BoxFit.cover,
                  )
                ),
              ),
              resizeToAvoidBottomInset: false,
            );
          }
        }
    );
  }
}
