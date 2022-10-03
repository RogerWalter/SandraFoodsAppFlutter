import 'package:shared_preferences/shared_preferences.dart';

class Cliente{
  String _nome = "";
  String _celular = "";
  String _rua = "";
  String _numero = "";
  String _bairro = "";
  String _referencia = "";

  Cliente();

  Cliente.fromJson(Map <dynamic, dynamic> json)
  {
    _nome = json['nome'];
    _celular = json['celular'];
    _rua = json['rua'];
    _numero = json['numero'];
    _bairro = json['bairro'];
    _referencia = json['referencia'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this._nome;
    data['celular'] = this._celular;
    data['rua'] = this._rua;
    data['numero'] = this._numero;
    data['bairro'] = this._bairro;
    data['referencia'] = this._referencia;
    return data;
  }

  String get referencia => _referencia;

  set referencia(String value) {
    _referencia = value;
  }

  String get bairro => _bairro;

  set bairro(String value) {
    _bairro = value;
  }

  String get numero => _numero;

  set numero(String value) {
    _numero = value;
  }

  String get rua => _rua;

  set rua(String value) {
    _rua = value;
  }

  String get celular => _celular;

  set celular(String value) {
    _celular = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }


  Future<Cliente> recupera_dados_cliente() async{
    Cliente cliente = Cliente();
    final prefs = await SharedPreferences.getInstance();
    cliente._nome = prefs.getString("nome").toString();
    cliente._celular = prefs.getString("celular").toString();
    cliente._rua = prefs.getString("rua").toString();
    cliente._numero = prefs.getString("numero").toString();
    cliente._bairro = prefs.getString("bairro").toString();
    cliente._referencia = prefs.getString("referencia").toString();
    return cliente;
  }

  salvar_dados(Cliente cliente_salvar) async
  {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("nome", cliente_salvar.nome);
    prefs.setString("celular", cliente_salvar.celular);
    prefs.setString("rua", cliente_salvar.rua);
    prefs.setString("numero", cliente_salvar.numero);
    prefs.setString("bairro", cliente_salvar.bairro);
    prefs.setString("referencia", cliente_salvar.referencia);
    //prefs.setString("primeiroacesso", "0");
    //prefs.setString("ultimoacesso", dataAtual);
  }

  List validar_dados(Cliente cliente_salvar){
    bool retorno = false;
    String msg = "";

    if(cliente_salvar.nome.isNotEmpty && cliente_salvar.nome != ""){
      if(cliente_salvar.celular.isNotEmpty && cliente_salvar.celular.length == 14){
        if(cliente_salvar.rua.isNotEmpty && cliente_salvar.rua != ""){

        }
      }
      else{
        retorno = false;
        msg = "Por gentileza, verifique seu celular pessoa incrível!";
      }
    }
    else{
      retorno = false;
      msg = "Por gentileza, informe seu nome pessoa querida!";
    }

    return [retorno, msg];
  }
}