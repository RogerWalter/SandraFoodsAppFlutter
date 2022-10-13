import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandra_foods_app/model/ItemCardapio.dart';

import '../util/Controller.dart';

class AdicionarItem extends StatefulWidget {

  ItemCardapio item_add = ItemCardapio();
  List<ItemCardapio> lista_adicionais = [];

  AdicionarItem(this.item_add, this.lista_adicionais);

  @override
  State<AdicionarItem> createState() => _AdicionarItemState();
}

class _AdicionarItemState extends State<AdicionarItem> {
  Controller controller_mobx = Controller();
  bool _isEnabled = false;
  var _indices_selecionados = [];
  List <ItemCardapio> _selecionados = [];
  List <ItemCardapio> adicionais_do_item = [];

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
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width - 16;
    double altura = MediaQuery.of(context).size.height/5 - 16;

    Future<String> waitLoadAdicionais() async{
      await preencher_adicionais_item();
      if(adicionais_do_item.length > 0){
        return "Carregado";
      }
      else{
        return "";
      }
    }

    return FutureBuilder<String>(
      future: waitLoadAdicionais(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){
        if(snapshot.hasData){
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/wallpaper_app.png'),
                    colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.05), BlendMode.modulate,),
                    fit: BoxFit.cover
                )
            ),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  title: Text('Adicionar Item', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                  backgroundColor: corMarromSF,
                  automaticallyImplyLeading: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                  ),
                ),
                body: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 0, 4),
                        child: Container(
                          child: AutoSizeText(
                            widget.item_add.nome,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: corLaranjaSF,
                                fontSize: (32),
                                fontWeight: FontWeight.bold
                            ),
                            minFontSize: 14,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                        child: Container(
                          child: Text(
                            widget.item_add.desc_item,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: corMarromSF,
                              fontSize: (12),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                        child: Container(
                          width: largura,
                          child: GridView.count(
                            childAspectRatio: 1 / 0.2,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                            children: List.generate(adicionais_do_item.length, (index) {
                              return Card(
                                  elevation: _indices_selecionados.contains(index) ? 0.5 : 4.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: InkWell(
                                      borderRadius: BorderRadius.circular(15),
                                      splashColor: corLaranjaSF.withOpacity(0.20),
                                      onTap: (){
                                        setState(() {
                                          if(_indices_selecionados.contains(index))//remover seleção
                                              {
                                            _indices_selecionados.remove(index);
                                            _selecionados.remove(widget.lista_adicionais[index]);
                                            if(_selecionados.length > 0)
                                              _isEnabled = true;
                                            else
                                              _isEnabled = false;
                                          }
                                          else //aplicar seleção
                                              {
                                            _indices_selecionados.add(index);
                                            _selecionados.add(widget.lista_adicionais[index]);
                                            if(_selecionados.length > 0)
                                              _isEnabled = true;
                                            else
                                              _isEnabled = false;
                                          }
                                        });
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            color: _indices_selecionados.contains(index) ? corLaranjaSF.withOpacity(0.20) : Colors.transparent,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(4),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(right: 8),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(15),
                                                      color: _indices_selecionados.contains(index) ? corLaranjaSF : corMarromSF,
                                                    ),
                                                    child: _indices_selecionados.contains(index) ? Icon(Icons.check, color: Colors.white,) : Icon(Icons.add, color: Colors.white,),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: AutoSizeText(
                                                    adicionais_do_item[index].nome,
                                                    //_listaItensMesa[index].desc_item,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        color: corMarromSF,
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
                              );
                            },),
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                          child: Expanded(
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                                        color: corMarromSF,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          NumberFormat.simpleCurrency(locale: 'pt_BR').format(widget.item_add.valor),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: (32),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                            ),
                          )
                      ),
                    ],
                  ),
                )
            )
          );
        }
        else if(snapshot.hasError){
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
  preencher_adicionais_item() async{
    adicionais_do_item.clear();
    //9 = LANCHES | 8 = PASTÉIS | 7 = PORÇÕES
    if(widget.item_add.grupo == 1){//LANCHE
      for(int i = 0; i < widget.lista_adicionais.length; i++){
        if(widget.lista_adicionais[i].tipo == 9){
          adicionais_do_item.add(widget.lista_adicionais[i]);
        }
      }
    }
    if(widget.item_add.grupo == 4 && widget.item_add.tipo == 1){//PASTEL
      for(int i = 0; i < widget.lista_adicionais.length; i++){
        if(widget.lista_adicionais[i].tipo == 8){
          adicionais_do_item.add(widget.lista_adicionais[i]);
        }
      }
    }
    if(widget.item_add.grupo == 5){//PORÇÃO
      for(int i = 0; i < widget.lista_adicionais.length; i++){
        if(widget.lista_adicionais[i].tipo == 7){
          adicionais_do_item.add(widget.lista_adicionais[i]);
        }
      }
    }
  }
}
