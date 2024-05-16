import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // Import material.dart for WebView widget


class SafeWebView extends StatelessWidget {
  final String url;

  const SafeWebView({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebView(
        initialUrl: url,
      ),
    );
  }
}

WebView({required String initialUrl}) {
}
