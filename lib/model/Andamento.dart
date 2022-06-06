class Andamento
{
  String _id = "";
  String _status = "";
  String _data = "";
  String _cliente = "";
  String _valor = "";
  String _endereco = "";
  String _enderecoPesquisa = "";

  Andamento.fromJson(Map <dynamic, dynamic> json)
  {
    _id = json['id'];
    _status = json['status'];
    _data = json['data'];
    _cliente = json['cliente'];
    _valor = json['valor'];
    _endereco = json['endereco'];
    _enderecoPesquisa = json['enderecoPesquisa'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['status'] = this._status;
    data['data'] = this._data;
    data['cliente'] = this._cliente;
    data['valor'] = this._valor;
    data['endereco'] = this._endereco;
    data['enderecoPesquisa'] = this._enderecoPesquisa;
    return data;
  }

  Andamento (){}

  String get enderecoPesquisa => _enderecoPesquisa;

  set enderecoPesquisa(String value) {
    _enderecoPesquisa = value;
  }

  String get endereco => _endereco;

  set endereco(String value) {
    _endereco = value;
  }

  String get valor => _valor;

  set valor(String value) {
    _valor = value;
  }

  String get cliente => _cliente;

  set cliente(String value) {
    _cliente = value;
  }

  String get data => _data;

  set data(String value) {
    _data = value;
  }

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}