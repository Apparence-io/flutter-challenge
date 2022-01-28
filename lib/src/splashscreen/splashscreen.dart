import 'package:flutter/material.dart';

import 'package:flutter_puzzle_hack/src/l10n/l10n.dart';
import 'package:flutter_puzzle_hack/src/layout/breakpoint_provider.dart';
import 'package:flutter_puzzle_hack/src/layout/responsive_layout_builder.dart';
import 'package:rive/rive.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({
    Key? key,
    this.duration = const Duration(milliseconds: 2700),
    required this.onDone,
  }) : super(key: key);

  final Duration duration;
  final Function onDone;

  @override
  SplashscreenState createState() => SplashscreenState();
}

class SplashscreenState extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
  final kLogoAnimation = 300;

  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(milliseconds: kLogoAnimation),
      vsync: this,
    )..repeat();
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(controller);

    // ignore: prefer-extracting-callbacks
    Future.delayed(widget.duration, () {
      // ignore: avoid_dynamic_calls
      widget.onDone();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Opacity(
              opacity: animation.value,
              child: ResponsiveLayoutBuilder(
                child: (breakpoint) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 100,
                      child: RiveAnimation.asset(
                        'assets/animations/apparence.riv',
                      ),
                    ),
                    Text(
                      'Apparence.io',
                      style: breakpoint.index > Breakpoint.medium.index
                          ? Theme.of(context).textTheme.headline2
                          : Theme.of(context).textTheme.headline3,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
