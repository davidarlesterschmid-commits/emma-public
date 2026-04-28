/// Public API of `adapter_gemini`.
///
/// Primary adapter: [GeminiChatAdapter] implementing [ChatPort] from
/// `package:emma_contracts`. Paid Gemini-API (google_generative_ai),
/// aktiviert nur wenn `USE_FAKES=false` (ADR-03 / ADR-05).
library;

export 'src/gemini_chat_adapter.dart';
