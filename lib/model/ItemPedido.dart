import 'package:sandra_foods_app/model/ItemCardapio.dart';

class ItemPedido{
  int _id_item = 0;
  String _id_pedido = "";
  String _nome_item = "";
  String _desc_item = "";
  List<ItemCardapio> _adicionais_item = [];
  String _obs_item = "";
  num _valor_item = 0.0;
  int _qtd_item = 0;
  int _grupo_item = 0;
  int _tipo_item = 0;

  ItemPedido.fromJson(Map <dynamic, dynamic> json)
  {
    _id_item = json['id_item'];
    _id_pedido = json['id_pedido'];
    _nome_item = json['nome_item'];
    _desc_item = json['desc_item'];
    _adicionais_item = json['adicionais_item'];
    _obs_item = json['obs_item ='];
    _valor_item = json['valor_item'];
    _qtd_item = json['qtd_item'];
    _grupo_item = json['grupo_item'];
    _tipo_item = json['tipo_item'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_item'] = this._id_item;
    data['id_pedido'] = this._id_pedido;
    data['nome_item'] = this._nome_item;
    data['desc_item'] = this._desc_item;
    data['adicionais_item'] = this._adicionais_item;
    data['obs_item'] = this._obs_item;
    data['valor_item'] = this._valor_item;
    data['qtd_item'] = this._qtd_item;
    data['grupo_item'] = this._grupo_item;
    data['tipo_item'] = this._tipo_item;
    return data;
  }

  ItemPedido();

  int get grupo_item => _grupo_item;

  set grupo_item(int value) {
    _grupo_item = value;
  }

  String get nome_item => _nome_item;

  set nome_item(String value) {
    _nome_item = value;
  }

  int get qtd_item => _qtd_item;

  set qtd_item(int value) {
    _qtd_item = value;
  }

  num get valor_item => _valor_item;

  set valor_item(num value) {
    _valor_item = value;
  }

  String get obs_item => _obs_item;

  set obs_item(String value) {
    _obs_item = value;
  }

  List<ItemCardapio> get adicionais_item => _adicionais_item;

  set adicionais_item(List<ItemCardapio> value) {
    _adicionais_item = value;
  }

  String get desc_item => _desc_item;

  set desc_item(String value) {
    _desc_item = value;
  }

  String get id_pedido => _id_pedido;

  set id_pedido(String value) {
    _id_pedido = value;
  }

  int get id_item => _id_item;

  set id_item(int value) {
    _id_item = value;
  }

  int get tipo_item => _tipo_item;

  set tipo_item(int value) {
    _tipo_item = value;
  }
}