import 'package:ausangate_op/pages/menu_principal.dart';
import 'package:ausangate_op/provider/current_page.dart';
import 'package:ausangate_op/utils/shared_global.dart';
import 'package:ausangate_op/utils/text_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WebPage extends StatefulWidget {
  const WebPage({super.key});

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
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
      // appBar: AppBar(
      //   elevation: 0,
      //   title: const TextAppBar(),
      // ),
      body: Row(
        children: [
          const SizedBox(width: 250, child: MenuPrincipal()),
          const VerticalDivider(
            width: 5,
          ),
          Expanded(flex: 3, child: layoutmodel.currentPage),
        ],
      ),
      // drawer: const MenuPrincipal(),
    );
  }
}

class TextAppBar extends StatelessWidget {
  const TextAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const FittedBox(
      child: H2Text(
          text: 'Logística de Operaciones y Almacén',
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.w900),
    );
  }
}
