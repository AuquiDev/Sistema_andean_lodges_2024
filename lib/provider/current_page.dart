

import 'package:ausangate_op/initalpage.dart';
import 'package:flutter/material.dart';


class LayoutModel with ChangeNotifier {
  Widget _currentPage =  const ModuleRoute();
  String _currentImage = 'images/logo.png';

  set currentPage(Widget page){
    _currentPage = page;
    notifyListeners();
  }

  Widget get currentPage => _currentPage; 


   set currentImage(String image){
    _currentImage = image;
    notifyListeners();
  }

  String get currentImage => _currentImage; 
}