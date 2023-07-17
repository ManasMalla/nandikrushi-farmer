import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String? text;
  final double? size;
  final FontWeight? weight;
  final Color? color;
  final double? lSpace;
  final TextOverflow? flow;
  final TextAlign? align;
  final double? height;

  const TextWidget(this.text,
      {Key? key,
      this.size,
      this.color,
      this.weight,
      this.align,
      this.flow,
      this.lSpace,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text.toString(),
        overflow: flow,
        textAlign: align,
        style: TextStyle(
            fontFamily: 'Product Sans',
            // fontFamily: 'Roboto',
            letterSpacing: lSpace,
            fontSize: size,
            color: color,
            fontWeight: weight,
            height: height));
  }
}

fonts(double? size, FontWeight? bold, Color? color) {
  return TextStyle(
      fontFamily: 'Product Sans',
      color: color,
      fontSize: size,
      fontWeight: bold,
      letterSpacing: 1.0);
  // return TextStyle(
  //     fontFamily: 'Roboto',
  //     color: color,
  //     fontSize: size,
  //     fontWeight: bold,
  //     letterSpacing: 1.0);
}
