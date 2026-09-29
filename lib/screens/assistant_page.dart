import 'package:employee_cards/core/theme/app_colors.dart';
import 'package:employee_cards/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Embeds Umm Al-Qura University's WideBot smart-assistant widget
/// inside the app via a minimal HTML shell loaded in a WebView,
/// instead of the university's full public page.
class AssistantPage extends StatefulWidget {
  const AssistantPage({super.key});

  @override
  State<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage> {
  // The public widget-config token used by uqu.edu.sa to embed this
  // same assistant on its own website. It carries no account secrets;
  // it is visible in that page's source to any visitor.
  static const String _botConfigsToken = 'YTMTM1=I';

  static const String _widgetHtml = '''
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
  <style>
    html, body {
      margin: 0;
      padding: 0;
      height: 100%;
      background: #ffffff;
    }
  </style>
</head>
<body>
  <script src="https://platform.widebot.sa/webchatfiles/widebot.js?botConfigs=$_botConfigsToken"></script>
  <script>
    window.addEventListener('load', function () {
      var tries = 0;

      function openAssistant() {
        tries++;

        if (window._widebot_ && window._widebot_.fullMobileScreenWebChat) {
          window._widebot_.fullMobileScreenWebChat();

          var poll = setInterval(function () {
            var launcher = document.getElementById('kaec-chat-button');
            if (launcher) {
              clearInterval(poll);
              launcher.click();
            }
          }, 300);
        } else if (tries < 20) {
          setTimeout(openAssistant, 300);
        }
      }

      openAssistant();

      window.addEventListener('widebot:ready', function () {
        if (window.WidebotReady) {
          window.WidebotReady.postMessage('ready');
        }
      });
    });
  </script>
</body>
</html>
''';

  late final WebViewController _controller;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..addJavaScriptChannel(
        'WidebotReady',
        onMessageReceived: (_) {
          if (!mounted) return;
          setState(() {
            isLoading = false;
          });
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (_) {
            if (!mounted) return;
            setState(() {
              isLoading = false;
              hasError = true;
            });
          },
        ),
      )
      ..loadHtmlString(
        _widgetHtml,
        baseUrl: 'https://uqu.edu.sa/',
      );

    // Safety net: if the "ready" event never fires (slow network,
    // widget failure), stop showing the spinner instead of hanging.
    Future.delayed(const Duration(seconds: 15), () {
      if (!mounted || !isLoading) return;
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          l10n.aiAssistant,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),

          if (isLoading)
            Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    color: AppColors.primary,
                  ),

                  const SizedBox(height: 14),

                  Text(
                    l10n.loadingAssistant,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

          if (hasError)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.failedToLoadAssistant,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.error,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
