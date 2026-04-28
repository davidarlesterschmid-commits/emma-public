import 'package:emma_contracts/emma_contracts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

/// Live-[ChatPort] gegen die Google-Gemini-API.
///
/// API-Key und System-Instruction werden konstruktor-seitig uebergeben.
/// Das Composition-Root (`bootstrap.dart`) liest den Key per
/// `String.fromEnvironment('GEMINI_API_KEY')` und reicht ihn hier
/// herein; der Adapter selbst hat keine Flutter-Abhaengigkeit.
///
/// Achtung: Kostenpflichtig. Im MVP (ADR-03 / ADR-05) ist dieser Adapter
/// ausgeschaltet — der Default ist `FakeChatAdapter` aus
/// `package:fake_chat`. Dieser Adapter aktiviert sich erst, wenn
/// `USE_FAKES=false` gebaut wird UND ein gueltiger Key vorhanden ist.
class GeminiChatAdapter implements ChatPort {
  GeminiChatAdapter({
    required this.apiKey,
    this.modelName = 'gemini-2.0-flash',
    String? systemInstruction,
    GenerativeModel? model,
  }) : _model = model ??
            (apiKey.isEmpty
                ? null
                : GenerativeModel(
                    model: modelName,
                    apiKey: apiKey,
                    systemInstruction: Content.text(
                      systemInstruction ?? _defaultSystemInstruction,
                    ),
                  ));

  static const String _defaultSystemInstruction =
      'Du bist emma, ein freundlicher KI-Assistent fuer Mobilitaet und '
      'oeffentlichen Nahverkehr. Wenn dir Routeninformationen gegeben '
      'werden, praesentierst du sie uebersichtlich. Antworte kurz und '
      'hilfreich auf Deutsch.';

  final String apiKey;
  final String modelName;
  final GenerativeModel? _model;

  @override
  Future<String> reply(String prompt) async {
    final model = _model;
    if (model == null) {
      throw const ChatException(
        'Gemini-Adapter ohne API-Key aufgerufen. '
        'USE_FAKES=false setzt einen gueltigen GEMINI_API_KEY voraus.',
      );
    }
    try {
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text ?? 'Keine Antwort erhalten.';
    } on GenerativeAIException catch (e) {
      throw ChatException('Gemini-API Fehler: ${e.message}', cause: e);
    } catch (e) {
      throw ChatException('Unerwarteter Fehler beim Chat-Call.', cause: e);
    }
  }
}
