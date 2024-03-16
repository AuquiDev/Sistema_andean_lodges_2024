import 'package:flutter/material.dart';

ButtonStyle buttonStyle() {
  return  const ButtonStyle(
    // maximumSize: MaterialStatePropertyAll(Size(150, 80)),
    padding: MaterialStatePropertyAll(EdgeInsets.only(left: 10, right: 10)),
    elevation: MaterialStatePropertyAll(3),
    visualDensity: VisualDensity.compact,
    surfaceTintColor: MaterialStatePropertyAll(Colors.white),
    backgroundColor:  MaterialStatePropertyAll(Color(0xFFEFE93D)),
    overlayColor: MaterialStatePropertyAll(Colors.white),
     shape: MaterialStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),))
  );
}

// ButtonStyle buttonStyle2() {
//   return const ButtonStyle(
//       maximumSize: MaterialStatePropertyAll(Size(150, 80)),
//       // minimumSize: MaterialStatePropertyAll(Size(80, 40)),
//       padding: MaterialStatePropertyAll(EdgeInsets.only(left: 10, right: 10)),
//       elevation: MaterialStatePropertyAll(3),
//       visualDensity: VisualDensity.compact,
//       surfaceTintColor: MaterialStatePropertyAll(Colors.white),
//       backgroundColor: MaterialStatePropertyAll(Color(0xDDECECEC)),
//       overlayColor: MaterialStatePropertyAll(Colors.white),
//       shape: MaterialStatePropertyAll(RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(10)),)));
// }

ButtonStyle buttonStyle2() {
    return const ButtonStyle(
        // maximumSize: MaterialStatePropertyAll(Size(150, 80)),
        // minimumSize: MaterialStatePropertyAll(Size(80, 40)),
        
        padding: MaterialStatePropertyAll(EdgeInsets.only(left: 5, right: 5)),
        elevation: MaterialStatePropertyAll(2),
        // visualDensity: VisualDensity.compact,
        surfaceTintColor: MaterialStatePropertyAll(Colors.brown),
        backgroundColor: MaterialStatePropertyAll(Colors.white),
        overlayColor: MaterialStatePropertyAll(Colors.brown),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color:Colors.white, width: 3)
        )));
  }

ButtonStyle buttonStyle3() {
  return const ButtonStyle(
      padding: MaterialStatePropertyAll(EdgeInsets.only(left: 5, right: 5)),
      // elevation: MaterialStatePropertyAll(3),
      visualDensity: VisualDensity.compact,
      surfaceTintColor: MaterialStatePropertyAll(Color(0xFFE5E3E3)),
      backgroundColor: MaterialStatePropertyAll(Color(0xFFF2EFEF)),
      overlayColor: MaterialStatePropertyAll(Color(0xFFDFEE4F)),
      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0)),)));
}
