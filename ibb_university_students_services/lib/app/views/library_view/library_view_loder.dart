// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'library_phones_view.dart';
import 'library_web_view.dart';

class LibraryViewLoader extends StatelessWidget {
  const LibraryViewLoader({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    return Material(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth <= 768 && constraints.maxHeight <= 1025) {
            return   LibraryPhonesView();
          } else {
            return   LibraryWebView();
          }
        },
      ),
    );
  }
}
