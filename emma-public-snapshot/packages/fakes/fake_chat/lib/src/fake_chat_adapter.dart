import 'package:emma_contracts/emma_contracts.dart';

/// Fake [ChatPort] mit keyword-basierten Templates.
///
/// Ziel ist nicht Sprachverstaendnis, sondern eine deterministische,
/// demotaugliche Antwort ohne kostenpflichtige API. Reale Konversation
/// uebernimmt `GeminiChatAdapter` aus `package:adapter_gemini`, sobald
/// `USE_FAKES=false` gebaut wird.
///
/// Die Antworten sind bewusst generisch — die UI markiert Fake-Mode
/// sichtbar (siehe ADR-05 / Inkrement 3c, `FakeModeBanner`).
class FakeChatAdapter implements ChatPort {
  const FakeChatAdapter();

  static const String _fallback =
      'Ich bin emma im Demo-Modus. Frag mich nach Verbindungen, '
      'z.B. "Wie komme ich von Leipzig nach Halle?"';

  /// Keyword → Antwort. Erster Treffer auf Substring-Ebene gewinnt,
  /// Reihenfolge ist semantisch relevant.
  static const List<({List<String> keywords, String reply})> _templates = [
    (
      keywords: ['hallo', 'hi ', 'moin', 'guten tag', 'servus'],
      reply:
          'Hallo! Ich bin emma, dein Mobilitaetsassistent. Womit kann ich helfen?',
    ),
    (
      keywords: ['ticket', 'fahrkarte', 'abo', 'deutschlandticket'],
      reply:
          'Tickets kaufst du im Tarifbereich der App. Aktuell laeuft der '
          'Ticket-Kauf noch ueber die bestehenden Partner-Apps.',
    ),
    (
      keywords: ['danke', 'merci', 'dankeschoen'],
      reply: 'Gern geschehen.',
    ),
    (
      keywords: ['verspaetung', 'stoerung', 'ausfall'],
      reply:
          'Aktuelle Stoerungen im MDV-Netz findest du in den Hinweisen der '
          'jeweiligen Partner-App. Mobilitaetsgarantie greift bei '
          'dokumentierten Ausfaellen > 20 Min.',
    ),
  ];

  @override
  Future<String> reply(String prompt) async {
    final normalized = prompt.trim().toLowerCase();
    if (normalized.isEmpty) {
      return 'Bitte gib eine Frage ein.';
    }

    for (final template in _templates) {
      for (final keyword in template.keywords) {
        if (normalized.contains(keyword)) return template.reply;
      }
    }

    // Route-Prompts mit "von … nach …" erkennt der Fake als solche, ohne
    // Directions selbst aufzurufen — das bleibt Aufgabe von
    // DirectionsPort.
    if (normalized.contains('von ') && normalized.contains(' nach ')) {
      return 'Alles klar — ich schaue mir die Verbindung an. '
          'Die Fahrzeiten bekommst du aus dem Reiseplaner.';
    }

    return _fallback;
  }
}
