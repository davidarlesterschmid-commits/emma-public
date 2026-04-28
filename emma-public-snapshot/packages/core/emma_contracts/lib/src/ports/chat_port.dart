/// Port fuer einen konversationsfaehigen Assistenz-Backend-Call.
///
/// Schmal gehalten: ein Prompt rein, ein String raus. History und
/// System-Instruction werden bewusst dem Adapter-Konstruktor ueberlassen
/// — einzelne Calls bleiben stateless, das Caller (Notifier) haelt die
/// anzuzeigende Verlaufsliste.
///
/// Siehe ADR-05 ("Chat + Directions hinter Ports"). Fakes leben in
/// `package:fake_chat`, die eingekaufte Gemini-Implementation in
/// `package:adapter_gemini`.
abstract interface class ChatPort {
  /// Liefert eine Textantwort auf [prompt].
  ///
  /// Muss auch bei Netz-/Kontingentfehlern deterministisch reagieren und
  /// darf die UI nicht blockieren. Adapter werfen bei Fehlern
  /// [ChatException]; der Caller entscheidet ueber Fallback-Text.
  Future<String> reply(String prompt);
}

/// Fehler-Marker fuer fehlgeschlagene [ChatPort.reply]-Calls.
///
/// Adapter kapseln Netz-/Auth-/Kontingent-Fehler des Anbieters in dieser
/// Exception, damit Caller einen einheitlichen Typ catchen koennen.
class ChatException implements Exception {
  const ChatException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() =>
      cause == null ? 'ChatException: $message' : 'ChatException: $message ($cause)';
}
