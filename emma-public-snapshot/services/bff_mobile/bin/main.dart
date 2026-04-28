import 'dart:convert';
import 'dart:io';

import 'package:domain_journey/domain_journey.dart';

Future<void> main() async {
  final port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;
  final environment = Platform.environment['APP_ENV'] ?? 'dev';
  final journeySummary = JourneySummaryService().buildSummary(
    const JourneyIntent(
      origin: 'Leipzig Hbf',
      destination: 'Halle (Saale) Hbf',
      requiresGuarantee: true,
    ),
  );

  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);

  stdout.writeln(
    'bff_mobile listening on http://${server.address.address}:'
    '${server.port} ($environment)',
  );

  await for (final request in server) {
    final payload = jsonEncode({
      'service': 'bff_mobile',
      'environment': environment,
      'sampleJourney': journeySummary,
    });

    request.response.headers.contentType = ContentType.json;
    request.response.write(payload);
    await request.response.close();
  }
}
