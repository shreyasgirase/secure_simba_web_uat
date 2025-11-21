import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingPage extends StatelessWidget {
  final String? label;
  const LoadingPage({this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      left: 0,
      bottom: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.6)),
        child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Text('$label...',
                  style: const TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(15, 5, 158, 1),
                  )),
              const SizedBox(
                height: 10,
              ),
              LoadingAnimationWidget.threeArchedCircle(
                color: const Color.fromRGBO(15, 5, 158, 1),
                size: 50,
              ),
            ])),
      ),
    );
  }
}
