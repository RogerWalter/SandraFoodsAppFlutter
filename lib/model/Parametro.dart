class Parametro{

  int _entrega = -1;
  int _retirada = -1;
  String _inicio = "";
  String _fim = "";
  int _motoboy = -1;
  int _manutencao = -1;
  int _seg = -1;
  int _ter = -1;
  int _qua = -1;
  int _qui = -1;
  int _sex = -1;
  int _sab = -1;
  int _dom = -1;

  Parametro.fromJson(Map <dynamic, dynamic> json)
  {
    _entrega = json['entrega'];
    _retirada = json['retirada'];
    _inicio = json['inicio'];
    _fim = json['fim'];
    _motoboy = json['motoboy'];
    _manutencao = json['manutencao'];
    _seg = json['seg'];
    _ter = json['ter'];
    _qua = json['qua'];
    _qui = json['qui'];
    _sex = json['sex'];
    _sab = json['sab'];
    _dom = json['dom'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['entrega'] = this._entrega;
    data['retirada'] = this._retirada;
    data['inicio'] = this._inicio;
    data['fim'] = this._fim;
    data['motoboy'] = this._motoboy;
    data['manutencao'] = this._manutencao;
    data['seg'] = this._seg;
    data['ter'] = this._ter;
    data['qua'] = this._qua;
    data['qui'] = this._qui;
    data['sex'] = this._sex;
    data['sab'] = this._sab;
    data['dom'] = this._dom;
    return data;
  }

  Parametro();

  int get dom => _dom;

  set dom(int value) {
    _dom = value;
  }

  int get sab => _sab;

  set sab(int value) {
    _sab = value;
  }

  int get sex => _sex;

  set sex(int value) {
    _sex = value;
  }

  int get qui => _qui;

  set qui(int value) {
    _qui = value;
  }

  int get qua => _qua;

  set qua(int value) {
    _qua = value;
  }

  int get ter => _ter;

  set ter(int value) {
    _ter = value;
  }

  int get seg => _seg;

  set seg(int value) {
    _seg = value;
  }

  int get manutencao => _manutencao;

  set manutencao(int value) {
    _manutencao = value;
  }

  int get motoboy => _motoboy;

  set motoboy(int value) {
    _motoboy = value;
  }

  String get fim => _fim;

  set fim(String value) {
    _fim = value;
  }

  String get inicio => _inicio;

  set inicio(String value) {
    _inicio = value;
  }

  int get retirada => _retirada;

  set retirada(int value) {
    _retirada = value;
  }

  int get entrega => _entrega;

  set entrega(int value) {
    _entrega = value;
  }
}