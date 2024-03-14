import 'package:ausangate_op/initalpage.dart';
import 'package:ausangate_op/login_page.dart';
import 'package:ausangate_op/provider/current_page.dart';
import 'package:ausangate_op/provider/provider_datacahe.dart';
import 'package:ausangate_op/provider/provider_t_productoapp.dart';
import 'package:ausangate_op/routes_pages/routes_pages.dart';
import 'package:ausangate_op/utils/shared_global.dart';
import 'package:ausangate_op/utils/text_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentImage = Provider.of<UsuarioProvider>(context).usuarioEncontrado;
    return Drawer(
        child: SafeArea(
          child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
          ImageLoginUser(
                    user: currentImage,
                    size: 150,
                  ),
          const ButtonInicio(),
          const Expanded(child: ListaOpcionesphone()),
          
          const CloseSesion()
                ],
              ),
        ));
  }
}

class ButtonInicio extends StatelessWidget {
  const ButtonInicio({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      contentPadding: const EdgeInsets.all(0),
      leading: const Icon(Icons.home),
      title: const H2Text(text:
        "Principal",
        fontWeight: FontWeight.w500, fontSize: 12,
      ),
      onTap: () {
        final layoutmodel = Provider.of<LayoutModel>(context, listen: false);
        layoutmodel.currentPage = const ModuleRoute();
      },
    );
  }
}


class ListaOpcionesphone extends StatelessWidget {
  const ListaOpcionesphone({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<TProductosAppProvider>(context);
    return ListView.separated(
        itemCount: routes.length,
        separatorBuilder: (context, index) => const Divider(height: 0,thickness: 0,),
        itemBuilder: (context, index) {
          final listaRoutes = routes[index];
          return ListTile(
            contentPadding: const EdgeInsets.all(0),
            minVerticalPadding: 0,
            leading: listaRoutes.icon,
            title: H2Text(text:
              listaRoutes.title,
              fontWeight: FontWeight.w500, fontSize: 12,
            ),
            onTap: () {
               dataProvider.asignarStockDesdeVistas();
               final screensize = MediaQuery.of(context).size;
            if (screensize.width > 900) {
               final layoutmodel = Provider.of<LayoutModel>(context, listen: false);
              layoutmodel.currentPage = listaRoutes.path;
            } else {
              final layoutmodel = Provider.of<LayoutModel>(context, listen: false);
              layoutmodel.currentPage = listaRoutes.path;
              Navigator.pop(context);
            }
              // Navigator.push(context,
              //     MaterialPageRoute(builder: ((context) => listaRoutes.path)));
            },
          );
        });
  }
}


class CloseSesion extends StatelessWidget {
  const CloseSesion({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentImage = Provider.of<UsuarioProvider>(context).usuarioEncontrado;
    return Card(
       surfaceTintColor: Colors.white,
      elevation: 10,
      child: ListTile(
         visualDensity: VisualDensity.compact,
        onTap: () async {
          SharedPrefencesGlobal sharedPrefs = SharedPrefencesGlobal();
          // Luego, llama al método setLoggedIn en esa instancia
          await sharedPrefs.logout(context);
          await SharedPrefencesGlobal().deleteImage();
          await SharedPrefencesGlobal().deleteNombre();
        },
        title: Row(
          children: [
             ImageLoginUser(
                  user: currentImage,
                  size: 30,
                ),
              const SizedBox(width: 10,),
            const H2Text(
              text: 'Cerrar Sesión',
              fontSize: 11,
            ),
          ],
        ),
        trailing: const Icon(Icons.logout,color: Colors.red,),
      ),
    );
  }
}