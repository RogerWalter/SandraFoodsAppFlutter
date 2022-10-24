import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandra_foods_app/telas/EditarItem.dart';
import 'dart:ui' as ui;
import '../util/Controller.dart';
import '../util/Design.dart';
import '../util/Erro.dart';

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
      controller_mobx.calcular_total_pedido();
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
            if(controller_mobx.lista_itens_pedido.length == 0){
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
                        Center(
                          child: Container(
                            height: altura,
                            width: altura,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("images/sem_dados.png"),
                                    colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.50), BlendMode.modulate,),
                                    fit: BoxFit.cover
                                )
                            ),
                            child: Text("")
                          )
                        )
                      ],
                    ),
                    resizeToAvoidBottomInset: false,
                  )
              );
            }
            else{
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

                                            TextStyle _style_nome_item = TextStyle(fontSize: 24, color: corMarromSF, fontWeight: FontWeight.bold);
                                            String _text_nome_item = controller_mobx.lista_itens_pedido[index].nome_item;
                                            Size _size_nome = _textSize(_text_nome_item, _style_nome_item);

                                            String texto_adicionais = "";
                                            if(controller_mobx.lista_itens_pedido[index].adicionais_item.length > 0){
                                              for(int i = 0; i < controller_mobx.lista_itens_pedido[index].adicionais_item.length; i ++){
                                                texto_adicionais = texto_adicionais + "+" + controller_mobx.lista_itens_pedido[index].adicionais_item[i].nome.toString() + " ";
                                              }
                                            }
                                            else{
                                              if(controller_mobx.lista_itens_pedido[index].obs_item.isNotEmpty){
                                                texto_adicionais = controller_mobx.lista_itens_pedido[index].obs_item;
                                              }
                                              else{
                                                texto_adicionais = "Sem adicionais - Sem observações";
                                              }
                                            }
                                            TextStyle _style_adicionais = TextStyle(color: corLaranjaSF, fontSize: (12));
                                            Size _size_adicionais = _textSize(texto_adicionais, _style_adicionais);

                                            double altura_qtd = _size_nome.height + _size_adicionais.height + 12;

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
                                                      showModalBottomSheet<void>(
                                                        isScrollControlled: true,
                                                        context: context,
                                                        builder: (_) {
                                                          return Wrap(children: <Widget>[ EditarItem(controller_mobx.lista_itens_pedido[index], controller_mobx.lista_adicionais_cardapio, index),],);
                                                        },
                                                      ).then((value) => build(context));
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                            height: 100,
                                                            width: largura,
                                                            child: Stack(
                                                              children: <Widget>[
                                                                Align(
                                                                  alignment: Alignment.topCenter,
                                                                  child: Padding(
                                                                    padding: EdgeInsets.only(top: 4, left: 88, right: 88),
                                                                    child: AutoSizeText(
                                                                      _text_nome_item,
                                                                      textAlign: TextAlign.center,
                                                                      style: _style_nome_item,
                                                                      minFontSize: 14,
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Align(
                                                                  alignment: Alignment.topCenter,
                                                                  child: Padding(
                                                                    padding: EdgeInsets.only(top: _size_nome.height + 4, bottom: 4, left: 88, right: 88),
                                                                    child: AutoSizeText(
                                                                      texto_adicionais,
                                                                      textAlign: TextAlign.center,
                                                                      style: _style_adicionais,
                                                                      minFontSize: 12,
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Align(
                                                                    alignment: Alignment.topLeft,
                                                                    child: Padding(
                                                                        padding: EdgeInsets.zero,
                                                                        child: Container(
                                                                          width: 84,
                                                                          height: altura_qtd,
                                                                          decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.only(topLeft:Radius.circular(20)),
                                                                            color: corMarromSF,
                                                                          ),
                                                                          child: Padding(
                                                                              padding: EdgeInsets.all(4),
                                                                              child: Center(
                                                                                child: AutoSizeText(
                                                                                  controller_mobx.lista_itens_pedido[index].qtd_item.toString(),
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(
                                                                                      color: Colors.white,
                                                                                      fontSize: (28),
                                                                                      fontWeight: FontWeight.bold
                                                                                  ),
                                                                                  minFontSize: 14,
                                                                                  maxLines: 2,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                ),
                                                                              )
                                                                          ),
                                                                        )
                                                                    )
                                                                ),
                                                                Align(
                                                                    alignment: Alignment.bottomLeft,
                                                                    child: Padding(
                                                                        padding: EdgeInsets.only(top: 4),
                                                                        child: Container(
                                                                          width: 84,
                                                                          height: 84 - (altura_qtd),
                                                                          decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.only(bottomLeft:Radius.circular(20)),
                                                                            color: corMarromSF,
                                                                          ),
                                                                          child: Padding(
                                                                              padding: EdgeInsets.all(4),
                                                                              child: Center(
                                                                                child: AutoSizeText(
                                                                                  NumberFormat.simpleCurrency(locale: 'pt_BR').format(controller_mobx.lista_itens_pedido[index].valor_item/controller_mobx.lista_itens_pedido[index].qtd_item) + "\ncada",
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(
                                                                                      color: Colors.white,
                                                                                      fontSize: (10),
                                                                                      fontWeight: FontWeight.bold
                                                                                  ),
                                                                                  minFontSize: 8,
                                                                                  maxLines: 2,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                ),
                                                                              )
                                                                          ),
                                                                        )
                                                                    )
                                                                ),
                                                                Align(
                                                                    alignment: Alignment.bottomCenter,
                                                                    child: Padding(
                                                                      padding: EdgeInsets.fromLTRB(88,4,88,4),
                                                                      child: AutoSizeText(
                                                                        NumberFormat.simpleCurrency(locale: 'pt_BR').format(controller_mobx.lista_itens_pedido[index].valor_item),
                                                                        textAlign: TextAlign.center,
                                                                        style: TextStyle(
                                                                            color: corMarromSF,
                                                                            fontSize: (24),
                                                                            fontWeight: FontWeight.w900
                                                                        ),
                                                                        minFontSize: 14,
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                      ),
                                                                    )
                                                                ),
                                                                Align(
                                                                    alignment: Alignment.centerRight,
                                                                    child: Padding(
                                                                      padding: EdgeInsets.all(8),
                                                                      child: Container(
                                                                        height: 64,
                                                                        width: 64,
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(40),
                                                                          color: corMarromSF,
                                                                        ),
                                                                        child: IconButton(
                                                                          onPressed: (){
                                                                            showAnimatedDialog(
                                                                              context: context,
                                                                              barrierDismissible: true,
                                                                              builder: (context) {
                                                                                return CustomDialog(
                                                                                  shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.all(Radius.circular(25.0))),
                                                                                    child: Wrap(
                                                                                      children: <Widget>[
                                                                                        Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                            children: <Widget>[
                                                                                              Align(
                                                                                                alignment: Alignment.center,
                                                                                                child: Padding(
                                                                                                  padding: EdgeInsets.fromLTRB(8,8,8,4),
                                                                                                  child: Text(
                                                                                                    "Remover Item",
                                                                                                    style: TextStyle(
                                                                                                        fontSize: 24,
                                                                                                        fontWeight: FontWeight.bold,
                                                                                                        color: corLaranjaSF
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              Align(
                                                                                                alignment: Alignment.center,
                                                                                                child: Padding(
                                                                                                  padding: EdgeInsets.fromLTRB(8,4,8,4),
                                                                                                  child: Text(
                                                                                                    "Deseja realmente remover este item de seu pedido?",
                                                                                                    style: TextStyle(
                                                                                                        fontSize: 14,
                                                                                                        fontWeight: FontWeight.normal,
                                                                                                        color: corLaranjaSF
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              Align(
                                                                                                alignment: Alignment.center,
                                                                                                child: Padding(
                                                                                                    padding: EdgeInsets.fromLTRB(8,4,8,8),
                                                                                                    child: Row(
                                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                        children: <Widget>[
                                                                                                          Expanded(
                                                                                                              child: TextButton(
                                                                                                                onPressed: (){
                                                                                                                  Navigator.of(context).pop();
                                                                                                                },
                                                                                                                child: Text(
                                                                                                                    "Não",
                                                                                                                    style: TextStyle(
                                                                                                                      fontSize: 14,
                                                                                                                      fontWeight: FontWeight.bold,
                                                                                                                      color: corMarromSF,
                                                                                                                    ),
                                                                                                                    textAlign: TextAlign.center
                                                                                                                ),
                                                                                                              )
                                                                                                          ),
                                                                                                          Expanded(
                                                                                                              child: TextButton(
                                                                                                                onPressed: (){
                                                                                                                  controller_mobx.remover_item_do_pedido(index);
                                                                                                                  if(controller_mobx.lista_itens_pedido.length == 0)
                                                                                                                    setState((){});
                                                                                                                  Navigator.of(context).pop();
                                                                                                                },
                                                                                                                child: Text(
                                                                                                                    "Sim",
                                                                                                                    style: TextStyle(
                                                                                                                        fontSize: 14,
                                                                                                                        fontWeight: FontWeight.bold,
                                                                                                                        color: corMarromSF
                                                                                                                    ),
                                                                                                                    textAlign: TextAlign.center
                                                                                                                ),
                                                                                                              )
                                                                                                          )
                                                                                                        ]
                                                                                                    )
                                                                                                ),
                                                                                              )
                                                                                            ]
                                                                                        )
                                                                                      ],
                                                                                    )
                                                                                );
                                                                              },
                                                                              animationType: DialogTransitionType.fadeScale,
                                                                              curve: Curves.easeOutQuint,
                                                                              duration: Duration(seconds: 1),
                                                                            );
                                                                          },
                                                                          icon: Icon(Icons.delete_forever_rounded, color: corLaranjaSF, size: 48,),
                                                                        )
                                                                      ),
                                                                    ),
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
                    bottomSheet: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                              child: Card(
                                  elevation: 4.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: InkWell(
                                      borderRadius: BorderRadius.circular(15),
                                      splashColor: corLaranjaSF.withOpacity(0.20),
                                      onTap: (){
                                        showAnimatedDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (BuildContext context) {
                                            return ClassicGeneralDialogWidget(
                                              titleText: "Limpar Pedido?",
                                              contentText: 'Esta ação excluirá todos os itens de seu pedido.\nDeseja continuar?',
                                              positiveText: "Sim",
                                              negativeText: "Não",
                                              onPositiveClick: () {
                                                controller_mobx.limpar_pedido();
                                                setState((){});
                                                Navigator.of(context).pop();
                                              },
                                              onNegativeClick: () {
                                                Navigator.of(context).pop();
                                              },
                                            );
                                          },
                                          animationType: DialogTransitionType.fadeScale,
                                          curve: Curves.easeOutQuint,
                                          duration: Duration(seconds: 1),
                                        );
                                      },
                                      child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            border: Border.all(
                                              width: 1.0,
                                              color: corMarromSF,
                                            ),
                                            color: Colors.transparent,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(4),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  child: AutoSizeText(
                                                    "Cancelar",
                                                    //_listaItensMesa[index].desc_item,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: corLaranjaSF,
                                                        fontSize: (20),
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                    minFontSize: 10,
                                                    maxLines: 1,
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                      )
                                  )
                              )
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                color: corMarromSF,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Observer(
                                  builder: (_){
                                    return Text(
                                      NumberFormat.simpleCurrency(locale: 'pt_BR').format(controller_mobx.total_pedido),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: (32),
                                      ),
                                    );
                                  },
                                )
                              ),
                            ),
                          ),
                          Expanded(
                              child: Card(
                                  elevation: 4.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: InkWell(
                                      borderRadius: BorderRadius.circular(15),
                                      splashColor: corLaranjaSF.withOpacity(0.20),
                                      onTap: (){
                                        //salvar_item();
                                      },
                                      child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            color: Colors.transparent,
                                            border: Border.all(
                                              width: 1.0,
                                              color: corMarromSF,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(4),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  child: AutoSizeText(
                                                    "Confirmar",
                                                    //_listaItensMesa[index].desc_item,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: corLaranjaSF,
                                                        fontSize: (20),
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                    minFontSize: 10,
                                                    maxLines: 1,
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                      )
                                  )
                              )
                          ),
                        ]
                      ),
                    ),
                  )
              );
            }
          }else if(snapshot.hasError){
            return Scaffold(
              appBar: AppBar(
                title: Text('Dados', style: TextStyle(fontWeight: FontWeight.bold),),
                backgroundColor: corLaranjaSF,
                automaticallyImplyLeading: false,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
              ),
              backgroundColor: Colors.transparent,
              body: Erro(),
              resizeToAvoidBottomInset: false,
            );
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
  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style), maxLines: 1, textDirection: ui.TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}
