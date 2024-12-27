import 'package:flutter/material.dart';


// ignore: must_be_immutable
class PopUpLoadingCard extends StatelessWidget {

  const PopUpLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Hero(
              tag: "LoadingPupCard",
              child: CircularProgressIndicator(
                color: Colors.lightBlueAccent,
              ))),
    );
  }
}
