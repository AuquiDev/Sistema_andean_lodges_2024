import 'package:ausangate_op/provider/current_page.dart';
import 'package:ausangate_op/routes_pages/routes_pages.dart';
import 'package:ausangate_op/utils/scroll_web.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModuleRoute extends StatelessWidget {
  const ModuleRoute({super.key});

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return Scaffold(
      body: ScrollWeb(
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          // Calcular el número de columnas en función del ancho disponible
          int crossAxisCount = (constraints.maxWidth / 200).floor();
          // Puedes ajustar el valor 100 según tus necesidades
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: routes.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.white,
                elevation: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        final layoutmodel =
                            Provider.of<LayoutModel>(context, listen: false);
                        layoutmodel.currentPage = routes[index].path;
                      },
                      child: Column(
                        children: [
                          Center(child: routes[index].icon),
                          SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(routes[index].title.toUpperCase())),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
