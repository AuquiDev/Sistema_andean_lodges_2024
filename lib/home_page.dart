// ignore_for_file: prefer_adjacent_string_concatenation

import 'package:ausangate_op/login_page.dart';
import 'package:ausangate_op/models/model_t_empleado.dart';
import 'package:ausangate_op/pages2/gastos_page_grupo.dart';
import 'package:ausangate_op/pages2/t_empleado_admin_page.dart';
import 'package:ausangate_op/pages2/t_movimientos_entradas.dart';
import 'package:ausangate_op/pages2/t_movimientos_salidas.dart';
import 'package:ausangate_op/pages2/t_productos_page.dart';
import 'package:ausangate_op/provider/provider_datacahe.dart';
import 'package:ausangate_op/utils/shared_global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  final ScrollController _scrollController = ScrollController();
  bool showAppBar = true;

   

  void _onScroll() {
    //devulve el valor del scrollDirection.
    setState(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        //Scroll Abajo
        showAppBar = true;
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        //Scroll Arriba
        showAppBar = false;
      }
    });
  }
  // Crear una instancia de SharedPrefencesGlobal
 SharedPrefencesGlobal sharedPrefs = SharedPrefencesGlobal();
  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    sharedPrefs.setLoggedIn();  // Luego, llama al método setLoggedIn en esa instancia
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  int currentindex = 0;
 

  @override
  Widget build(BuildContext context) {
  

    List<Widget> pages = [
     

      GastosGruposPage(
        scrollController: _scrollController,
        showAppBar: showAppBar,
      ), 
      
      MovimientosPageEntrada(
        scrollController: _scrollController,
        showAppBar: showAppBar,
        ),
        
      MovimientosPageSalida(
         scrollController: _scrollController,
        showAppBar: showAppBar,
      ),

      //GESTION ALMACEN ENTRADAS Y SALIDAS
       ProductosPage(
        scrollController: _scrollController,
        showAppBar: showAppBar,
      ),
    //  //GESTION 
    //   GrupoDetalleTrabajoPage(
    //     scrollController: _scrollController,
    //     showAppBar: showAppBar,
    //   ),
      AdministracionPage(showAppBar: showAppBar, scrollController: _scrollController)
    ];

    return Scaffold(
      extendBody: true,
      body: Column(
        children: [pages[currentindex]],
      ),
      //CENTRAMOS el Boton FloatingActionButton
      bottomNavigationBar: showAppBar ? _botonNavigationBar() : null,
    );
  }

  Widget _botonNavigationBar() {
     TEmpleadoModel? user =
        Provider.of<UsuarioProvider>(context).usuarioEncontrado;
    return Container(
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(offset: Offset(0, -5), blurRadius: 3, color: Colors.black12)
      ]),
      child: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 0,
          onTap: (int index) {
            setState(() {
              currentindex = index;
            });
          },
          currentIndex: currentindex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.indigo,
          unselectedItemColor: Colors.black26,
          showSelectedLabels: true, // Muestra etiqueta del item seleccionado
          showUnselectedLabels: false, //Muestra Etq. de los item NO seleccioando
          items: <BottomNavigationBarItem>[
           
            const BottomNavigationBarItem(
                label: 'Grupos',
                icon: Icon(Icons.lan_outlined),
                // activeIcon: Icon(Icons.view_compact_sharp),
                tooltip:'La Vista Integral de los Grupos y sus Gastos Revela el Valor Monetario Total de los Recursos Asignados durante las Salidas.'),
          
            const BottomNavigationBarItem(
                label: 'Entradas',
                icon: Icon(Icons.shopping_cart_sharp),
                tooltip:
                    'Registro y seguimiento de grupos de pasajeros programados este mes.'),
            const BottomNavigationBarItem(
                label: 'Salidas',
                icon: Icon(Icons.shopping_cart_checkout_outlined),
                tooltip:
                    'Sección principal con revisión de perfil y funcionalidades según permisos.'),

              const BottomNavigationBarItem(
                label: 'Almacén',
                icon: Icon(Icons.home_filled),
                tooltip:
                    'Registro y gestión de almacén: Permite registrar nuevos artículos, asignarles entradas o realizar descuentos de existencias.'),
            // const BottomNavigationBarItem(
            //     label: 'Files',
            //     icon: Icon(Icons.work),
            //     tooltip:
            //         'Registro de grupos confirmados para operación que requerirán asignación de recursos del almacén.' + 
            //         'Esta relacionadas con la cantidad de pasajeros, cantidad de dias y noches entre otros.'),

             BottomNavigationBarItem(
                label: user == null ? 'Usuario' : user.nombre,
                icon:user == null ? const Icon(Icons.account_circle_sharp) :
                ImageLoginUser(user: user, size: 30,),
                tooltip:
                    'Sección principal con revisión de perfil y funcionalidades según permisos.'
                ),
          ]),
    );
  }

  
}

