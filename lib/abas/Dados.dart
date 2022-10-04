import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sandra_foods_app/model/Cliente.dart';
import 'package:sandra_foods_app/util/Controller.dart';
import 'package:sandra_foods_app/util/Helper.dart';

const corLaranjaSF = const Color(0xffff6900);
const corMarromSF = const Color(0xff3d2314);
const corComp1SF = const Color(0xffffaa00);
const corComp2SF = const Color(0xff2fff00);
const corComp3SF = const Color(0xffd000ff);
const corComp4SF = const Color(0xffffea00);
const corAccentSF = const Color(0xff0059ff);

class Dados extends StatefulWidget {
  const Dados({Key? key}) : super(key: key);

  @override
  State<Dados> createState() => _DadosState();
}
class _DadosState extends State<Dados> {

  Controller controller_mobx = Controller();

  double _tamanho_fonte = 16.0;

  double _opacidade_nome = 1.0;
  TextEditingController _controller_nome = TextEditingController();
  FocusNode _foco_nome = FocusNode();

  double _opacidade_celular = 1.0;
  TextEditingController _controller_celular = TextEditingController();
  FocusNode _foco_celular = FocusNode();
  var mascaraCelular = new MaskTextInputFormatter(
      mask: '(##)#####-####',
      filter: { "#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy
  );

  double _opacidade_rua = 1.0;
  TextEditingController _controller_rua = TextEditingController();
  FocusNode _foco_rua = FocusNode();

  double _opacidade_numero = 1.0;
  TextEditingController _controller_numero = TextEditingController();
  FocusNode _foco_numero = FocusNode();

  double _opacidade_bairro = 1.0;
  TextEditingController _controller_bairro = TextEditingController();
  FocusNode _foco_bairro = FocusNode();

  double _opacidade_complemento = 1.0;
  TextEditingController _controller_complemento = TextEditingController();
  FocusNode _foco_complemento = FocusNode();

  Cliente _cliente = Cliente();
  Helper helper = Helper();

  var lista_bairros = [""];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<String> waitRetornoCliente() async{
      await controller_mobx.preenche_bairros_dropdown_dados(context);
      await preenche_dados_cliente();
      //await Future.delayed(Duration(seconds: 3));
      return "Carregado";
    }
    double largura = MediaQuery.of(context).size.width - 24;
    double altura = MediaQuery.of(context).size.height/6;
    //preenche_dados_cliente();
    final _formKey = GlobalKey<FormState>();
    _altera_escala();
    return FutureBuilder<String>(
      future: waitRetornoCliente(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){
        if(snapshot.hasData){
          return Scaffold(
            appBar: AppBar(
              title: Text('Dados', style: TextStyle(fontWeight: FontWeight.bold),),
              backgroundColor: corLaranjaSF,
              automaticallyImplyLeading: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            body: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                              child: Observer(
                                builder: (_){
                                  return AnimatedScale(
                                    scale: controller_mobx.escala_imagem_dados,
                                    duration: Duration(seconds: 1),
                                    curve: Curves.easeOutQuint,
                                    child: Container(
                                      height: altura,
                                      width: altura,
                                      child: Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Image.asset("images/img_dados.png"),
                                      ),
                                    ),
                                  );
                                },
                              )
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 8, 0, 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                AnimatedOpacity(
                                  opacity: _opacidade_nome,
                                  duration: Duration(seconds: 1),
                                  curve: Curves.linear,
                                  child:Container(
                                      width: largura*0.5,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: TextFormField(
                                          textAlign: TextAlign.left,
                                          controller: _controller_nome,
                                          focusNode: _foco_nome,
                                          keyboardType: TextInputType.name,
                                          textCapitalization: TextCapitalization.words,
                                          textInputAction: TextInputAction.next,
                                          maxLength: 40,
                                          cursorColor: corLaranjaSF,
                                          style: TextStyle(
                                              color: corMarromSF,
                                              fontSize: _tamanho_fonte,
                                              fontWeight: FontWeight.bold
                                          ),
                                          decoration: InputDecoration(
                                            isDense: true,
                                            floatingLabelBehavior: FloatingLabelBehavior.always,
                                            counterText: "",
                                            labelText: "Seu Nome",
                                            labelStyle: TextStyle(color: corMarromSF, fontWeight: FontWeight.normal),
                                            fillColor: Colors.transparent,
                                            hoverColor: corLaranjaSF,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(width: 2, color: corLaranjaSF),
                                              borderRadius: BorderRadius.circular(25),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(width: 2, color: corMarromSF),
                                              borderRadius: BorderRadius.circular(25),
                                            ),
                                            prefixIcon: Padding(padding: EdgeInsets.only(left: 4), child: Icon(Icons.person, color:corLaranjaSF, size: 20),),
                                            prefixIconConstraints: BoxConstraints(maxHeight: 25),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(width: 2, color: corAccentSF),
                                              borderRadius: BorderRadius.circular(25),
                                            ),
                                            errorStyle: TextStyle(
                                              color: corAccentSF,
                                              fontSize: 8,
                                              fontWeight: FontWeight.bold,
                                              backgroundColor: Colors.transparent,
                                              height: 0.1,
                                            ),
                                            focusedErrorBorder:  OutlineInputBorder(
                                              borderSide: const BorderSide(width: 2, color: corAccentSF),
                                              borderRadius: BorderRadius.circular(25),
                                            ),
                                            helperText: '',
                                            helperStyle: TextStyle(
                                              color: corAccentSF,
                                              fontSize: 8,
                                              fontWeight: FontWeight.bold,
                                              backgroundColor: Colors.transparent,
                                              height: 0.1,
                                            ),
                                          ),
                                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z -]"))],
                                          validator: (String? value){
                                            if(value?.length == 0 || value!.isEmpty || value == ""){
                                              return "Informe seu nome";
                                            }
                                          },
                                        ),
                                      )
                                  ),
                                ),
                                AnimatedOpacity(
                                  opacity: _opacidade_celular,
                                  duration: Duration(seconds: 1),
                                  curve: Curves.linear,
                                  child:Container(
                                    width: largura*0.5,
                                    child: TextFormField(
                                      controller: _controller_celular,
                                      focusNode: _foco_celular,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.done,
                                      inputFormatters: [mascaraCelular],
                                      maxLength: 40,
                                      cursorColor: corLaranjaSF,
                                      style: TextStyle(
                                          color: corMarromSF,
                                          fontSize: _tamanho_fonte,
                                          fontWeight: FontWeight.bold
                                      ),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                        counterText: "",
                                        labelText: "Seu Celular",
                                        labelStyle: TextStyle(color: corMarromSF, fontWeight: FontWeight.normal),
                                        hoverColor: corLaranjaSF,
                                        fillColor: Colors.transparent,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(width: 2, color: corLaranjaSF),
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(width: 2, color: corMarromSF),
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        prefixIcon: Padding(padding: EdgeInsets.only(left: 4), child: Icon(Icons.call, color:corLaranjaSF, size: 20),),
                                        prefixIconConstraints: BoxConstraints(maxHeight: 25),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(width: 2, color: corAccentSF),
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        errorStyle: TextStyle(
                                          color: corAccentSF,
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                          backgroundColor: Colors.transparent,
                                          height: 0.1,
                                        ),
                                        focusedErrorBorder:  OutlineInputBorder(
                                          borderSide: const BorderSide(width: 2, color: corAccentSF),
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        helperText: '',
                                        helperStyle: TextStyle(
                                          color: corAccentSF,
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                          backgroundColor: Colors.transparent,
                                          height: 0.1,
                                        ),
                                      ),
                                      validator: (String? value){
                                        if(value!.length == 0 || value == "" || value!.isEmpty){
                                          return "Informe seu celular";
                                        }
                                        if(value!.length < 14){
                                          return "Seu celular está incompleto";
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                AnimatedOpacity(
                                  opacity: _opacidade_rua,
                                  duration: Duration(seconds: 1),
                                  curve: Curves.linear,
                                  child:Container(
                                    width: largura*0.5,
                                    child: TextFormField(
                                      controller: _controller_rua,
                                      focusNode: _foco_rua,
                                      keyboardType: TextInputType.name,
                                      textCapitalization: TextCapitalization.words,
                                      textInputAction: TextInputAction.next,
                                      maxLength: 40,
                                      cursorColor: corLaranjaSF,
                                      style: TextStyle(
                                          color: corMarromSF,
                                          fontSize: _tamanho_fonte,
                                          fontWeight: FontWeight.bold
                                      ),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                        counterText: "",
                                        labelText: "Sua Rua",
                                        labelStyle: TextStyle(color: corMarromSF, fontWeight: FontWeight.normal),
                                        fillColor: Colors.transparent,
                                        hoverColor: corLaranjaSF,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(width: 2, color: corLaranjaSF),
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(width: 2, color: corMarromSF),
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        prefixIcon: Padding(padding: EdgeInsets.only(left: 4), child: Icon(Icons.directions_outlined, color:corLaranjaSF, size: 20),),
                                        prefixIconConstraints: BoxConstraints(maxHeight: 25),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(width: 2, color: corAccentSF),
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        errorStyle: TextStyle(
                                          color: corAccentSF,
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                          backgroundColor: Colors.transparent,
                                          height: 0.1,
                                        ),
                                        focusedErrorBorder:  OutlineInputBorder(
                                          borderSide: const BorderSide(width: 2, color: corAccentSF),
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        helperText: '',
                                        helperStyle: TextStyle(
                                          color: corAccentSF,
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                          backgroundColor: Colors.transparent,
                                          height: 0.1,
                                        ),
                                      ),
                                      validator: (String? value){
                                        if(value!.isEmpty && (_controller_numero.text.isNotEmpty || controller_mobx.bairro_selecionado_dropdown!.isNotEmpty)){
                                          return "Informe sua rua";
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                AnimatedOpacity(
                                  opacity: _opacidade_numero,
                                  duration: Duration(seconds: 1),
                                  curve: Curves.linear,
                                  child:Container(
                                    width: largura*0.5,
                                    child: TextFormField(
                                      controller: _controller_numero,
                                      focusNode: _foco_numero,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      maxLength: 4,
                                      cursorColor: corLaranjaSF,
                                      style: TextStyle(
                                          color: corMarromSF,
                                          fontSize: _tamanho_fonte,
                                          fontWeight: FontWeight.bold
                                      ),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                        counterText: "",
                                        labelText: "Nº da Casa",
                                        labelStyle: TextStyle(color: corMarromSF, fontWeight: FontWeight.normal),
                                        fillColor: Colors.transparent,
                                        hoverColor: corLaranjaSF,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(width: 2, color: corLaranjaSF),
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(width: 2, color: corMarromSF),
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        prefixIcon: Padding(padding: EdgeInsets.only(left: 4), child: Icon(Icons.home, color:corLaranjaSF, size: 20),),
                                        prefixIconConstraints: BoxConstraints(maxHeight: 25),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(width: 2, color: corAccentSF),
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        errorStyle: TextStyle(
                                          color: corAccentSF,
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                          backgroundColor: Colors.transparent,
                                          height: 0.1,
                                        ),
                                        focusedErrorBorder:  OutlineInputBorder(
                                          borderSide: const BorderSide(width: 2, color: corAccentSF),
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        helperText: '',
                                        helperStyle: TextStyle(
                                          color: corAccentSF,
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                          backgroundColor: Colors.transparent,
                                          height: 0.1,
                                        ),
                                      ),
                                      validator: (String? value){
                                        if(value!.isEmpty && (_controller_rua.text.isNotEmpty || controller_mobx.bairro_selecionado_dropdown!.isNotEmpty)){
                                          return "Informe o numero de sua casa";
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                            child: AnimatedOpacity(
                                opacity: _opacidade_bairro,
                                duration: Duration(seconds: 1),
                                curve: Curves.linear,
                                child: Observer(
                                  builder: (_){
                                    return DropdownButtonHideUnderline(
                                        child: Container(
                                          width: largura + 16,
                                          color: Colors.transparent,
                                          child:DropdownButtonFormField<String>(
                                            borderRadius: BorderRadius.circular(25),
                                            decoration: InputDecoration(
                                              isDense: true,
                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                              counterText: "",
                                              labelText: "Seu Bairro",
                                              labelStyle: TextStyle(color: corMarromSF, fontWeight: FontWeight.normal),
                                              fillColor: Colors.transparent,
                                              hoverColor: corLaranjaSF,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(width: 2, color: corLaranjaSF),
                                                borderRadius: BorderRadius.circular(25),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(width: 2, color: corMarromSF),
                                                borderRadius: BorderRadius.circular(25),
                                              ),
                                              prefixIcon: Padding(padding: EdgeInsets.only(left: 4), child: Icon(Icons.pin_drop_outlined, color:corLaranjaSF, size: 20),),
                                              prefixIconConstraints: BoxConstraints(maxHeight: 25),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(width: 2, color: corAccentSF),
                                                borderRadius: BorderRadius.circular(25),
                                              ),
                                              errorStyle: TextStyle(
                                                color: corAccentSF,
                                                fontSize: 8,
                                                fontWeight: FontWeight.bold,
                                                backgroundColor: Colors.transparent,
                                                height: 0.1,
                                              ),
                                              focusedErrorBorder:  OutlineInputBorder(
                                                borderSide: const BorderSide(width: 2, color: corAccentSF),
                                                borderRadius: BorderRadius.circular(25),
                                              ),
                                              helperText: '',
                                              helperStyle: TextStyle(
                                                color: corAccentSF,
                                                fontSize: 8,
                                                fontWeight: FontWeight.bold,
                                                backgroundColor: Colors.transparent,
                                                height: 0.1,
                                              ),
                                            ),
                                            isDense: true,
                                            onChanged: (String? novoValor) {
                                              controller_mobx.seleciona_bairro(novoValor);
                                            },
                                            items: controller_mobx.lista_bairros_dados.map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            itemHeight: null,
                                            value: controller_mobx.bairro_selecionado_dropdown,
                                            validator: (value){
                                              if((controller_mobx.bairro_selecionado_dropdown == "") && (_controller_numero.text.isNotEmpty || _controller_rua.text.isNotEmpty)){
                                                return "Informe seu bairro";
                                              }
                                            },
                                            style: TextStyle(
                                                color: corMarromSF,
                                                fontSize: _tamanho_fonte,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        )
                                    );
                                  },
                                )
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                            child: AnimatedOpacity(
                              opacity: _opacidade_complemento,
                              duration: Duration(seconds: 1),
                              curve: Curves.linear,
                              child:Container(
                                width: largura + 16,
                                child: TextFormField(
                                  controller: _controller_complemento,
                                  focusNode: _foco_complemento,
                                  keyboardType: TextInputType.name,
                                  textCapitalization: TextCapitalization.words,
                                  textInputAction: TextInputAction.done,
                                  maxLength: 100,
                                  cursorColor: corLaranjaSF,
                                  style: TextStyle(
                                      color: corMarromSF,
                                      fontSize: _tamanho_fonte,
                                      fontWeight: FontWeight.bold
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    counterText: "",
                                    labelText: "Informações para facilitar a entrega",
                                    labelStyle: TextStyle(color: corMarromSF, fontWeight: FontWeight.normal),
                                    fillColor: Colors.transparent,
                                    hoverColor: corLaranjaSF,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(width: 2, color: corLaranjaSF),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(width: 2, color: corMarromSF),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    prefixIcon: Padding(padding: EdgeInsets.only(left: 4), child: Icon(Icons.info_outline, color:corLaranjaSF, size: 20),),
                                    prefixIconConstraints: BoxConstraints(maxHeight: 25),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(width: 2, color: corAccentSF),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    errorStyle: TextStyle(
                                      color: corAccentSF,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                      backgroundColor: Colors.transparent,
                                      height: 0.1,
                                    ),
                                    focusedErrorBorder:  OutlineInputBorder(
                                      borderSide: const BorderSide(width: 2, color: corAccentSF),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    helperText: '',
                                    helperStyle: TextStyle(
                                      color: corAccentSF,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                      backgroundColor: Colors.transparent,
                                      height: 0.1,
                                    ),
                                  ),
                                  validator: (String? value){
                                    if(value!.isEmpty && (_controller_numero.text == "0" || _controller_numero.text == "00" || _controller_numero.text == "000" ||_controller_numero.text == "0000")){
                                      return "Para casas sem número, é necessário informar algum tipo de referência para entrega";
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                              child:Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 2, color: corMarromSF),
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.transparent
                                  ),
                                  width: largura*0.6,
                                  height: 40,
                                  child: Observer(
                                    builder: (_){
                                      return TextButton(
                                          onPressed: () async{
                                            await controller_mobx.recuperar_dados_endereco(controller_mobx.lista_bairros_dados, context);
                                            _controller_rua.text = controller_mobx.rua_dados;
                                            _controller_numero.text = controller_mobx.num_dados;
                                            if(_controller_rua.text.isNotEmpty){
                                              _foco_numero.requestFocus();
                                              _controller_numero.selection = TextSelection(baseOffset: 0, extentOffset: _controller_numero.text.length);
                                            }
                                            else{
                                              if(controller_mobx.parametro_dados_endereco == 1){
                                                String texto_dialogo = 'Lamentamos, mas não realizamos entregas para seu bairro.\n\nMas sinta-se a vontade pra pedir e vir nos fazer uma visita para buscar seu pedido. :)';
                                                helper.gerar_dialogo(context, texto_dialogo);
                                              }
                                              if(controller_mobx.parametro_dados_endereco == 2){
                                                String texto_dialogo = 'Para que o preencimento automático funcione, é necessário permitir acesso à sua localização\n\nPressione novamente o botão e permita acesso ao seu local';
                                                helper.gerar_dialogo(context, texto_dialogo);
                                              }
                                            }
                                          },
                                          child: Stack(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.all(0),
                                                child: Observer(
                                                  builder: (_){
                                                    return AnimatedOpacity(
                                                      duration: Duration(milliseconds: 1),
                                                      opacity: controller_mobx.opacidade_texto_bt_preencher_dados,
                                                      curve: Curves.linear,
                                                      child: Center(
                                                        child: Text("Preenche pra mim!".toUpperCase(),
                                                          style: TextStyle(
                                                              color: corMarromSF,
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w700
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      )
                                                    );
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(0),
                                                child: Align(
                                                    alignment: Alignment.center,
                                                    child: Observer(
                                                      builder: (_){
                                                        return AnimatedOpacity(
                                                            duration: Duration(milliseconds: 1),
                                                            opacity: controller_mobx.opacidade_progress_preencher_dados,
                                                            curve: Curves.linear,
                                                            child: SizedBox(
                                                              height: 20,
                                                              width: 20,
                                                              child: CircularProgressIndicator(
                                                                color: corMarromSF,
                                                              )
                                                            )
                                                          //child: Icon(Icons.emoji_emotions_outlined, color: Colors.white)
                                                        );
                                                      },
                                                    )
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(0),
                                                child: Observer(
                                                  builder: (_){
                                                    return AnimatedOpacity(
                                                        duration: Duration(milliseconds: 1),
                                                        opacity: controller_mobx.opacidade_icone_preencher_dados,
                                                        curve: Curves.linear,
                                                        child: Center(
                                                          child: Icon(Icons.emoji_emotions,
                                                            color: corMarromSF,
                                                            size: 24,
                                                          )
                                                        )
                                                      //child: Icon(Icons.emoji_emotions_outlined, color: Colors.white)
                                                    );
                                                  },
                                                ),
                                              )
                                            ],
                                          )
                                      );
                                    },
                                  )
                              )
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                              child: SizedBox(
                                  height: 35,
                                  width:35,
                                  child: ElevatedButton(
                                    child: Icon(Icons.help_outline, size: 30, color: Colors.white,),
                                    onPressed: (){
                                      String texto_dialogo = 'Se deseja retirar seu pedido, informe apenas seu nome e seu celular\n\nSe sua casa não possuir número, informe 0 e um ponto de referência para a entrega\n\nSe seu bairro não aparece para ser selecionado, é porque infelizmente não realizamos entregas para lá';
                                      helper.gerar_dialogo(context, texto_dialogo);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      primary: corLaranjaSF,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                  )
                              )
                          ),
                          Expanded(
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                    padding: EdgeInsets.only(bottom: 24),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                            margin: EdgeInsets.all(8),
                                            width: largura - 16,
                                            height: 50,
                                            child: Observer(
                                              builder: (_){
                                                return ElevatedButton(
                                                    onPressed: () async{
                                                      if(_formKey.currentState!.validate())
                                                      {
                                                        Cliente salvar = cria_objeto_cliente();
                                                        await controller_mobx.salvar_dados_cliente(salvar);
                                                        await preenche_dados_cliente();
                                                      }
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      padding: EdgeInsets.zero,
                                                      primary: controller_mobx.cor_botao_salvar_dados,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(25),
                                                      ),
                                                    ),
                                                    child: Stack(
                                                      children: <Widget>[
                                                        Align(
                                                          alignment: Alignment.center,
                                                          child: Observer(
                                                            builder: (_){
                                                              return AnimatedOpacity(
                                                                duration: Duration(milliseconds: 1),
                                                                opacity: controller_mobx.opacidade_texto_bt,
                                                                curve: Curves.linear,
                                                                child: Text("Salvar Dados".toUpperCase(),
                                                                  style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 16,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        Align(
                                                            alignment: Alignment.center,
                                                            child: Observer(
                                                              builder: (_){
                                                                return AnimatedOpacity(
                                                                    duration: Duration(milliseconds: 1),
                                                                    opacity: controller_mobx.opacidade_progress,
                                                                    curve: Curves.linear,
                                                                    child: CircularProgressIndicator(
                                                                      color: Colors.white,
                                                                    )
                                                                  //child: Icon(Icons.emoji_emotions_outlined, color: Colors.white)
                                                                );
                                                              },
                                                            )
                                                        ),
                                                        Align(
                                                            alignment: Alignment.center,
                                                            child: Observer(
                                                              builder: (_){
                                                                return AnimatedOpacity(
                                                                    duration: Duration(milliseconds: 1),
                                                                    opacity: controller_mobx.opacidade_icone_salvo,
                                                                    curve: Curves.linear,
                                                                    child: Icon(Icons.check_circle,
                                                                      color: Colors.white,
                                                                      size: 50,
                                                                    )
                                                                  //child: Icon(Icons.emoji_emotions_outlined, color: Colors.white)
                                                                );
                                                              },
                                                            )
                                                        ),
                                                      ],
                                                    )
                                                );
                                              },
                                            )
                                        )
                                      ],
                                    )
                                )
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            resizeToAvoidBottomInset: false,
          );
        }else if(snapshot.hasError){
          return Text('Erro');
        }else{
          return Scaffold(
            appBar: AppBar(
              title: Text('Dados', style: TextStyle(fontWeight: FontWeight.bold),),
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
  _altera_escala(){
    if(controller_mobx.escala_imagem_dados == 1.2)
      controller_mobx.alterar_escala(0.8);
    else
      controller_mobx.alterar_escala(1.2);
    Future.delayed(Duration(seconds: 1)).then((value) => _altera_escala());
  }

  preenche_dados_cliente() async{
    _cliente = await _cliente.recupera_dados_cliente();

    _controller_nome.text = _cliente.nome;
    _controller_celular.text = _cliente.celular;
    _controller_rua.text = _cliente.rua;
    _controller_numero.text = _cliente.numero;
    controller_mobx.seleciona_bairro(_cliente.bairro);
    _controller_complemento.text = _cliente.referencia;
  }

  Cliente cria_objeto_cliente(){
    Cliente retorno = Cliente();
    retorno.nome = _controller_nome.text;
    retorno.celular = _controller_celular.text;
    retorno.rua = _controller_rua.text;
    retorno.numero = _controller_numero.text;
    retorno.bairro = controller_mobx.bairro_selecionado_dropdown.toString();
    retorno.referencia = _controller_complemento.text;
    return retorno;
  }
}
