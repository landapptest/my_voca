import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SearchPage extends StatelessWidget {
  final String query;

  SearchPage({required this.query});

  @override
  Widget build(BuildContext context) {
    final String searchUrl = 'https://m.search.naver.com/search.naver?query=$query';

    return Scaffold(
      appBar: AppBar(
        title: Text('검색 결과: $query'),
      ),
      body: WebView(
        initialUrl: searchUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
