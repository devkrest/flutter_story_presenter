import 'package:flutter/material.dart';

class StoryViewTextConfig {
  const StoryViewTextConfig({
    this.backgroundColor,
    this.backgroundWidget,
    this.textAlignment,
    this.textWidget,
    this.margin,
    this.textTheme,
  });

  /// Layout background Color for the View
  /// Won't work if [backgroundWidget] is already provided
  final Color? backgroundColor;

  /// Displayed as Background widget inside stack
  final Widget? backgroundWidget;

  /// Alignment for the text or [textWidget]
  final Alignment? textAlignment;

  /// Displayed as Text widget inside stack
  /// Feel free to use flutter_text_parser and other customised options
  final Widget? textWidget;

  /// Margin around the text
  final EdgeInsets? margin;

  /// TextTheme for the Text
  final TextTheme? textTheme;
}
