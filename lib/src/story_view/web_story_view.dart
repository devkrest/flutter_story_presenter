import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../models/story_item.dart';

typedef OnWebViewLoaded = void Function(InAppWebViewController, bool);

class WebStoryView extends StatefulWidget {
  const WebStoryView(
      {required this.storyItem, this.onWebViewLoaded, super.key});

  final StoryItem storyItem;
  final OnWebViewLoaded? onWebViewLoaded;

  @override
  State<WebStoryView> createState() => _WebStoryViewState();
}

class _WebStoryViewState extends State<WebStoryView> {
  bool _isLoading = true;
  bool _isError = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        InAppWebView(
            initialUrlRequest:
                URLRequest(url: WebUri.uri(Uri.parse(widget.storyItem.url!))),
            onLoadStop: (controller, url) {
              _isLoading = false;
              widget.onWebViewLoaded?.call(controller, true);
              setState(() {});
            },
            onReceivedError: (controller, request, error) {
              _isLoading = false;
              _isError = true;
              widget.onWebViewLoaded?.call(controller, false);
              setState(() {});
            }),
        if (widget.storyItem.webConfig != null &&
            widget.storyItem.webConfig!.loadingWidget != null &&
            _isLoading) ...{
          widget.storyItem.webConfig!.loadingWidget!,
        },
        if (widget.storyItem.webConfig != null &&
            widget.storyItem.webConfig!.errorWidget != null &&
            _isError) ...{
          widget.storyItem.webConfig!.errorWidget!,
        },
      ],
    );
  }
}
