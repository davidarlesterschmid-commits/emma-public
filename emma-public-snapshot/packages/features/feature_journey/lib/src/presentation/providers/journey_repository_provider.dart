import 'package:domain_journey/domain_journey.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Wird ausschliesslich in der App-Shell mit [JourneyRepositoryImpl]
/// ueberschrieben. Default wirft, damit fehlendes Wiring auffaellt.
final journeyRepositoryProvider = Provider<JourneyRepository>((ref) {
  throw UnimplementedError(
    'journeyRepositoryProvider: in der App-Shell mit JourneyRepositoryImpl '
    'ueberschreiben.',
  );
});
