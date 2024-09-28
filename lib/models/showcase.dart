import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowcaseView extends StatelessWidget {
  const ShowcaseView({super.key, required this.globalKey, required this.title, required this.description, required this.child, this.shapeBorder = const CircleBorder()});

  final GlobalKey globalKey;
  final String title, description;
  final Widget child;
  final ShapeBorder shapeBorder;


  @override
  Widget build(BuildContext context) {
    return Showcase(key: globalKey, title: title, description: description, targetShapeBorder: shapeBorder, child: child);
  }
}
