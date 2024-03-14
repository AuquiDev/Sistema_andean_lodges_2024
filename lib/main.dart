
import 'package:ausangate_op/provider/current_page.dart';
import 'package:ausangate_op/provider/provider_datacahe.dart';
import 'package:ausangate_op/provider/provider_empleados.rol_sueldo.dart';
import 'package:ausangate_op/provider/provider_t_asistencia.dart';
import 'package:ausangate_op/provider/provider_t_categoria_almacen.dart';
import 'package:ausangate_op/provider/provider_t_det.itinerario.dart';
import 'package:ausangate_op/provider/provider_t_det.restricciones.dart';
import 'package:ausangate_op/provider/provider_t_det.tipo_gasto.dart';
import 'package:ausangate_op/provider/provider_t_detalle_trabajo.dart';
import 'package:ausangate_op/provider/provider_t_detcand_paxguia.dart';
import 'package:ausangate_op/pages/splash_screen.dart';
import 'package:ausangate_op/provider/provider_t_empleado.dart';
import 'package:ausangate_op/provider/provider_t_entradas.dart';
import 'package:ausangate_op/provider/provider_t_productoapp.dart';
import 'package:ausangate_op/provider/provider_t_proveedorapp.dart';
import 'package:ausangate_op/provider/provider_t_report_pasajero.dart';
import 'package:ausangate_op/provider/provider_t_reporte_incidencias.dart';
import 'package:ausangate_op/provider/provider_t_salidas.dart';
import 'package:ausangate_op/provider/provider_t_ubicacion_almacen.dart';
import 'package:ausangate_op/provider/provider_v_gatos_grupo_salidas.dart';
import 'package:ausangate_op/provider/provider_v_historial_salidas_productos.dart';
import 'package:ausangate_op/provider/provider_v_inventario_general_productos.dart';
import 'package:ausangate_op/prueba_files/provider_prueba_files.dart';
import 'package:ausangate_op/utils/shared_global.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  SharedPrefencesGlobal prefs = SharedPrefencesGlobal();
  await prefs.initSharedPreferecnes();
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LayoutModel(),),
         //USUARIO CACHE 
        ChangeNotifierProvider(create: (context)=>UsuarioProvider(), lazy: false,),
        //INVENTARIO GENERAL 
        ChangeNotifierProvider(create: (context)=>ViewInventarioGeneralProductosProvider(),lazy: false,),
         //INVENTARIO ALERTA DE EXISTENCIAS 
        ChangeNotifierProvider(create: (context)=> ViewInventarioALERTAEXISTENCIASproductosProvider(), lazy: false,),
         //INVENTARIO ORDEN COMPRA
        ChangeNotifierProvider(create: (context)=> ViewInventarioORDENCOMPRAFVSTOCKproductosProvider(), lazy: false,),
         //GRUPOS GASTOS
        ChangeNotifierProvider(create: (context)=> ViewGastosGrupoSalidasProvider(), lazy: false,),
         //HISTORIAL SALIDAS GRUPOS
        ChangeNotifierProvider(create: (context)=> ViewHistorialSalidasProductosProvider(), lazy: false,),
        //TABLA PRODUCTOS 
        ChangeNotifierProvider(create: (context)=> TProductosAppProvider(), lazy: false,),
        //TABLA PRODUCTOS 
        ChangeNotifierProvider(create: (context)=> TUbicacionAlmacenProvider(), lazy: false,),
        //TABLA CATEGORIA 
        ChangeNotifierProvider(create: (context)=> TCategoriaProvider(), lazy:  false,),
        // TABLA PROVEEDOR
        ChangeNotifierProvider(create: (context)=> TProveedorProvider(), lazy: false,),
        // TABLA SALIDAS
        ChangeNotifierProvider(create: (context)=> TSalidasAppProvider(), lazy: false,),
        // TABLA ENTRADAS
        ChangeNotifierProvider(create: (context)=> TEntradasAppProvider(), lazy: false,),
        
         // TABLA EMPLEADO
        ChangeNotifierProvider(create: (context)=> TEmpleadoProvider(), lazy: false,),
               

        //ROLESUELDO empleado
        ChangeNotifierProvider(create: (context)=> TRolesSueldoProvider(), lazy: false,),

         // TABLA DETALLE DE TRABAJO
        ChangeNotifierProvider(create: (context)=> TDetalleTrabajoProvider(), lazy: false,),
         // TABLA Cantidad de pax guia DE TRABAJO
        ChangeNotifierProvider(create: (context)=> TCantidadPaxGuiaProvider(), lazy: false,),
        // TABLA ITINERARIO GRUPO  DE TRABAJO
        ChangeNotifierProvider(create: (context)=> TItinerarioProvider(), lazy: false,),
        // TABLA TipoGASTO GRUPO  DE TRABAJO
        ChangeNotifierProvider(create: (context)=> TTipoGastoProvider(), lazy: false,),
        // TABLA RESTRICCIONES GRUPO  DE TRABAJO
        ChangeNotifierProvider(create: (context)=> TRestriccionesProvider(), lazy: false,),
          // TABLA ASISTENCIA
        ChangeNotifierProvider(create: (context)=> TAsistenciaProvider(), lazy: false,),
         //TABLA reporte PAX 
        ChangeNotifierProvider(create: (context)=>TReportPasajeroProvider(), lazy: false,),
         //REPORTE INCIDENCIAS 
        ChangeNotifierProvider(create: (context)=>TReporteIncidenciasProvider(), lazy: false,),
        //PRUEBA FILES 
        ChangeNotifierProvider(create: (context)=>TPruebaFileProvider(), lazy: false,),
        
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Andean Lodges',
      theme: ThemeData(
        appBarTheme:   const AppBarTheme(
          centerTitle: false,
          // backgroundColor:secundaryblackCrema,
          iconTheme:  IconThemeData(
            color:Colors.black
          ),
        ),
      ),
      home:  const Scaffold(body: SplahScreen() ),//  SplahScreen()
    );
  }
}
