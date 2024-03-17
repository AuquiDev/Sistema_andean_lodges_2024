
// ignore_for_file: deprecated_member_use

import 'package:ausangate_op/models/model_t_productos_app.dart';
import 'package:ausangate_op/utils/scroll_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageViewCarousel extends StatelessWidget {
  const ImageViewCarousel({
    Key? key,
    required this.e,
  }) : super(key: key);

  final TProductosAppModel e;

  @override
  Widget build(BuildContext context) {
    return FlutterCarousel(
      options: CarouselOptions(
        height: 300.0,
        aspectRatio: 16 / 9,
        viewportFraction: 1.0,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(seconds: 5),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: false,
        onPageChanged: (index, reason) {
          // Lógica para manejar cambios de página si es necesario
        },
        pageSnapping: true,
        scrollDirection: Axis.horizontal,
        pauseAutoPlayOnTouch: true,
        pauseAutoPlayOnManualNavigate: true,
        pauseAutoPlayInFiniteScroll: false,
        enlargeStrategy: CenterPageEnlargeStrategy.scale,
        disableCenter: false,
        showIndicator: true,
        floatingIndicator: false,
        slideIndicator: const CircularSlideIndicator(
            currentIndicatorColor: Colors.red,
            indicatorBackgroundColor: Colors.black26),
      ),
      items: e.imagen!.map((imageUrl) {
        return Builder(
          builder: (BuildContext context) {
            return ScrollWeb(
              child: GestureDetector(
                onTap: () {
                  // Lógica para manejar el tap en la imagen
                  _launchURL(
                    'https://planet-broken.pockethost.io/api/files/${e.collectionId}/${e.id}/$imageUrl',
                  );
                },
                child: Image.network(
                  (e.imagen != null &&
                          e.imagen is List<String> &&
                          e.imagen!.isNotEmpty)
                      ? 'https://planet-broken.pockethost.io/api/files/${e.collectionId}/${e.id}/$imageUrl'
                      : 'https://via.placeholder.com/300',
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child: SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        ),
                      );
                    }
                  },
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return Image.asset('asets/img/andeanlodges.png');
                  },
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  // Método para abrir una URL
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir la URL: $url';
    }
  }
}