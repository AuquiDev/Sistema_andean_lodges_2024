// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:ausangate_op/models/model_t_empleado.dart';
import 'package:ausangate_op/pages/orientation_phone_page.dart';
import 'package:ausangate_op/pages/orientation_web_page.dart';
import 'package:ausangate_op/provider/provider_datacahe.dart';
import 'package:ausangate_op/provider/provider_t_empleado.dart';
import 'package:ausangate_op/utils/decoration_form.dart';
import 'package:ausangate_op/utils/shared_global.dart';
import 'package:ausangate_op/utils/text_custom.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //SHAREDPREFENCES
  bool _isLoggedIn = false;

  @override
  void initState() {
    cargarUsuario();
    // Al inicializar el widget, obtenemos el estado de inicio de sesión previo
    SharedPrefencesGlobal().getLoggedIn().then((value) {
      setState(() {
        _isLoggedIn = value; // Actualizamos el estado de inicio de sesión
      });
    });

    // Bloquear la rotación de la pantalla
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, // Solo retrato
    ]);
    super.initState();
  }

  void cargarUsuario() async {
    await Provider.of<UsuarioProvider>(context, listen: false).cargarUsuario();
  }

  bool isVisible = true;
  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<TEmpleadoProvider>(context);
    TEmpleadoModel? user =
        Provider.of<UsuarioProvider>(context).usuarioEncontrado;

    // Paso 1: Verificar si ya estás autenticado
    if (_isLoggedIn) {
      // Paso 2: Redireccionar automáticamente a la página posterior al inicio de sesión
      // return const WebPage();
      final screensize = MediaQuery.of(context).size;
      if (screensize.width > 900) {
        // print('Web Page: ${screensize.width}');
        return const WebPage();
      } else {
        // print('Web Page: ${screensize.width}');
        return const PhonePage();
      }
      // Redirige a la página posterior al inicio de sesión
    }

    return Scaffold(
      backgroundColor: Colors.black87,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/fondo.jpeg'),
            
            fit: BoxFit.cover,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Form(
            key: _formKey,
            child: SafeArea(
              bottom: false,
              child: DelayedDisplay(
                delay: const Duration(milliseconds: 500),
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 220, bottom: 220),
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          color: Colors.white12,
                          constraints: const BoxConstraints(maxWidth: 400),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              LoginBar(user: user),
                              Column(
                                children: [
                                  TextFormField(
                                    controller: _cedulaController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 8,
                                    inputFormatters: [
                                      //Expresion Regular
                                      FilteringTextInputFormatter.allow(
                                          RegExp('[0-9]'))
                                    ],
                                    decoration: decorationTextField(
                                        hintText: 'campo obligatorio',
                                        labelText: 'DNI ',
                                        prefixIcon: const Icon(Icons.person,
                                            color: Colors.black45)),
                                    validator: (value) {
                                      if (value != null && value.isEmpty) {
                                        return 'Campo obligatorio';
                                      }
                                      if (value!.length < 8) {
                                        return 'Ingrese 8 digitos';
                                      }
                                      return null;
                                    },
                                  ),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: isVisible,
                                    keyboardType: TextInputType.visiblePassword,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(
                                          RegExp(r'\s')), // Denegar espacios
                                    ],
                                    decoration: decorationTextField(
                                        hintText: 'campo obligatorio',
                                        labelText: 'contraseña',
                                        prefixIcon: IconButton(
                                            onPressed: () {
                                              isVisible = !isVisible;
                                              setState(() {});
                                            },
                                            icon: Icon(
                                              isVisible != true
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              size: 18,
                                            ))),
                                    validator: (value) {
                                      if (value != null && value.isEmpty) {
                                        return 'Campo obligatorio';
                                      }
                                      if (value!.length < 6) {
                                        return 'Ingrese más de 6 caracteres';
                                      }
                                      if (value.contains(' ')) {
                                        return 'La contraseña no puede contener espacios';
                                      }
                                      return null;
                                    },
                                    // onFieldSubmitted: (_) {
                                    //    if (_formKey.currentState!.validate()) {
                                    //     initStarLogin();
                                    //  }
                                    // },
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 30),
                                    child: ElevatedButton(
                                      style: const ButtonStyle(
                                          shape: MaterialStatePropertyAll(
                                              RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          )),
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Color(0xFF492A15))),
                                      onPressed: loginProvider.islogin
                                          ? null
                                          : () async {
                                              initStarLogin();
                                            },
                                      child: SizedBox(
                                          height: 60,
                                          child: Center(
                                              child: loginProvider.islogin
                                                  ? const CircularProgressIndicator(
                                                      color: Colors.white,
                                                    )
                                                  : const H2Text(
                                                      text: 'Iniciar Sesión',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white,
                                                    ))),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void initStarLogin() async {
    final loginProvider =
        Provider.of<TEmpleadoProvider>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      await loginProvider.login(
          context: context,
          cedulaDNI: int.parse(_cedulaController.text),
          password: _passwordController.text);
      _formKey.currentState!.save();

      //SIMULAR UNA CARGA
      if (loginProvider.islogin) {
        // Crear una instancia de SharedPrefencesGlobal
        SharedPrefencesGlobal sharedPrefs = SharedPrefencesGlobal();

        // Luego, llama al método setLoggedIn en esa instancia
        await sharedPrefs.setLoggedIn();

        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          final screensize = MediaQuery.of(context).size;
          if (screensize.width > 900) {
            // print('Web Page: ${screensize.width}');
            return const WebPage();
          } else {
            // print('Web Page: ${screensize.width}');
            return const PhonePage();
          }
        }), (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Center(
              child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFA91409),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(10),
                  width: 300,
                  child: const H2Text(
                    text: 'usuario no encontrado',
                    fontSize: 15,
                    color: Colors.white,
                    textAlign: TextAlign.center,
                  )),
            ),
          ),
        );
      }
    }
  }
}

class LoginBar extends StatelessWidget {
  const LoginBar({
    super.key,
    required this.user,
  });

  final TEmpleadoModel? user;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 90,
          ),
          H2Text(
            text: user?.imagen == null
                ? 'Iniciar Sesión'.toUpperCase()
                : 'Hola ${user!.nombre}!',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
          user?.imagen == null
              ? Image.asset(
                  'assets/img/andeanlodges.png',
                  height: 100,
                )
              : RippleAnimation(
                  color: Colors.tealAccent,
                  child: ImageLoginUser(
                    user: user,
                    size: 100,
                  ),
                ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class ImageLoginUser extends StatelessWidget {
  const ImageLoginUser({
    super.key,
    required this.user,
    required this.size,
  });

  final TEmpleadoModel? user;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Image.network(
        user?.imagen != null &&
                user?.imagen is String &&
                user!.imagen!.isNotEmpty
            ? 'https://planet-broken.pockethost.io/api/files/${user!.collectionId}/${user!.id}/${user!.imagen}'
            : 'https://via.placeholder.com/300',
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            );
          }
        },
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
          return Image.asset(
            'assets/img/andeanlodges.png',
            height: 150,
          ); // Widget a mostrar si hay un error al cargar la imagen
        },
        // fit: BoxFit.cover,
        height: size,
        width: size,
      ),
    );
  }
}
