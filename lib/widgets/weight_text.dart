import 'package:flutter/material.dart';

class WeightText extends StatelessWidget {
  final String content;
  TextOverflow overflow;
  double size;
  WeightText({
    Key? key,
    required this.content,
    this.overflow = TextOverflow.ellipsis,
    this.size = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      overflow: overflow,
      style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: size,
          color: Colors.black87,
          height: 1.4,
          fontWeight: FontWeight.bold),
    );
  }
}
