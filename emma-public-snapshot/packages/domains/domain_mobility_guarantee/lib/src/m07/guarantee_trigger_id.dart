enum GuaranteeTriggerId {
  t01('T-01', 'Zugausfall'),
  t02('T-02', 'Verspaetung > 20 Min'),
  t03('T-03', 'Verspaetung > 60 Min'),
  t04('T-04', 'Letzte Verbindung des Tages ausgefallen'),
  t05('T-05', 'Linie > 2 Std. ausser Betrieb'),
  t06('T-06', 'Umstieg verpasst (Verspaetung)'),
  t08('T-08', 'Nutzer-Selbstmeldung');

  const GuaranteeTriggerId(this.specId, this.label);
  final String specId;
  final String label;
}
