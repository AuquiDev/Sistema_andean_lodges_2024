import 'dart:async';

import 'package:ausangate_op/models/model_t_empleado.dart';
import 'package:ausangate_op/poketbase/t_empleado.dart';
import 'package:ausangate_op/provider/provider_datacahe.dart';
import 'package:ausangate_op/utils/path_key_api.dart';
import 'package:ausangate_op/utils/shared_global.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';

class TEmpleadoProvider with ChangeNotifier {
  List<TEmpleadoModel> listaEmpleados = [];

  TEmpleadoProvider() {
    print('Tabla Detalle Trabajo inicilizado.');
    getTEmpladoProvider();
    realtime();
  }
  //SET y GETTER
  List<TEmpleadoModel> get e => listaEmpleados;


  void addEmpleado(TEmpleadoModel e) {
    listaEmpleados.add(e);
    notifyListeners();
  }

  void updateTEmpleado(TEmpleadoModel e) {
    listaEmpleados[listaEmpleados.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTEmpleado(TEmpleadoModel e) {
    listaEmpleados.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }

  getTEmpladoProvider() async {
    List<RecordModel> response = await TEmpleado.getTEmpleado();
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TEmpleadoModel productos = TEmpleadoModel.fromJson(e.data);
      addEmpleado(productos);
    }).toList();
    notifyListeners();
    return date;
  }

  //METODOS POST
  bool isSyncing = false;
  postEmpleadoProvider(
      {String? id,
      bool? estado,
      String? idRolesSueldoEmpleados,
      String? nombre,
      String? apellidoPaterno,
      String? apellidoMaterno,
      String? sexo,
      String? direccionResidencia,
      String? lugarNacimiento,
      DateTime? fechaNacimiento,
      String? correoElectronico,
      String? nivelEscolaridad,
      String? estadoCivil,
      String? modalidadLaboral,
      int? cedula,
      String? cuentaBancaria,
      // String? cvDocument,
      String? telefono,
      String? contrasena,
      String? rol}) async {
    isSyncing = true;
    notifyListeners();
    TEmpleadoModel data = TEmpleadoModel(
        id: '',
        estado: estado!,
        idRolesSueldoEmpleados: idRolesSueldoEmpleados!,
        nombre: nombre!,
        apellidoPaterno: apellidoPaterno!,
        apellidoMaterno: apellidoMaterno!,
        sexo: sexo!,
        direccionResidencia: direccionResidencia!,
        lugarNacimiento: lugarNacimiento!,
        fechaNacimiento: fechaNacimiento!,
        correoElectronico: correoElectronico!,
        nivelEscolaridad: nivelEscolaridad!,
        estadoCivil: estadoCivil!,
        modalidadLaboral: modalidadLaboral!,
        cedula: cedula!,
        cuentaBancaria: cuentaBancaria!,
        // cvDocument: cvDocument!,
        telefono: telefono!,
        contrasena: contrasena!,
        rol: rol!);

    await TEmpleado.postEmpleadosApp(data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  updateEmpleadoProvider(
      {String? id,
      bool? estado,
      String? idRolesSueldoEmpleados,
      String? nombre,
      String? apellidoPaterno,
      String? apellidoMaterno,
      String? sexo,
      String? direccionResidencia,
      String? lugarNacimiento,
      DateTime? fechaNacimiento,
      String? correoElectronico,
      String? nivelEscolaridad,
      String? estadoCivil,
      String? modalidadLaboral,
      int? cedula,
      String? cuentaBancaria,
      // String? cvDocument,
      String? telefono,
      String? contrasena,
      String? rol}) async {
    isSyncing = true;
    notifyListeners();
    TEmpleadoModel data = TEmpleadoModel(
        id: '',
        estado: estado!,
        idRolesSueldoEmpleados: idRolesSueldoEmpleados!,
        nombre: nombre!,
        apellidoPaterno: apellidoPaterno!,
        apellidoMaterno: apellidoMaterno!,
        sexo: sexo!,
        direccionResidencia: direccionResidencia!,
        lugarNacimiento: lugarNacimiento!,
        fechaNacimiento: fechaNacimiento!,
        correoElectronico: correoElectronico!,
        nivelEscolaridad: nivelEscolaridad!,
        estadoCivil: estadoCivil!,
        modalidadLaboral: modalidadLaboral!,
        cedula: cedula!,
        cuentaBancaria: cuentaBancaria!,
        // cvDocument: cvDocument!,
        telefono: telefono!,
        contrasena: contrasena!,
        rol: rol!);
    await TEmpleado.putEmpleadosApp(id: id, data: data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  deleteTEmpeladoProvider(String id) async {
    await TEmpleado.deleteEmpleadosApp(id);
    notifyListeners();
  }

  Future<void> realtime() async {
    await pb.collection('empleados_personal').subscribe('*', (e) {
      print('REALTIME Empleado ${e.action}');

      switch (e.action) {
        case 'create':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          addEmpleado(TEmpleadoModel.fromJson(e.record!.data));
          break;
        case 'update':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          updateTEmpleado(TEmpleadoModel.fromJson(e.record!.data));
          break;
        case 'delete':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          deleteTEmpleado(TEmpleadoModel.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }



  bool islogin = false;
  //Metodo de Autentificacion
  Future<bool> login({ BuildContext? context, int? cedulaDNI,String? password}) async {
    islogin = true;
    notifyListeners();
    // ignore: unused_local_variable
    int userindex = -1;
    try {
      userindex = listaEmpleados.indexWhere((e) {
        bool ismath = (e.cedula.toString().toLowerCase() ==  cedulaDNI.toString().toString() &&  e.contrasena == password);
        if (ismath) {
          // Si se encuentra el usuario, establecerlo en UsuarioProvider
          Provider.of<UsuarioProvider>(context!, listen: false)  .setusuarioLogin(e);
          // Guardar la información del usuario en SharedPreferences
          SharedPrefencesGlobal().saveID(e.id!);
          SharedPrefencesGlobal().saveIdRolesSueldoEmpleados(e.idRolesSueldoEmpleados);
          SharedPrefencesGlobal().saveNombre(e.nombre);
          SharedPrefencesGlobal().saveApellidoPaterno(e.apellidoPaterno);
          SharedPrefencesGlobal().saveApellidoMaterno(e.apellidoMaterno);
          SharedPrefencesGlobal().saveCoreo(e.correoElectronico);
          SharedPrefencesGlobal().saveRol(e.rol);
          SharedPrefencesGlobal().saveImage(e.imagen!);
          SharedPrefencesGlobal().saveCollectionID(e.collectionId!);
        }
        return ismath;
      });
    } catch (e) {
      userindex = -1;
    }
    // Simular una carga con un temporizador
    await Future.delayed(const Duration(seconds: 3));

    // Lógica de navegación o mensaje de error
    if (userindex != -1) {
      islogin = true;
      notifyListeners();
      // Configurar un temporizador para cambiar islogin a false después de 2 segundos
      Timer(const Duration(seconds: 4), () {
        islogin = false;
        notifyListeners();
      });
      return islogin;
    } else {
      islogin = false;
      notifyListeners();
      return islogin;
    }
  }
}
