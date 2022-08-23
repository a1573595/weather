import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weather/router/app_page.dart';
import 'package:weather/utils/color_util.dart';

import '../../utils/image_util.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorUtil.black,
      child: Stack(
        children: const [
          /// 原生圖片淡入動畫
          FadeInImage(
            placeholder: AssetImage(ImageUtil.fade),
            image: AssetImage(ImageUtil.splash),
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

    /// 等待畫面完成第一次繪製
    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// 改變狀態
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
            child: Image.asset(ImageUtil.logo),
          ),

          /// DefaultTextStyle可以讓子Text默認使用一樣的style
          DefaultTextStyle(
            style: Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(color: ColorUtil.white),

            /// 三方動畫文字
            child: AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText('Weather'),
              ],
              isRepeatingAnimation: false,
              onFinished: () => context.go(AppPage.home.fullPath),
            ),
          ),
        ],
      ),
    );
  }
}
