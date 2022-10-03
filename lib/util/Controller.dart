import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:sandra_foods_app/model/Cliente.dart';
import 'package:sandra_foods_app/telas/SemConexao.dart';

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
  preenche_bairros_dropdown_dados(BuildContext context) async{
    Taxa taxa = Taxa();
    List<Taxa> lista_taxas = [];
    List<String> list_bairros = [""];
    lista_bairros_dados.clear();
    lista_taxas = await taxa.recuperar_taxas_firebase(context);
    for(int i = 0; i < lista_taxas.length; i++){
      list_bairros.add(lista_taxas[i].bairro);
    }
    lista_bairros_dados = list_bairros;
  }
}
