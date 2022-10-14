import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../util/Controller.dart';
import '../util/Design.dart';

class Pedido extends StatefulWidget {
  const Pedido({Key? key}) : super(key: key);

  @override
  State<Pedido> createState() => _PedidoState();
}

class _PedidoState extends State<Pedido> {
  Controller controller_mobx = Controller();
  Design design = Design();
  ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    controller_mobx = Provider.of(context);
  }


  @override
  Widget build(BuildContext context) {
    Future<String> waitLoadCardapio() async{
      if(controller_mobx.lista_itens_cardapio.length > 0){
        if(controller_mobx.lista_filtro.length > 0){
          return "Carregado";
        }
      }
      else{
        return "Vazio";
      }
      return "Vazio";
    }
    controller_mobx.limpa_filtro_aplicado();
    //controller_mobx.icone_filtro_cardapio = false;
    double largura = MediaQuery.of(context).size.width - 16;
    double altura = MediaQuery.of(context).size.height/5 - 16;

    return FutureBuilder<String>(
        future: waitLoadCardapio(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot){
          if(snapshot.hasData){
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                scrollBehavior: MyCustomScrollBehavior(),
                home: Scaffold(
                  appBar: AppBar(
                    title: Text('Pedido', style: TextStyle(fontWeight: FontWeight.bold),),
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
                      //btfLanche, btfCrepe, btfTapioca, btfPastel, btfPorcao, btfBebida, btfOutro, btfSalgado, btfDoce, btMostrarFiltros
                      Expanded(
                          child: ScrollConfiguration(
                              behavior: ScrollBehavior(),
                              child: GlowingOverscrollIndicator(
                                  axisDirection: AxisDirection.down,
                                  color: corLaranjaSF.withOpacity(0.20),
                                  child: Observer(
                                    builder: (_){
                                      return ListView.builder(
                                        controller: _scrollController,
                                        itemCount: controller_mobx.lista_itens_pedido.length,
                                        shrinkWrap: true,
                                        padding: EdgeInsets.all(8),
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (BuildContext, index){

                                          return Container(
                                            height: 100,
                                            child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(25),
                                                ),
                                                elevation: 6,
                                                shadowColor: corLaranjaSF,
                                                margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                                child: InkWell(
                                                  borderRadius: BorderRadius.circular(25),
                                                  splashColor: corLaranjaSF.withOpacity(0.20),
                                                  onTap: (){

                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                          height: 100,
                                                          width: largura,
                                                          child: Stack(
                                                            children: <Widget>[
                                                              Align(
                                                                alignment: Alignment.topLeft,
                                                                child: Padding(
                                                                  padding: EdgeInsets.only(top: 16,),
                                                                  child: AutoSizeText(
                                                                    controller_mobx.lista_itens_pedido[index].desc_item,
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(fontSize: 24, color: corMarromSF, fontWeight: FontWeight.bold),
                                                                    minFontSize: 14,
                                                                    maxLines: 1,
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                ),
                                                              ),
                                                              Align(
                                                                alignment: Alignment.bottomCenter,
                                                                child: Padding(
                                                                  padding: EdgeInsets.only(bottom: 16),
                                                                  child: AutoSizeText(
                                                                    controller_mobx.lista_itens_pedido[index].qtd_item.toString() + "unidades",
                                                                    textAlign: TextAlign.justify,
                                                                    style: TextStyle(
                                                                      color: corLaranjaSF,
                                                                      fontSize: (12),
                                                                    ),
                                                                    minFontSize: 12,
                                                                    maxLines: 3,
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                ),
                                                              ),
                                                              Align(
                                                                  alignment: Alignment.bottomRight,
                                                                  child: Container(
                                                                    width: 100,
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                                                                      color: corMarromSF,
                                                                    ),
                                                                    child: Padding(
                                                                      padding: EdgeInsets.all(8),
                                                                      child: AutoSizeText(
                                                                        NumberFormat.simpleCurrency(locale: 'pt_BR').format(controller_mobx.lista_itens_pedido[index].valor_item),
                                                                        textAlign: TextAlign.left,
                                                                        style: TextStyle(
                                                                            color: Colors.white,
                                                                            fontSize: (20),
                                                                            fontWeight: FontWeight.bold
                                                                        ),
                                                                        minFontSize: 14,
                                                                        maxLines: 2,
                                                                        overflow: TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                  )
                                                              ),
                                                            ],
                                                          )
                                                      ),
                                                    ],
                                                  ),
                                                )
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  )
                              )
                          )
                      ),
                    ],
                  ),
                  resizeToAvoidBottomInset: false,
                )
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
