


import 'package:ausangate_op/initalpage.dart';
import 'package:flutter/material.dart';


class LayoutModel with ChangeNotifier {
  Widget _currentPage =  const ModuleRoute();


  set currentPage(Widget page){
    _currentPage = page;
    notifyListeners();
  }

  Widget get currentPage => _currentPage; 

}