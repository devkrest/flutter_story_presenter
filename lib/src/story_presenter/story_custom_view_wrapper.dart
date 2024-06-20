import 'package:flutter/material.dart';

class StoryCustomWidgetWrapper extends StatelessWidget {
  const StoryCustomWidgetWrapper({
    super.key,
    required this.child,
    this.isAutoStart = true,
    this.onLoaded,
  });

  final Widget? child;
  final bool isAutoStart;
  final Function()? onLoaded;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        onLoaded?.call();
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
