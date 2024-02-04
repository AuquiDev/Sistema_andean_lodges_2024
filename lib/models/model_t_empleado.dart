
class TEmpleadoModel {
    String? id;
    String? collectionId;
    String? collectionName;
    DateTime? created;
    DateTime? updated; 

    bool estado;
    String idRolesSueldoEmpleados;
    String nombre;
    String apellidoPaterno;
    String apellidoMaterno;
    String sexo;
    String direccionResidencia;
    String lugarNacimiento;
    DateTime? fechaNacimiento;
    String correoElectronico;
    String nivelEscolaridad;
    String estadoCivil;
    String modalidadLaboral;
    int cedula;
    String cuentaBancaria;
    String? imagen;
    String? cvDocument;
    String telefono;
    String contrasena;
    String rol;

    TEmpleadoModel({
         this.id,
         this.collectionId,
         this.collectionName,
         this.created,
         this.updated,

        required this.estado,
        required this.idRolesSueldoEmpleados,
        required this.nombre,
        required this.apellidoPaterno,
        required this.apellidoMaterno,
        required this.sexo,
        required this.direccionResidencia,
        required this.lugarNacimiento,
         this.fechaNacimiento,
        required this.correoElectronico,
        required this.nivelEscolaridad,
        required this.estadoCivil,
        required this.modalidadLaboral,
        required this.cedula,
        required this.cuentaBancaria,
         this.imagen,
         this.cvDocument,
        required this.telefono,
        required this.contrasena,
        required this.rol,
    });

    factory TEmpleadoModel.fromJson(Map<String, dynamic> json) => TEmpleadoModel(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        created: (json["created"]),
        updated: (json["updated"]),
        estado: json["estado"],
        idRolesSueldoEmpleados: json["id_rolesSueldo_Empleados"],
        nombre: json["nombre"],
        apellidoPaterno: json["apellido_paterno"],
        apellidoMaterno: json["apellido_materno"],
        sexo: json["sexo"],
        direccionResidencia: json["direccion_residencia"],
        lugarNacimiento: json["lugar_nacimiento"],
        fechaNacimiento: DateTime.parse(json["fecha_nacimiento"]),
        correoElectronico: json["correo_electronico"],
        nivelEscolaridad: json["nivel_escolaridad"],
        estadoCivil: json["estado_civil"],
        modalidadLaboral: json["modalidad_laboral"],
        cedula: json["cedula"],
        cuentaBancaria: json["cuenta_bancaria"],
        imagen: json["imagen"],
        cvDocument: json["cv_document"],
        telefono: json["telefono"],
        contrasena: json["contrasena"],
        rol: json["rol"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "collectionId": collectionId,
        "collectionName": collectionName,
        "created": created,
        "updated": updated,
        "estado": estado,
        "id_rolesSueldo_Empleados": idRolesSueldoEmpleados,
        "nombre": nombre,
        "apellido_paterno": apellidoPaterno,
        "apellido_materno": apellidoMaterno,
        "sexo": sexo,
        "direccion_residencia": direccionResidencia,
        "lugar_nacimiento": lugarNacimiento,
        "fecha_nacimiento": fechaNacimiento!.toIso8601String(),
        "correo_electronico": correoElectronico,
        "nivel_escolaridad": nivelEscolaridad,
        "estado_civil": estadoCivil,
        "modalidad_laboral": modalidadLaboral,
        "cedula": cedula,
        "cuenta_bancaria": cuentaBancaria,
        "imagen": imagen,
        "cv_document": cvDocument,
        "telefono": telefono,
        "contrasena": contrasena,
        "rol": rol,
    };
}
