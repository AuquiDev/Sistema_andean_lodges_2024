import 'package:flutter/material.dart';



class HtmlText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final int maxLines;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final FontWeight fontWeight;

  const HtmlText({
    Key? key,
    required this.text,
    this.fontSize = 14.0,
    this.color = Colors.black,
    this.maxLines = 1,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
    this.fontWeight = FontWeight.normal
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        fontFamily: 'Poppins',
      ),
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
    );
  }
}

class H1Text extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final int maxLines;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final FontWeight fontWeight;
  const H1Text({
    Key? key,
    required this.text,
    this.fontSize = 20.0,
    this.color = Colors.black,
    this.maxLines = 6,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.ellipsis, 
    this.fontWeight  = FontWeight.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HtmlText(
      text: text,
      fontSize: fontSize,
      color: color,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
       fontWeight: fontWeight,
    );
  }
}

class H2Text extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final int maxLines;
  final TextAlign textAlign;
  final TextOverflow overflow;
   final FontWeight fontWeight;

  const H2Text({
    Key? key,
    required this.text,
    this.fontSize = 20.0,
    this.color = Colors.black,
    this.maxLines = 1,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
    this.fontWeight  = FontWeight.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HtmlText(
      text: text,
      fontSize: fontSize,
      color: color,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
       fontWeight: fontWeight,
    );
  }
}

class H3Text extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final int maxLines;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final FontWeight fontWeight;
  const H3Text({
    Key? key,
    required this.text,
    this.fontSize = 12.0,
    this.color = Colors.black,
    this.maxLines = 4,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
    this.fontWeight  = FontWeight.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HtmlText(
      text: text,
      fontSize: fontSize,
      color: color,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
      fontWeight: fontWeight,
    );
  }
}

class PText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final int maxLines;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final FontWeight fontWeight;
  const PText({
    Key? key,
    required this.text,
    this.fontSize = 14.0,
    this.color = Colors.black,
    this.maxLines = 1,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
    this.fontWeight  = FontWeight.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HtmlText(
      text: text,
      fontSize: fontSize,
      color: color,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
       fontWeight: fontWeight,
    );
  }
}

