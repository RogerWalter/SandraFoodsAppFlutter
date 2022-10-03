import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:sandra_foods_app/abas/Cardapio.dart';
import 'package:sandra_foods_app/abas/Dados.dart';
import 'package:sandra_foods_app/abas/Pedido.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

const corLaranjaSF = const Color(0xffff6900);
const corMarromSF = const Color(0xff3d2314);

void main() {
  runApp(MaterialApp(
    home: TelaPrincipal()
  ));
}

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({Key? key}) : super(key: key);

  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}



class _TelaPrincipalState extends State<TelaPrincipal> with TickerProviderStateMixin{
  Cardapio cardapio = Cardapio();
  Dados dados = Dados();
  Pedido pedido = Pedido();
  int _selectedIndex = 1;

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  TabStyle _tabStyle = TabStyle.reactCircle;
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  void _toggleTab() {
    _selectedIndex = _tabController.index + 1;
    _tabController.animateTo(_selectedIndex);
  }


  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      dados,
      cardapio.build(context),
      pedido.build(context)
    ];
    
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/wallpaper_app.png'),
                  colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.05), BlendMode.modulate,),
                  fit: BoxFit.cover
              )
          ),
          child: _widgetOptions.elementAt(_selectedIndex),
        )
      ),
      bottomNavigationBar: StyleProvider(
        style: Style_BottomBar(),
        child: ConvexAppBar(
          items: <TabItem>[
            TabItem<Widget>(icon: Image.asset('images/dados_inativo.png'), title: 'Dados', activeIcon: Image.asset('images/dados_ativo.png')),
            TabItem<Widget>(icon: Image.asset('images/cardapio_inativo.png'), title: 'Cardápio', activeIcon: Image.asset('images/cardapio_ativo.png')),
            TabItem<Widget>(icon: Image.asset('images/pedido_inativo.png'), title: 'Pedido', activeIcon: Image.asset('images/pedido_ativo.png')),
          ],
          backgroundColor: Colors.white,
          activeColor: corLaranjaSF,
          elevation: 4.0,
          style: _tabStyle,
          onTap: (int i) => _onItemTapped(i),
          initialActiveIndex: 1,
        ),
      )
    );
  }
}
class Style_BottomBar extends StyleHook {
  @override
  double get activeIconSize => 50;

  @override
  double get activeIconMargin => 4;

  @override
  double get iconSize => 35;

  @override
  TextStyle textStyle(Color color, String) {
    return TextStyle(fontSize: 10, color: corMarromSF);
  }
}
