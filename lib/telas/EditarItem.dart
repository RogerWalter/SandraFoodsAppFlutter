import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandra_foods_app/model/ItemCardapio.dart';
import 'package:sandra_foods_app/model/ItemPedido.dart';
import '../util/Controller.dart';
import '../util/Erro.dart';


class EditarItem extends StatefulWidget {

  ItemPedido item_edit = ItemPedido();
  List<ItemCardapio> lista_adicionais = [];
  int indice_atualizar = 0;

  EditarItem(this.item_edit, this.lista_adicionais, this.indice_atualizar);

  @override
  State<EditarItem> createState() => _EditarItemState();
}

class _EditarItemState extends State<EditarItem> {
  Controller controller_mobx = Controller();
  var _indices_selecionados = [];
  List <ItemCardapio> _selecionados = [];
  List <ItemCardapio> adicionais_do_item = [];
  int _qtd_item = 1;
  num _valor_total_item = 0;
  double _escala_bt_add = 1.0;
  double _escala_bt_rem = 1.0;
  String _hint_obs = "";
  ItemCardapio _item_cardapio_selecionado = ItemCardapio();

  TextEditingController _controller_obs = TextEditingController();
  final FocusNode _foco_obs = FocusNode();

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
    _item_cardapio_selecionado = montar_item_cardapio();
    preencher_adicionais_item();
    popular_selecionados();
    _qtd_item = widget.item_edit.qtd_item;
    _valor_total_item = _calcula_valor_total_item();
    _controller_obs.text = widget.item_edit.obs_item;
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width - 16;
    double altura = MediaQuery.of(context).size.height/5 - 16;

    Future<String> waitLoadAdicionais() async{
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
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AppBar(
                  title: Text('Editar Item', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                  backgroundColor: corMarromSF,
                  automaticallyImplyLeading: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('images/wallpaper_app.png'),
                          colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.05), BlendMode.modulate,),
                          fit: BoxFit.cover
                      )
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 8, 0, 4),
                          child: Container(
                            child: AutoSizeText(
                              widget.item_edit.nome_item,
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
                              widget.item_edit.desc_item,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: corMarromSF,
                                fontSize: (12),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: (adicionais_do_item.length > 0) ? true : false,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                            child: Container(
                              width: largura,
                              child: GridView.count(
                                childAspectRatio: 1 / 0.2,
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
                                                _selecionados.remove(adicionais_do_item[index]);
                                              }
                                              else //aplicar seleção
                                                  {
                                                _indices_selecionados.add(index);
                                                _selecionados.add(adicionais_do_item[index]);
                                              }
                                              _valor_total_item = _calcula_valor_total_item();
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
                        ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: AnimatedScale(
                                      scale: _escala_bt_rem,
                                      duration: Duration(milliseconds: 5),
                                      curve: Curves.easeOutQuint,
                                      child: Card(
                                          elevation: 4,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(20),
                                            splashColor: corLaranjaSF.withOpacity(0.20),
                                            onTap: (){
                                              setState(() {
                                                _escala_bt_rem = 0.8;
                                                if(_qtd_item > 1){
                                                  _qtd_item = _qtd_item - 1;
                                                }
                                                _valor_total_item = _calcula_valor_total_item();
                                                Future.delayed(Duration(milliseconds: 5)).then((value) => setState(()
                                                {
                                                  _escala_bt_rem = 1.0;
                                                }));
                                              });
                                            },
                                            child: Container(
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                                  color: corLaranjaSF,
                                                ),
                                                child: Icon(Icons.remove, color: Colors.white, size: 40,)
                                            ),
                                          )
                                      ),
                                    )
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 4.0,
                                      child: Container(
                                          decoration:  BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            color: Colors.white,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 8, right: 8),
                                            child: Text(
                                              _qtd_item.toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: corLaranjaSF,
                                                fontWeight: FontWeight.bold,
                                                fontSize: (42),
                                              ),
                                            ),
                                          )
                                      ),
                                    )
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: AnimatedScale(
                                      scale: _escala_bt_add,
                                      duration: Duration(milliseconds: 5),
                                      curve: Curves.easeOutQuint,
                                      child: Card(
                                          elevation: 4,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(20),
                                            splashColor: corLaranjaSF.withOpacity(0.20),
                                            onTap: (){
                                              setState(() {
                                                _escala_bt_add = 0.8;
                                                if(_qtd_item < 99){
                                                  _qtd_item = _qtd_item + 1;
                                                }
                                                _valor_total_item = _calcula_valor_total_item();
                                                Future.delayed(Duration(milliseconds: 5)).then((value) => setState(()
                                                {
                                                  _escala_bt_add = 1.0;
                                                }));
                                              });
                                            },
                                            child: Container(
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                                  color: corLaranjaSF,
                                                ),
                                                child: Icon(Icons.add, color: Colors.white, size: 40,)
                                            ),
                                          )
                                      ),
                                    )
                                ),
                              ],
                            )
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                          child: Container(
                            child: TextField(
                              maxLines: 3,
                              minLines: 1,
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z -]"))],
                              controller: _controller_obs,
                              focusNode: _foco_obs,
                              keyboardType: TextInputType.name,
                              textCapitalization: TextCapitalization.sentences,
                              textInputAction: TextInputAction.done,
                              maxLength: 100,
                              cursorColor: corLaranjaSF,
                              style: TextStyle(
                                color: corMarromSF,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  counterText: "",
                                  contentPadding: EdgeInsets.only(top: 12, bottom: 12),
                                  labelText: "Observações do Item",
                                  hintText: _hint_obs,
                                  hintStyle:TextStyle(color: Colors.black45, fontWeight: FontWeight.normal, fontSize: 16),
                                  labelStyle: TextStyle(color: corMarromSF, fontWeight: FontWeight.normal),
                                  fillColor: Colors.white,
                                  hoverColor: corLaranjaSF,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(width: 2, color: corMarromSF),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(width: 2, color: corLaranjaSF),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  prefixIcon: Icon(Icons.info, color:corLaranjaSF),
                                  suffixIcon: Icon(Icons.info, color:corLaranjaSF)
                              ),
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                              Navigator.of(context).pop();
                                            },
                                            child: Container(
                                                height: 40,
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
                                      child: Text(
                                        NumberFormat.simpleCurrency(locale: 'pt_BR').format(_valor_total_item),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: (32),
                                        ),
                                      ),
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
                                              salvar_item();
                                            },
                                            child: Container(
                                                height: 40,
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
                              ],
                            )
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }
          else if(snapshot.hasError){
            return Erro();
          }else{
            return Container(
              height: 600,
              width: double.infinity,
              child: Scaffold(
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
              ),
            );
          }
        }
    );
  }
  preencher_adicionais_item() async{
    adicionais_do_item.clear();
    //9 = LANCHES | 8 = PASTÉIS | 7 = PORÇÕES
    if(widget.item_edit.grupo_item == 1){//LANCHE
      _hint_obs = "Ex.: Faz sem cebola meus lindão!";
      for(int i = 0; i < widget.lista_adicionais.length; i++){
        if(widget.lista_adicionais[i].tipo == 9){
          adicionais_do_item.add(widget.lista_adicionais[i]);
        }
      }
    }
    if(widget.item_edit.grupo_item == 2 && widget.item_edit.tipo_item == 1){//CREPES SALGADO
      _hint_obs = "Ex.: Sem queijo por fora meus queridos!";
    }
    if(widget.item_edit.grupo_item == 2 && widget.item_edit.tipo_item == 2){//CREPES DOCE
      _hint_obs = "Ex.: Capricha nesse chocolate aí Sandra!";
    }
    if(widget.item_edit.grupo_item == 3 && widget.item_edit.tipo_item == 1){//TAPIOCA SALGADO
      _hint_obs = "Ex.: Quero com a massa mais fina meus lindão!";
    }
    if(widget.item_edit.grupo_item == 3 && widget.item_edit.tipo_item == 2){//TAPIOCA DOCE
      _hint_obs = "Ex.: Sem leite condensado meus amores!";
    }
    if(widget.item_edit.grupo_item == 4 && widget.item_edit.tipo_item == 1){//PASTEL
      _hint_obs = "Ex.: Faz sem azeitonas pfvr seus queridos!";
      for(int i = 0; i < widget.lista_adicionais.length; i++){
        if(widget.lista_adicionais[i].tipo == 8){
          adicionais_do_item.add(widget.lista_adicionais[i]);
        }
      }
    }
    if(widget.item_edit.grupo_item == 4 && widget.item_edit.tipo_item == 2){//PASTEL DOCE
      _hint_obs = "Ex.: Quero de chocolate branco meus lindão!";
    }
    if(widget.item_edit.grupo_item == 5){//PORÇÃO
      for(int i = 0; i < widget.lista_adicionais.length; i++){
        _hint_obs = "Ex.: Quero duas maioneses meus amores!";
        if(widget.lista_adicionais[i].tipo == 7){
          adicionais_do_item.add(widget.lista_adicionais[i]);
        }
      }
    }
    if(widget.item_edit.grupo_item == 6){//BEBIDAS
      _hint_obs = "Ex.: Quero sem gelo pfvr meus queridos!";
    }
    if(widget.item_edit.grupo_item == 7){//OUTROS
      _hint_obs = "Ex.: Quero o algodão doce azul meus lindão!";
    }
  }
  num _calcula_valor_total_item()
  {
    num _valor_total_item = 0;
    for(ItemCardapio it in _selecionados)
    {
      _valor_total_item = _valor_total_item + it.valor;
    }
    _valor_total_item = _valor_total_item * _qtd_item;
    return _valor_total_item;
  }

  salvar_item(){
    ItemPedido item_add = ItemPedido();
    item_add.id_item = controller_mobx.lista_itens_pedido.length + 1;
    item_add.id_pedido = "-";
    item_add.nome_item = _item_cardapio_selecionado.nome;
    item_add.desc_item = _item_cardapio_selecionado.desc_item;
    for(int i=0; i < _selecionados.length; i++){
      if(i>0)
        item_add.adicionais_item.add(_selecionados[i]);
    }
    item_add.obs_item = _controller_obs.text;
    item_add.valor_item = _calcula_valor_total_item();
    item_add.qtd_item = _qtd_item;
    item_add.grupo_item = widget.item_edit.grupo_item;
    item_add.tipo_item = widget.item_edit.tipo_item;

    if(item_add.valor_item == widget.item_edit.valor_item && item_add.obs_item == widget.item_edit.obs_item && item_add.qtd_item == widget.item_edit.qtd_item){
      //item foi aberto e nenhuma alteração foi feita. Nesse caso, só fechamos.
      Navigator.of(context).pop();
      return;
    }

    if(controller_mobx.lista_itens_pedido.length > 0){
      int indice_encontrado = -1;
      for(int i = 0; i < controller_mobx.lista_itens_pedido.length; i++){
        if(controller_mobx.lista_itens_pedido[i].nome_item == item_add.nome_item &&
            controller_mobx.lista_itens_pedido[i].obs_item == item_add.obs_item){
          if(controller_mobx.lista_itens_pedido[i].adicionais_item.length != item_add.adicionais_item.length){
            indice_encontrado = -1;
          }
          else{
            int qtd_adicionais = 0;
            for(int j = 0; j < controller_mobx.lista_itens_pedido[i].adicionais_item.length; j++){
              for(int k = 0; k < item_add.adicionais_item.length; k++){
                if(controller_mobx.lista_itens_pedido[i].adicionais_item[j].nome == item_add.adicionais_item[k].nome){
                  qtd_adicionais++;
                }
              }
            }
            if(qtd_adicionais == controller_mobx.lista_itens_pedido[i].adicionais_item.length){
              indice_encontrado = i;
              break;
            }
          }
        }
      }
      if(indice_encontrado != -1){
        if(indice_encontrado != widget.indice_atualizar){
          ItemPedido item_encontrado_lista = controller_mobx.lista_itens_pedido[indice_encontrado];
          num novo_valor = item_encontrado_lista.valor_item + item_add.valor_item;
          int nova_qtd = item_encontrado_lista.qtd_item + item_add.qtd_item;
          item_encontrado_lista.valor_item = novo_valor;
          item_encontrado_lista.qtd_item = nova_qtd;
          controller_mobx.atualizar_item_do_pedido(item_encontrado_lista, indice_encontrado);
          controller_mobx.remover_item_do_pedido(widget.indice_atualizar);
        }
        else{
          controller_mobx.atualizar_item_do_pedido(item_add, widget.indice_atualizar);
        }
      }
      else{
        controller_mobx.atualizar_item_do_pedido(item_add, widget.indice_atualizar);
      }
    }
    else{
      controller_mobx.atualizar_item_do_pedido(item_add, widget.indice_atualizar);
    }
    Navigator.of(context).pop();
  }

  ItemCardapio montar_item_cardapio(){
    ItemCardapio item_cardapio = ItemCardapio();
    item_cardapio.id_item = 0;
    item_cardapio.nome = widget.item_edit.nome_item;
    item_cardapio.desc_item = widget.item_edit.desc_item;

    num valor = widget.item_edit.valor_item / widget.item_edit.qtd_item; //valor unitario
    if(widget.item_edit.adicionais_item.length > 0){
      for(int i = 0; i < widget.item_edit.adicionais_item.length; i++){
        valor = valor - widget.item_edit.adicionais_item[i].valor;
      }
    }

    item_cardapio.valor = valor;
    item_cardapio.tipo = widget.item_edit.tipo_item;
    item_cardapio.grupo = widget.item_edit.grupo_item;
    return item_cardapio;
  }

  popular_selecionados(){
    _selecionados.clear();
    _selecionados.add(_item_cardapio_selecionado);
    if(widget.item_edit.adicionais_item.length > 0){
      for(int i = 0; i < widget.item_edit.adicionais_item.length; i++){
        _selecionados.add(widget.item_edit.adicionais_item[i]);
      }
    }
    if(adicionais_do_item.length > 0){
      for(int j=0; j < adicionais_do_item.length; j++){
        if(widget.item_edit.adicionais_item.contains(adicionais_do_item[j])){
          _indices_selecionados.add(adicionais_do_item.indexOf(adicionais_do_item[j]));
        }
      }
    }
  }
}
