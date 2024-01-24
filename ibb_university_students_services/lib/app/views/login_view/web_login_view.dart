// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import '../../components/buttons.dart';

class WebLoginView extends StatelessWidget {
  WebLoginView({
    super.key,
    this.height,
    this.width,
  });

  double? height;
  double? width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BasicButton(onPress: () {}, text: "webView"),
    );
  }
}
