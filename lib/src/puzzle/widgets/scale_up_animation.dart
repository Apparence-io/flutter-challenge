import 'package:flutter/material.dart';

class ScaleUpAnimation extends StatefulWidget {
  const ScaleUpAnimation({
    Key? key,
    required this.child,
    required this.delayMilliseconds,
  }) : super(key: key);

  final Widget child;
  final int delayMilliseconds;

  @override
  State<ScaleUpAnimation> createState() => _ScaleUpAnimationState();
}

class _ScaleUpAnimationState extends State<ScaleUpAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    animation = Tween<double>(begin: 0, end: 1)
        .chain(CurveTween(curve: Curves.elasticOut))
        .animate(animationController);

    Future.delayed(
      Duration(milliseconds: widget.delayMilliseconds),
      () => animationController.forward(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }
}
