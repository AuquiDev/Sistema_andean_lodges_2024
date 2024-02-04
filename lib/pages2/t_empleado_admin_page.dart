// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'package:ausangate_op/login_page.dart';
import 'package:ausangate_op/models/model_t_empleado.dart';
import 'package:ausangate_op/pages2/t_empleado_details_page.dart';
import 'package:ausangate_op/provider/provider_datacahe.dart';
import 'package:ausangate_op/provider/provider_empleados.rol_sueldo.dart';
import 'package:ausangate_op/provider/provider_t_empleado.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:ausangate_op/utils/routes_page_admin.dart';
import 'package:ausangate_op/utils/shared_global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AdministracionPage extends StatefulWidget {
  const AdministracionPage(
      {super.key,
      required this.showAppBar,
      required ScrollController scrollController})
      : _scrollController = scrollController;
  final ScrollController _scrollController;
  final bool showAppBar;

  @override
  State<AdministracionPage> createState() => _AdministracionPageState();
}

class _AdministracionPageState extends State<AdministracionPage> {
 


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Bloquear la rotación de la pantalla
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, // Solo retrato
    ]);
  }

  @override
  void dispose() {
    // Restaurar las preferencias de orientación cuando la página se destruye
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

//TITLE SELECT UBICACION
  String title = 'Lista General';

 

  

  @override
  Widget build(BuildContext context) {
    
    final iduser = Provider.of<UsuarioProvider>(context).usuarioEncontrado;

     final listaUsuario = Provider.of<TEmpleadoProvider>(context).listaEmpleados;
  
    TEmpleadoModel obtenerusario() {
      for (var user in listaUsuario) {
        if (user.id == iduser!.id) {
          return user;
        }
        
      }
      throw 'Error Ningun Dato';
    }
    final user = obtenerusario();
    final listaRolesSueldo =  Provider.of<TRolesSueldoProvider>(context).listRolesSueldo;

    List<dynamic> obtenerRolesSueldo(String idrolesSueldo) {
      for (var data in listaRolesSueldo) {
        if (data.id == user.idRolesSueldoEmpleados) {
          return [
            data.cargoPuesto,
            data.sueldoBase,
            data.tipoMoneda,
            data.tipoCalculoSueldo,
          ];
        }
      }
      return ['', '', '', ''];
    }

    String cargopuesto = obtenerRolesSueldo(user.idRolesSueldoEmpleados)[0];
    double sueldoBase = obtenerRolesSueldo(user.idRolesSueldoEmpleados)[1];
    String tipoMoneda = obtenerRolesSueldo(user.idRolesSueldoEmpleados)[2];
    String tipoCalculoSueldo = obtenerRolesSueldo(user.idRolesSueldoEmpleados)[3];
    return Expanded(
      child: Scaffold(
        appBar: widget.showAppBar
            ? AppBar(
               leading: const Icon(Icons.circle, color: Colors.transparent,),
                leadingWidth: 0,
                toolbarHeight: 100,
                title: user != null
                    ? GestureDetector(
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailsEmpleadospage(
                                      e: user,
                                      cargopuesto: cargopuesto,
                                      sueldoBase: sueldoBase,
                                      tipoMoneda: tipoMoneda,
                                      tipoCalculoSueldo: tipoCalculoSueldo)));
                        },
                        child: Row(
                          children: [
                            ImageLoginUser(user: user, size: 60),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  H2Text(
                                    text:
                                        '${user.nombre} ${user.apellidoPaterno} ${user.apellidoMaterno}',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  H2Text(
                                    text: cargopuesto,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  H2Text(
                                    text: user.rol,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
              )
            : null,
        body: ContentBodyAdmin(scrollController: widget._scrollController),
        endDrawer: const DrawerAdminApp(),
      ),
    );
  }
}

class DrawerAdminApp extends StatelessWidget {
  const DrawerAdminApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<UsuarioProvider>(context);
    bool isoffline = dataProvider.isOffline;
     
    return Drawer(
      backgroundColor: Colors.transparent,
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * .2, right: 10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      onTap: () {},
                      leading: const Icon(
                        Icons.print,
                      ),
                      title: const H2Text(
                        text: 'Activar Modo offline',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    ListTile(
                      onTap: () {},
                      leading: const Icon(
                        Icons.backup,
                      ),
                      title: const H2Text(
                        text: 'Activar Modo offline',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    
                    SwitchListTile.adaptive(
                      title: const H2Text(text: 'Modo Offline', fontSize: 14,fontWeight: FontWeight.w800,),
                      subtitle: H2Text(text: isoffline ? 'Activado' : ' Desactivado', fontSize: 12,),
                      value: isoffline,
                      onChanged: (value){
                      //  Provider.of<DBProductoAppProvider>(context, listen: false).initDatabase();
                       Provider.of<UsuarioProvider>(context, listen: false).setIsOffline(value);
                      })
                  ],
                ),
              ),
              ListTile(
                onTap: () async {

                  SharedPrefencesGlobal sharedPrefs = SharedPrefencesGlobal();
                   // Luego, llama al método setLoggedIn en esa instancia
                  await sharedPrefs.logout(context);  
                  await  SharedPrefencesGlobal().deleteImage();
                   await  SharedPrefencesGlobal().deleteNombre();
                  // Navigator.pushAndRemoveUntil(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const InitialPageHome()),
                  //     (route) => false);
                  

                },
                leading: const Icon(
                  Icons.output_sharp,
                  color: Colors.red,
                ),
                title: const H2Text(
                  text: 'Cerrar sesión',
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContentBodyAdmin extends StatelessWidget {
  const ContentBodyAdmin({
    super.key,
    required ScrollController scrollController,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    final List<Routes> routes = RoutesFactory.createRoutes();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _scrollController,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 2.5),
                itemCount: routes.length,
                itemBuilder: (BuildContext context, int index) {
                  final e = routes[index];
                  return e.buildCard(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
