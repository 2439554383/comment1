import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'button_base.dart';

class OpacityButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const OpacityButton({
    required this.child,
    this.onTap,
    this.onLongPress,
    Key? key,
  }) : super(key: key);

  @override
  _OpacityButtonState createState() => _OpacityButtonState();
}

class _OpacityButtonState extends State<OpacityButton>
    with SingleTickerProviderStateMixin, ButtonBase {
  @override
  Tween<double> tween = Tween<double>(begin: 1.0, end: 0.618);

  @override
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      value: 0.0,
      vsync: this,
    );
    init();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buttonBase(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      mounted: mounted,
      child: FadeTransition(
        opacity: animation,
        child: widget.child,
      ),
    );
  }
}
