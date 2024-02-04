import 'package:ausangate_op/pages/menu_principal.dart';
import 'package:ausangate_op/pages/orientation_web_page.dart';
import 'package:ausangate_op/provider/current_page.dart';
import 'package:ausangate_op/utils/shared_global.dart';
import 'package:flutter/material.dart';


import 'package:provider/provider.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({super.key});

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {

  SharedPrefencesGlobal sharedPrefs = SharedPrefencesGlobal();
  @override
  void initState() {
    // Luego, llama al método setLoggedIn en esa instancia
    sharedPrefs.setLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final layoutmodel = Provider.of<LayoutModel>(context);
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const TextAppBar(),
      ),
      body: layoutmodel.currentPage, //const ListaOpciones(),
      drawer: const MenuPrincipal(),
    );
  }
}
