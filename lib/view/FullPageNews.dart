import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../model/NewsArt.dart';

class FullPageNews extends StatefulWidget {
  NewsArticle newsart;
  FullPageNews({super.key, required this.newsart});

  @override
  State<FullPageNews> createState() => _FullPageNewsState();
}

class _FullPageNewsState extends State<FullPageNews> {
  var controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  @override
  Widget build(BuildContext context) {
    var newsart = widget.newsart;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff1c1e33),
          title: Text("Full News "),),
          body: Center(
        child: WebViewWidget(controller: controller..loadRequest(Uri.parse(newsart.url)),),
      )
          //
          ),
    );
  }
}
