import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutterstoryview/flutterstoryview.dart';

class StoryViewWebConfig {
  const StoryViewWebConfig({
    this.onWebViewLoaded,
    this.loadingWidget,
    this.errorWidget,
  });

  /// In App Web View Controller for controlling [InAppWebView] once the link is loaded
  final OnWebViewLoaded? onWebViewLoaded;

  /// Loading widget when WebView is loading
  final Widget? loadingWidget;

  /// Error widget when WebView returns error
  final Widget? errorWidget;
}
