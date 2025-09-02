import 'package:flutter/material.dart';

const Duration fadeOutDuration = Duration(milliseconds: 10);
const Duration fadeInDuration = Duration(milliseconds: 100);

mixin ButtonBase {
  Tween<double> get tween;

  AnimationController get controller;

  late Animation<double> animation;

  void init() {
    animation = controller //
        .drive(CurveTween(curve: Curves.decelerate))
        .drive(tween);
  }

  bool _buttonHeldDown = false;

  void handleTapDown(TapDownDetails event, {required bool mounted}) {
    if (!_buttonHeldDown) {
      _buttonHeldDown = true;
      animate(mounted: mounted);
    }
  }

  void handleTapUp(TapUpDetails event, {required bool mounted}) {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      animate(mounted: mounted);
    }
  }

  void handleTapCancel({required bool mounted}) {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      animate(mounted: mounted);
    }
  }

  void animate({required bool mounted}) {
    if (controller.isAnimating) return;
    final bool wasHeldDown = _buttonHeldDown;

    final TickerFuture ticker = _buttonHeldDown
        ? controller.animateTo(1.0, duration: fadeOutDuration)
        : controller.animateTo(0.0, duration: fadeInDuration);

    ticker.then<void>((void value) {
      if (mounted && wasHeldDown != _buttonHeldDown) animate(mounted: mounted);
    });
  }

  Widget buttonBase({
    required Widget child,
    required bool mounted,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (TapDownDetails details) =>
          handleTapDown(details, mounted: mounted),
      onTapUp: (TapUpDetails details) => handleTapUp(details, mounted: mounted),
      onTapCancel: () => handleTapCancel(mounted: mounted),
      onTap: onTap,
      onLongPress: onLongPress,
      child: child,
    );
  }
}
