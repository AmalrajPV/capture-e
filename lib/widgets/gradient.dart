import 'package:flutter/material.dart';

class GradientBg extends StatefulWidget {
  const GradientBg({super.key, required this.child});
  final Widget child;

  @override
  State<GradientBg> createState() => _GradientBgState();
}

class _GradientBgState extends State<GradientBg> {
  List<Color> c = const [
    Color(0xff0478AA),
    Color(0xff0478bb),
    Color(0xff047888),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: c,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: widget.child);
  }
}
