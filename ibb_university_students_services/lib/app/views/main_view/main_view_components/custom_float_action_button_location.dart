import 'package:flutter/material.dart';


class CustomFloatActionButtonLocation extends FloatingActionButtonLocation{
  CustomFloatActionButtonLocation({
    required this.x,
    required this.y
});
  double x , y ;

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {

    return Offset(x, y);
  }


}