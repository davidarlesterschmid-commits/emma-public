import 'package:domain_identity/domain_identity.dart';
import 'package:flutter/material.dart';

import 'profile_edit_widget.dart';

class AccountCard extends StatefulWidget {
  const AccountCard({super.key, required this.user});

  final User user;

  @override
  State<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  bool _isEditing = false;

  void _toggleEdit() => setState(() => _isEditing = !_isEditing);

  void _saveProfile(User updatedUser) {
    // Mock: persistence will be wired to AuthRepository once the real
    // profile-edit endpoint exists.
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profil gespeichert (Mock)')));
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditing) {
      return ProfileEditWidget(user: widget.user, onSave: _saveProfile);
    }

    final user = widget.user;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Persönliche Daten',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _infoRow('Name', user.name),
            _infoRow('E-Mail', user.email),
            if (user.company != null) _infoRow('Firma', user.company!),
            if (user.phone != null) _infoRow('Telefon', user.phone!),
            if (user.address != null) _infoRow('Adresse', user.address!),
            if (user.birthDate != null)
              _infoRow(
                'Geburtsdatum',
                user.birthDate!.toLocal().toString().split(' ')[0],
              ),
            _infoRow('Sprache', user.language == 'de' ? 'Deutsch' : 'English'),
            _infoRow(
              'Benachrichtigungen',
              user.notificationsEnabled == true ? 'Aktiviert' : 'Deaktiviert',
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _toggleEdit,
                child: const Text('Profil bearbeiten'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
