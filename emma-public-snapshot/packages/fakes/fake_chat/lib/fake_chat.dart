/// Fake implementation of [ChatPort] for MVP and tests.
///
/// Default adapter under ADR-03 (MVP-without-paid-APIs) and ADR-05
/// ("Chat + Directions hinter Ports"). The live Gemini adapter lives
/// in `package:adapter_gemini`.
library;

export 'src/fake_chat_adapter.dart';
