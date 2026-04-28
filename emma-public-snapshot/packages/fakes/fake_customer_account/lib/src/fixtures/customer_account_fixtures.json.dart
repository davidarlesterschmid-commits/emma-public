// GENERATED-STYLE: JSON embedded for pure Dart tests (no asset bundler).
// Two demo users, five invoices each, stable IDs and timestamps.

const String kCustomerAccountFixturesJson = r'''
{
  "users": {
    "user-demo-001": {
      "email": "demo@emma.de",
      "roles": ["private"],
      "contracts": ["mdv-emp-2024"],
      "ticketHistory": ["dt-2025-01", "mdv-ride-12"],
      "preferences": { "theme": "system", "language": "de" },
      "invoices": [
        {
          "id": "inv-demo-001",
          "invoiceNumber": "RE-2025-10421",
          "issuedAt": "2025-12-10T00:00:00.000Z",
          "dueAt": "2025-12-24T00:00:00.000Z",
          "amountCents": 4990,
          "status": "paid",
          "title": "Deutschlandticket Januar 2026"
        },
        {
          "id": "inv-demo-002",
          "invoiceNumber": "RE-2025-10407",
          "issuedAt": "2025-11-10T00:00:00.000Z",
          "dueAt": "2025-11-24T00:00:00.000Z",
          "amountCents": 4990,
          "status": "paid",
          "title": "Deutschlandticket Dezember 2025"
        },
        {
          "id": "inv-demo-003",
          "invoiceNumber": "RE-2025-10388",
          "issuedAt": "2025-10-10T00:00:00.000Z",
          "dueAt": "2025-10-24T00:00:00.000Z",
          "amountCents": 4990,
          "status": "open",
          "title": "Deutschlandticket November 2025 (Nachbuchung)"
        },
        {
          "id": "inv-demo-004",
          "invoiceNumber": "RE-2025-09012",
          "issuedAt": "2025-09-02T00:00:00.000Z",
          "dueAt": null,
          "amountCents": 1280,
          "status": "voided",
          "title": "Sitzplatzreservierung (storniert)"
        },
        {
          "id": "inv-demo-005",
          "invoiceNumber": "RE-2025-06144",
          "issuedAt": "2025-06-15T00:00:00.000Z",
          "dueAt": "2025-06-29T00:00:00.000Z",
          "amountCents": 3150,
          "status": "overdue",
          "title": "Zusatzticket S-Bahn-Upgrade"
        }
      ]
    },
    "user-pilot-002": {
      "email": "pilot@emma.de",
      "roles": ["private", "employer"],
      "contracts": ["leipzig-2025-01", "bahn-bonus-2024"],
      "ticketHistory": ["ice-7", "s-bahn-22"],
      "preferences": { "theme": "dark" },
      "invoices": [
        {
          "id": "inv-pilot-001",
          "invoiceNumber": "RE-2025-20001",
          "issuedAt": "2025-12-01T00:00:00.000Z",
          "dueAt": "2025-12-15T00:00:00.000Z",
          "amountCents": 5900,
          "status": "open",
          "title": "Monatsabonnement E-Mobil Plus"
        },
        {
          "id": "inv-pilot-002",
          "invoiceNumber": "RE-2025-19920",
          "issuedAt": "2025-11-01T00:00:00.000Z",
          "dueAt": "2025-11-15T00:00:00.000Z",
          "amountCents": 5900,
          "status": "paid",
          "title": "Monatsabonnement E-Mobil Plus"
        },
        {
          "id": "inv-pilot-003",
          "invoiceNumber": "RE-2025-19811",
          "issuedAt": "2025-10-05T00:00:00.000Z",
          "dueAt": "2025-10-19T00:00:00.000Z",
          "amountCents": 1299,
          "status": "paid",
          "title": "Kurtaxe Park+Ride (Quartal Q4/2025)"
        },
        {
          "id": "inv-pilot-004",
          "invoiceNumber": "RE-2025-19502",
          "issuedAt": "2025-08-20T00:00:00.000Z",
          "dueAt": "2025-09-03T00:00:00.000Z",
          "amountCents": 18900,
          "status": "paid",
          "title": "Dienstfahrt Erstattung (Batch #441)"
        },
        {
          "id": "inv-pilot-005",
          "invoiceNumber": "RE-2025-19001",
          "issuedAt": "2025-05-11T00:00:00.000Z",
          "dueAt": "2025-05-25T00:00:00.000Z",
          "amountCents": 2450,
          "status": "overdue",
          "title": "Fehlbeleg: Erinnerungsgebühr"
        }
      ]
    }
  }
}
''';
