import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await HttpServer.bind(InternetAddress.anyIPv4, port);

  stdout.writeln('emma bff_mobile listening on :$port');

  await for (final request in server) {
    request.response.headers.contentType = ContentType.json;
    request.response.write(
      jsonEncode(<String, Object>{'status': 'ok', 'service': 'bff_mobile'}),
    );
    await request.response.close();
  }
}
