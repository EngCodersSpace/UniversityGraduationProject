import 'package:flutter/cupertino.dart';
import '../../components/buttons.dart';

class WebLoginView extends StatelessWidget {
  const WebLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BasicButton(onPress:(){},text: "webView"),
    );
  }
}
