import 'package:companion/src/config/app_config.dart';
import 'package:url_launcher/url_launcher.dart';

mixin UrlLauncher {
  /// Перенаправялет в приложение для отправки почты
  static Future<void> sendMail(String mail) async {
    final emailLaunchUri = Uri(
      scheme: 'mailto',
      path: mail,
      query: _encodeQueryParameters(<String, String>{
        'subject': AppConfig.appName,
      }),
    );
    await _launchUrl(emailLaunchUri);
  }

  static String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (element) =>
              '''${Uri.encodeComponent(element.key)}=${Uri.encodeComponent(element.value)}''',
        )
        .join('&');
  }

  /// Перенаправляет на набор номера телефона
  static void callPhone(String phone) => _launchUrl(
        Uri(
          scheme: 'tel',
          path: phone,
        ),
      );

  /// Если установлено приложение WhatsApp переходит по номеру в чат
  static void openWhatsApp(String phone) {
    final prettyPhone =
        phone.trim().startsWith('8') ? '+7${phone.substring(1)}' : phone;
    try {
      _launchUrl(
        Uri.parse('https://api.whatsapp.com/send?phone=$prettyPhone'),
      );
    } on Object catch (_) {
      callPhone(phone);
    }
  }

  /// Перенаправляет в браузер
  static void openUrl(String link) {
    final url = Uri.parse(link);
    _launchUrl(url);
  }

  /// Пытается открыть ссылку
  static Future<void> _launchUrl(Uri uri) async {
    // ignore: only_throw_errors
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
      // ignore: only_throw_errors
    )) throw 'Could not launch $uri';
  }
}
