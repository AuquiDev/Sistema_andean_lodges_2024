import 'dart:async';


import 'package:ausangate_op/models/model_t_empleado.dart';
import 'package:ausangate_op/utils/shared_global.dart';
import 'package:flutter/material.dart';

class UsuarioProvider extends ChangeNotifier {
  TEmpleadoModel? _usuarioEncontrado;

  // Crear una instancia de SharedPrefencesGlobal
 SharedPrefencesGlobal sharedPrefs = SharedPrefencesGlobal();

 Future<void> cargarUsuario() async {
  final idRolesSueldoEmpleados = await sharedPrefs.getIdRolesSueldoEmpleados();
  final id = await sharedPrefs.getID();
  final nombre = await sharedPrefs.getNombre();
  final apellidoPaterno = await sharedPrefs.getApellidoPaterno();
  final apellidoMaterno = await sharedPrefs.getApellidoMaterno();
  final correo = await sharedPrefs.getCorreo();
  final rol = await sharedPrefs.getRol();
  final image = await sharedPrefs.getImage();
  final collectionId = await sharedPrefs.getCollectionID();

   _usuarioEncontrado = TEmpleadoModel(
    id: id,
    estado: true, 
    idRolesSueldoEmpleados:idRolesSueldoEmpleados.toString(), 
    nombre: nombre.toString(),
    apellidoPaterno: apellidoPaterno.toString(), 
    apellidoMaterno: apellidoMaterno.toString(), 
    sexo: '', 
    direccionResidencia: '', 
    lugarNacimiento: '', 
    correoElectronico: correo.toString(), 
    nivelEscolaridad: '', 
    estadoCivil: '', 
    modalidadLaboral: '', 
    cedula: 0, 
    cuentaBancaria: '', 
    telefono: '', 
    contrasena: '', 
    imagen: image,
    collectionId: collectionId,
    rol: rol.toString());
    
    notifyListeners();
 }
 

  // Obtener el usuario encontrado
  TEmpleadoModel? get usuarioEncontrado => _usuarioEncontrado;

  void setusuarioLogin (TEmpleadoModel usuario) async {
    _usuarioEncontrado = usuario;
    cargarUsuario();
    notifyListeners();
  }

  // Método para limpiar el usuario encontrado
  void limpiarusuarioEncontrado() {
    _usuarioEncontrado = null;
    notifyListeners();
  }


  //TOTAL SUMA ACUMULADO TOTAL DE UNA LISTA PDF: reporte la suma total de una lista pdf.
  double _total = 0;

  double get total => _total;

  void updateTotal(double value) {
    _total = value;
    notifyListeners();
    // Configura un temporizador para restablecer _total a 0 después de 3 segundos
      Timer(const Duration(seconds: 5), () {
        _total = 0;
        notifyListeners();
      });

  }
  //OFFLINE 
   //Activar el Modo Offline de Aplicativo: En esta seccion utilziaremos nuestro provider del servidor y provider de sqllite. 
  //haremos un condiconal en base al modo offline, si es false, usa del servidor y si es true usa el locla SQLlite
  bool _isOffline = false;

  bool get isOffline => _isOffline;

  void setIsOffline(bool value) {
    _isOffline = value;
    print(_isOffline);
    notifyListeners();
  }
 
}
