import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:woodada/common/layout/default_layout.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  bool isLoading = true;
  var controller = WebViewController()
    ..setJavaScriptMode(
        JavaScriptMode.unrestricted) //WebView에서 사용할 JavaScript 실행 모드를 설정합니다.
    ..setBackgroundColor(const Color(0x00000000)) //이 뷰의 현재 배경색을 설정합니다.
    ..setNavigationDelegate(
      //탐색 이벤트 중에 호출되는 콜백 메서드가 포함된 NavigationDelegate를 설정합니다 .
      NavigationDelegate(
        onProgress: (int progress) {
          debugPrint('WebView is loading (progress : $progress%)');
        },
        onPageStarted: (String url) {
          // 웹 페이지 로딩이 시작될 때 호출되는 콜백입니다.

          debugPrint('Page started loading: $url');
        },
        onPageFinished: (String url) {
          // 웹 페이지 로딩이 완료될 때 호출되는 콜백입니다.
          debugPrint('Page finished loading: $url');
        },
        onWebResourceError: (WebResourceError error) {
          // 웹 페이지 리소스 로딩 중에 오류가 발생할 때 호출되는 콜백입니다.
          debugPrint('''         
            Page resource error:
            code: ${error.errorCode}
            description: ${error.description}         
            errorType: ${error.errorType}          
            isForMainFrame: ${error.isForMainFrame}        
                    ''');
        },
        onNavigationRequest: (NavigationRequest request) {
          // 웹 페이지 탐색 요청 시 호출되는 콜백으로,
          // 특정 URL로의 탐색을 허용 또는 방지하는 등의 결정을 할 수 있습니다.
          if (request.url.startsWith('https://dart-ko.dev/null-safety')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse('https://hazel-blog.vercel.app/'));

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: "Hazel's Log",
      child: Scaffold(
        body: WebViewWidget(
          controller: controller,
        ),
      ),
    );
  }
}
