// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:ausangate_op/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefencesGlobal {
  //Vamos utilizar un singleton para utilizar una sola instancia
  //HEMOS creado singleton para llamar una sola vez esta clase.
  static final SharedPrefencesGlobal _instance = SharedPrefencesGlobal._();

  SharedPrefencesGlobal._();//Constructor privado 

  factory SharedPrefencesGlobal(){
    return _instance;
  }
  //Instancia de sharedPreferecnes 
  late SharedPreferences _pref;
  //CREAMSO un metodo initsharedpreferences para  inicializar una sola vez el sharedpreferences 
  Future<void> initSharedPreferecnes() async { 
    _pref = await SharedPreferences.getInstance();
  }


  
    // Función para obtener el estado de inicio de sesión desde shared preferences
  Future<bool> getLoggedIn() async {
    // Obtiene el valor de isLoggedIn, si no existe devuelve false por defecto
    return _pref.getBool('isLoggedIn') ?? false;
  }
  
   // Función para cerrar sesión
  Future<void> logout(BuildContext context) async {
    await _pref.setBool('isLoggedIn', false);
    // Redirige a la página de inicio de sesión después de cerrar sesión
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }
   // Función para guardar el estado de inicio de sesión en shared preferences
  Future<void> setLoggedIn() async {
   
    await _pref.setBool('isLoggedIn', true);
  }



//USUARIOENCONTRADO 
   //ID 
  Future<String?> getID() async {
    return _pref.getString('idKey');
  }
  Future<void> saveID(String  text) async {
    await _pref.setString('idKey', text);
    print('Campo idKey guardado $text');
  }

  
   // Función para obtener el campo id_rolesSueldo_Empleados desde shared preferences
  Future<String?> getIdRolesSueldoEmpleados() async {
    return _pref.getString('idRolesSueldoEmpleados');
  }

   // Función para guardar el campo id_rolesSueldo_Empleados en shared preferences
  Future<void> saveIdRolesSueldoEmpleados(String  idRolesSueldoEmpleados) async {
    await _pref.setString('idRolesSueldoEmpleados', idRolesSueldoEmpleados);
    print('Campo idRolesSueldoEmpleados guardado $idRolesSueldoEmpleados');
  }

  // Función para mostrar todos los campos del usuario
  Future<void> showAllUserData() async {
    print('idRolesSueldoEmpleados: ${await getIdRolesSueldoEmpleados()}');
    // Agrega las líneas correspondientes para los demás campos
  }
  //NOMBRE 
  Future<String?> getNombre() async {
    return _pref.getString('nombrekey');
  }
  Future<void> saveNombre(String  text) async {
    await _pref.setString('nombrekey', text);
    print('Campo nombrekey guardado $text');
  }
   Future<void> deleteNombre() async {
    await _pref.remove('nombrekey');
    print('Campo nombrekey eliminado');
  }
  //APELLIDO PATERNO 
  Future<String?> getApellidoPaterno() async {
    return _pref.getString('apellidoPaternoKey');
  }
  Future<void> saveApellidoPaterno(String  text) async {
    await _pref.setString('apellidoPaternoKey', text);
    print('Campo apellidoPaternoKey guardado $text');
  }
  //APELLIDO MATERNO 
  Future<String?> getApellidoMaterno() async {
    return _pref.getString('apellidoMaternoKey');
  }
  Future<void> saveApellidoMaterno(String  text) async {
    await _pref.setString('apellidoMaternoKey', text);
    print('Campo apellidoMaternoKey guardado $text');
  }
   //CORREO 
  Future<String?> getCorreo() async {
    return _pref.getString('correoKey');
  }
  Future<void> saveCoreo(String  text) async {
    await _pref.setString('correoKey', text);
    print('Campo correoKey guardado $text');
  }

   //ROL 
  Future<String?> getRol() async {
    return _pref.getString('rolKey');
  }
  Future<void> saveRol(String  text) async {
    await _pref.setString('rolKey', text);
    print('Campo rolKey guardado $text');
  }
  //IMAGEN 
  Future<String?> getImage() async {
    return _pref.getString('imageKey');
  }
  Future<void> saveImage(String  text) async {
    await _pref.setString('imageKey', text);
    print('Campo imageKey guardado $text');
  }
    Future<void> deleteImage() async {
    await _pref.remove('imageKey');
    print('Campo imageKey eliminado');
  }
  //COLLECTION ID  
  Future<String?> getCollectionID() async {
    return _pref.getString('collectionKey');
  }
  Future<void> saveCollectionID(String  text) async {
    await _pref.setString('collectionKey', text);
    print('Campo collectionKey guardado $text');
  }

}


