import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:sandra_foods_app/util/Design.dart';
import 'dart:ui' as ui;
import '../model/Filtro.dart';
import '../telas/AdicionarItem.dart';
import '../util/Controller.dart';


class Cardapio extends StatefulWidget {
  const Cardapio({Key? key}) : super(key: key);

  @override
  State<Cardapio> createState() => _CardapioState();
}

class _CardapioState extends State<Cardapio> with TickerProviderStateMixin{

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
  void initState() {
    // TODO: implement initState
    super.initState();
    controller_mobx.limpa_filtro_aplicado();
  }


  @override
  Widget build(BuildContext context) {
    controller_mobx.criar_animation_controller_filtro(this);
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
                  title: Text('Cardápio', style: TextStyle(fontWeight: FontWeight.bold),),
                  backgroundColor: corLaranjaSF,
                  automaticallyImplyLeading: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                  ),
                  actions: <Widget>[
                    Observer(
                      builder:(_){
                        return Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: IconButton(
                            icon: (controller_mobx.icone_filtro_cardapio == false) ? Icon(Icons.filter_alt, color: Colors.white,) : Icon(Icons.filter_alt_off, color: Colors.white),
                            tooltip: (controller_mobx.icone_filtro_cardapio == false) ? "Mostrar Filtro" : "Esconder Filtro" ,
                            onPressed: () {
                              _scrollController.animateTo(
                                _scrollController.position.minScrollExtent,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                              //controller_mobx.limpa_filtro_aplicado();
                              controller_mobx.altera_icone_filtro_cardapio();
                            },
                          )
                        );
                      }
                    )
                  ],
                ),
                backgroundColor: Colors.transparent,
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    //btfLanche, btfCrepe, btfTapioca, btfPastel, btfPorcao, btfBebida, btfOutro, btfSalgado, btfDoce, btMostrarFiltros
                    Observer(
                        builder: (_){
                          return AnimatedOpacity(
                              opacity: (controller_mobx.icone_filtro_cardapio == false) ? 0.0 : 1.0,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.linear,
                              child: SlideTransition(
                                position: controller_mobx.offsetAnimation_slide!,
                                child: SizeTransition(
                                    sizeFactor: controller_mobx.animation_size!,
                                    axis: Axis.vertical,
                                    axisAlignment: -1,
                                    child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Container(
                                          height: altura,
                                          width: largura,
                                          child: GridView.count(
                                            childAspectRatio: 1 / 0.7,
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            crossAxisCount: 1,
                                            mainAxisSpacing: 4,
                                            crossAxisSpacing: 4,
                                            children: List.generate(controller_mobx.lista_filtro.length, (index) {
                                              return Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(15),
                                                  ),
                                                  elevation: (controller_mobx.lista_filtro[index].grupo == controller_mobx.filtro_aplicado_valor.grupo
                                                           && controller_mobx.lista_filtro[index].tipo == controller_mobx.filtro_aplicado_valor.tipo) ? 0.5 : 4.0,
                                                  shadowColor: corLaranjaSF,
                                                  child: Container(
                                                      decoration: (controller_mobx.lista_filtro[index].grupo == controller_mobx.filtro_aplicado_valor.grupo
                                                          && controller_mobx.lista_filtro[index].tipo == controller_mobx.filtro_aplicado_valor.tipo) ? design.container_grad_branco_laranja : design.container_transparente,
                                                      height: (altura*0.67) - 24,
                                                      width: 100,
                                                      child: InkWell(
                                                        borderRadius: BorderRadius.circular(15),
                                                        splashColor: corLaranjaSF.withOpacity(0.20),
                                                        onTap: (){
                                                          if(controller_mobx.lista_filtro[index].grupo == controller_mobx.filtro_aplicado_valor.grupo
                                                          && controller_mobx.lista_filtro[index].tipo == controller_mobx.filtro_aplicado_valor.tipo){
                                                            controller_mobx.lista_itens_cardapio_mostrar = controller_mobx.lista_itens_cardapio;
                                                            controller_mobx.limpa_filtro_valor_aplicado();
                                                          }
                                                          else{
                                                            controller_mobx.preenche_lista_itens_filtrada(controller_mobx.lista_filtro[index]);
                                                          }
                                                        },
                                                        child: Stack(
                                                            children: <Widget>[
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Align(
                                                                    alignment: Alignment.topCenter,
                                                                    child: Padding(
                                                                        padding: EdgeInsets.fromLTRB(4,4,4,2),
                                                                        child: Container(
                                                                          //child: Image.network(controller_mobx.lista_filtro[index].imagem)
                                                                          child: Image.network(
                                                                            controller_mobx.lista_filtro[index].imagem,
                                                                            fit: BoxFit.scaleDown,
                                                                            loadingBuilder: (BuildContext context, Widget child,
                                                                                ImageChunkEvent? loadingProgress) {
                                                                              if (loadingProgress == null) return child;
                                                                              return Center(
                                                                                child: CircularProgressIndicator(
                                                                                  value: loadingProgress.expectedTotalBytes != null
                                                                                      ? loadingProgress.cumulativeBytesLoaded /
                                                                                      loadingProgress.expectedTotalBytes!
                                                                                      : null,
                                                                                ),
                                                                              );
                                                                            },
                                                                          ),
                                                                          /*Image(
                                                            height: 50,
                                                            width: 50,
                                                            image: FirebaseImageProvider(
                                                                url: FirebaseUrl(controller_mobx.lista_filtro[index].imagem),
                                                                //url: FirebaseUrl("gs://sandra-foods-app.appspot.com/filtro/g1-t1.png"),
                                                                options: CacheOptions(
                                                                  source: Source.cacheServer,
                                                                )
                                                            ),
                                                            frameBuilder: (_, child, frame, __){
                                                              if(frame == null) return child;
                                                              return const CircularProgressIndicator(color: corMarromSF,);
                                                            },
                                                          )*/
                                                                        )
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Align(
                                                                      alignment: Alignment.center,
                                                                      child: Padding(
                                                                        padding: EdgeInsets.fromLTRB(4,2,4,4),
                                                                        child: AutoSizeText(
                                                                          controller_mobx.lista_filtro[index].descricao,
                                                                          textAlign: TextAlign.center,
                                                                          style: TextStyle(color: corMarromSF, fontSize: (12), fontWeight: FontWeight.bold),
                                                                          minFontSize: 10,
                                                                          maxLines: 2,
                                                                          overflow: TextOverflow.ellipsis,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ]
                                                        ),
                                                      )
                                                  )
                                              );
                                            }),
                                          )
                                      ),
                                    )
                                )
                              )
                          );
                        }
                    ),
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
                                    itemCount: controller_mobx.lista_itens_cardapio_mostrar.length,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.all(8),
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (BuildContext, index){

                                      TextStyle _style_nome_item = TextStyle(color: corMarromSF, fontSize: (20), fontWeight: FontWeight.bold);
                                      String _text_nome_item = controller_mobx.lista_itens_cardapio_mostrar[index].nome;
                                      Size _size_nome = _textSize(_text_nome_item, _style_nome_item);

                                      TextStyle _style_valor_item = TextStyle(color: Colors.white, fontSize: (20), fontWeight: FontWeight.bold);
                                      String _text_valor_item = NumberFormat.simpleCurrency(locale: 'pt_BR').format(controller_mobx.lista_itens_cardapio_mostrar[index].valor);
                                      Size _size_valor = _textSize(_text_valor_item, _style_valor_item);

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
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => AdicionarItem(controller_mobx.lista_itens_cardapio_mostrar[index], controller_mobx.lista_adicionais_cardapio)
                                                  )
                                                );
                                              },
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                      height: 100,
                                                      width: largura,
                                                      child: Stack(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding: EdgeInsets.all(8),
                                                            child: Container(
                                                              height: 64,
                                                              width: 64,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(40),
                                                                color: corMarromSF,
                                                              ),
                                                              child: Icon(
                                                                Icons.restaurant, color: corLaranjaSF,
                                                              ),
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment: Alignment.topLeft,
                                                            child: Padding(
                                                              padding: EdgeInsets.only(left: 80, right: 8, top:  8),
                                                              child: AutoSizeText(
                                                                _text_nome_item,
                                                                textAlign: TextAlign.left,
                                                                style: _style_nome_item,
                                                                minFontSize: 14,
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment: Alignment.topLeft,
                                                            child: Padding(
                                                              padding: EdgeInsets.fromLTRB(80, _size_nome.height + 14, _size_valor.width + 32, 2),
                                                              child: AutoSizeText(
                                                                controller_mobx.lista_itens_cardapio_mostrar[index].desc_item,
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
                                                                    NumberFormat.simpleCurrency(locale: 'pt_BR').format(controller_mobx.lista_itens_cardapio_mostrar[index].valor),
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
  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style), maxLines: 1, textDirection: ui.TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}
