import 'package:firebase_database/firebase_database.dart';

class ItemCardapio{
  int _id_item = 0;
  String _desc_item = "";
  String _nome = "";
  num _valor = 0;
  int _tipo = 0;
  int _grupo = 0;

  ItemCardapio.fromJson(Map <dynamic, dynamic> json)
  {
    _id_item = json['id'];
    _nome = json['nome'];
    _desc_item = json['descricao'];
    _valor = json['valor'];
    _tipo = json['tipo'];
    _grupo = json['grupo'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id_item;
    data['nome'] = this._nome;
    data['descricao'] = this._desc_item;
    data['valor'] = this._valor;
    data['tipo'] = this._tipo;
    data['grupo'] = this._grupo;
    return data;
  }

  ItemCardapio();

  int get grupo => _grupo;

  set grupo(int value) {
    _grupo = value;
  }

  int get tipo => _tipo;

  set tipo(int value) {
    _tipo = value;
  }

  num get valor => _valor;

  set valor(num value) {
    _valor = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get desc_item => _desc_item;

  set desc_item(String value) {
    _desc_item = value;
  }

  int get id_item => _id_item;

  set id_item(int value) {
    _id_item = value;
  }

  recuperar_itens_cardapio() async{
    List<ItemCardapio> _listaItens = [];
    List<ItemCardapio> _listaAdicionais = [];
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child("cardapio").get();
    if (snapshot.exists) {
      final json = snapshot.value as Map<dynamic, dynamic>;
      for(DataSnapshot ds in snapshot.children)
      {
        ItemCardapio _itemLista = ItemCardapio();
        final json = ds.value as Map<dynamic, dynamic>;
        _itemLista = ItemCardapio.fromJson(json);
        if(_itemLista.grupo != 0)
          _listaItens.add(_itemLista);
        else
          _listaAdicionais.add(_itemLista);
      }
    }
    return [_listaItens, _listaAdicionais];
  }
}
