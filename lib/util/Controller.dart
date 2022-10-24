import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:sandra_foods_app/abas/Cardapio.dart';
import 'package:sandra_foods_app/model/Cliente.dart';
import 'package:sandra_foods_app/model/ItemPedido.dart';
import 'package:sandra_foods_app/telas/SemConexao.dart';

import '../model/Filtro.dart';
import '../model/ItemCardapio.dart';
import '../model/Taxa.dart';
part 'Controller.g.dart';

const corLaranjaSF = const Color(0xffff6900);
const corMarromSF = const Color(0xff3d2314);
const corPastelSF = const Color(0xfffafcc2);

class Controller = ControllerBase with _$Controller;

abstract class ControllerBase with Store{

  //ABA DADOS
  @observable
  double escala_imagem_dados = 0.8;

  @action
  alterar_escala(double escala){
    escala_imagem_dados = escala;
  }

  @observable
  double opacidade_texto_bt = 1.0;
  @observable
  double opacidade_progress = 0.0;
  @observable
  double opacidade_icone_salvo = 0.0;
  @observable
  Color cor_botao_salvar_dados = corLaranjaSF;

  @action
  salvar_dados_cliente(Cliente cliente) async{
    Cliente cli = Cliente();
    opacidade_progress = 1;
    opacidade_texto_bt = 0;
    opacidade_icone_salvo = 0;
    await cli.salvar_dados(cliente);
    //await Future.delayed(Duration(seconds: 2));
    opacidade_progress = 0;
    opacidade_texto_bt = 0;
    opacidade_icone_salvo = 1;
    cor_botao_salvar_dados = Colors.green;
    await Future.delayed(Duration(seconds: 1));
    opacidade_progress = 0;
    opacidade_texto_bt = 1;
    opacidade_icone_salvo = 0;
    cor_botao_salvar_dados = corLaranjaSF;
  }

  @observable
  String? bairro_selecionado_dropdown = "";

  @action
  seleciona_bairro(String? bairro){
    bairro_selecionado_dropdown = bairro;
  }

  @observable
  double opacidade_texto_bt_preencher_dados = 1.0;
  @observable
  double opacidade_progress_preencher_dados = 0.0;
  @observable
  double opacidade_icone_preencher_dados = 0.0;

  @observable
  String rua_dados = "";
  @observable
  String num_dados = "";
  @observable
  String bairro_dados = "";
  @observable
  int parametro_dados_endereco = 0; // 0 = encontrou endereço e bairro de entrega | 1 = não encontrou bairro para entrega | 2 = permissão de localização negada


  @action
  recuperar_dados_endereco(List<String> lista_bairros, BuildContext context) async{
    opacidade_progress_preencher_dados = 1;
    opacidade_texto_bt_preencher_dados = 0;
    opacidade_icone_preencher_dados = 0;
    var endereco = await helper.recupera_localizacao();
    if(endereco == null)
      {
        opacidade_progress_preencher_dados = 0;
        opacidade_texto_bt_preencher_dados = 1;
        opacidade_icone_preencher_dados = 0;
        parametro_dados_endereco = 2;
      }
    else{
      if(lista_bairros.contains(endereco[2])){//bairro existe na lista de entrega
        rua_dados = endereco[0];
        num_dados = endereco[1];
        seleciona_bairro(endereco[2]);
        parametro_dados_endereco = 0;
        opacidade_progress_preencher_dados = 0;
        opacidade_texto_bt_preencher_dados = 0;
        opacidade_icone_preencher_dados = 1;
        await Future.delayed(Duration(seconds: 1));
        opacidade_progress_preencher_dados = 0;
        opacidade_texto_bt_preencher_dados = 1;
        opacidade_icone_preencher_dados = 0;
      }
      else{
        parametro_dados_endereco = 1;
        opacidade_progress_preencher_dados = 0;
        opacidade_texto_bt_preencher_dados = 1;
        opacidade_icone_preencher_dados = 0;
      }
    }
  }

  @observable
  List<String> lista_bairros_dados = [""];

  @action
  preenche_bairros_dropdown_dados() async{
    Taxa taxa = Taxa();
    List<Taxa> lista_taxas = [];
    List<String> list_bairros = [""];
    lista_bairros_dados.clear();
    lista_taxas = await taxa.recuperar_taxas_firebase();
    for(int i = 0; i < lista_taxas.length; i++){
      list_bairros.add(lista_taxas[i].bairro);
    }
    lista_bairros_dados = list_bairros;
  }

  //ABA CARDAPIO

  @observable
  List<ItemCardapio> lista_itens_cardapio = [];
  @observable
  List<ItemCardapio> lista_itens_cardapio_mostrar = [];
  @observable
  List<ItemCardapio> lista_adicionais_cardapio = [];

  @action
  preenche_listas_cardapio() async{
    ItemCardapio itemCardapio = ItemCardapio();
    lista_itens_cardapio.clear();
    lista_adicionais_cardapio.clear();
    var retorno = await itemCardapio.recuperar_itens_cardapio();
    lista_itens_cardapio = retorno[0];
    lista_adicionais_cardapio = retorno[1];
    lista_itens_cardapio_mostrar = lista_itens_cardapio;
  }

  @observable
  List<Filtro> lista_filtro = [];

  @action
  preenche_lista_filtro() async{
    Filtro filtro = Filtro();
    lista_filtro.clear();
    var retorno = await filtro.recuperar_filtros_firebase();
    lista_filtro = retorno;
  }

  @observable
  bool icone_filtro_cardapio = false; //não pressionado = false | pressionado = true

  @action
  altera_icone_filtro_cardapio(){
    icone_filtro_cardapio = icone_filtro_cardapio == true ? false : true;
    if(icone_filtro_cardapio == true){
      controller_slide!.forward(from: 0);
      controller_size!.forward(from: 0);
    }
    else{
      limpa_filtro_aplicado();
      controller_slide!.reverse();
      controller_size!.reverse();
    }
  }
  @observable
  AnimationController? controller_slide;
  @observable
  AnimationController? controller_size;
  @observable
  Animation<Offset>? offsetAnimation_slide;
  @observable
  Animation<double>? animation_size;

  @action
  criar_animation_controller_filtro(TickerProvider vsync_mx){
    controller_slide = AnimationController(
        duration: const Duration(milliseconds: 500),
    vsync: vsync_mx);

    controller_size = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: vsync_mx,);

    offsetAnimation_slide = Tween<Offset>(
      begin: Offset(0.0, -2.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: controller_slide!,
      curve: Curves.easeInOutQuint,
    ));

    animation_size = CurvedAnimation(
      parent: controller_size!,
      curve: Curves.fastOutSlowIn,
    );
  }

  @observable
  Filtro filtro_aplicado_valor = Filtro();
  @observable
  List<ItemCardapio> lista_itens_filtrada = [];

  @action
  preenche_lista_itens_filtrada(Filtro filtro) {
    ItemCardapio item = ItemCardapio();
    filtro_aplicado_valor = filtro;
    lista_itens_filtrada.clear();
    for(int i=0; i < lista_itens_cardapio.length; i++){
      item = lista_itens_cardapio[i];
      if(item.grupo == filtro.grupo && item.tipo == filtro.tipo){
        lista_itens_filtrada.add(item);
      }
    }
    lista_itens_cardapio_mostrar = lista_itens_filtrada;
  }

  @action
  limpa_filtro_aplicado(){
    icone_filtro_cardapio = false;
    lista_itens_cardapio_mostrar = lista_itens_cardapio;
    lista_itens_filtrada.clear();
    filtro_aplicado_valor = Filtro();
  }

  @action
  limpa_filtro_valor_aplicado(){
    filtro_aplicado_valor = Filtro();
  }

  @observable
  var lista_itens_pedido = ObservableList<ItemPedido>();

  @action
  adiciona_item_ao_pedido(ItemPedido item_add){
    lista_itens_pedido.add(item_add);
  }

  @action
  atualizar_item_do_pedido(ItemPedido item_upd, int indice){
    lista_itens_pedido[indice] = item_upd;
  }

  @action
  remover_item_do_pedido(int indice){
    lista_itens_pedido.removeAt(indice);
  }

  @action
  limpar_pedido(){
    lista_itens_pedido.clear();
  }

  @observable
  num total_pedido = 0;

  @action
  calcular_total_pedido(){
    num _valor_total = 0;
    for(ItemPedido it in lista_itens_pedido)
    {
      _valor_total = _valor_total + it.valor_item;
    }
    total_pedido = _valor_total;
  }

}

