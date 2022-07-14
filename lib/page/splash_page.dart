import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../tool/images.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: const [
          FadeInImage(
            placeholder: AssetImage(Images.fade),
            image: AssetImage(Images.splash),
            fadeInDuration: Duration(milliseconds: 500),
            fit: BoxFit.fitHeight,
          ),
          _Body()
        ],
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  var _alignment = Alignment.bottomCenter;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _alignment = Alignment.center;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1000),
      alignment: _alignment,
      // onEnd: _goToHomePage,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 8),
            child: Image.asset('assets/images/logo.png'),
          ),
          DefaultTextStyle(
            style: const TextStyle(
                fontSize: 48.0,
                fontWeight: FontWeight.w700,
                color: Colors.white),
            child: AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText('Weather'),
              ],
              isRepeatingAnimation: false,
              onFinished: _goToHomePage,
            ),
          ),
        ],
      ),
    );
  }

  void _goToHomePage() {
    // Future.delayed(const Duration(milliseconds: 1000), () {
    context.go('/home');
    // });
  }
}
