import 'package:domain_identity/domain_identity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileEditWidget extends ConsumerStatefulWidget {
  const ProfileEditWidget({
    super.key,
    required this.user,
    required this.onSave,
  });

  final User user;
  final ValueChanged<User> onSave;

  @override
  ConsumerState<ProfileEditWidget> createState() => _ProfileEditWidgetState();
}

class _ProfileEditWidgetState extends ConsumerState<ProfileEditWidget> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _companyController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late String _language;
  late bool _notificationsEnabled;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _companyController = TextEditingController(text: widget.user.company ?? '');
    _phoneController = TextEditingController(text: widget.user.phone ?? '');
    _addressController = TextEditingController(text: widget.user.address ?? '');
    _language = widget.user.language ?? 'de';
    _notificationsEnabled = widget.user.notificationsEnabled ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  String? _nullIfBlank(String value) => value.isEmpty ? null : value;

  void _saveProfile() {
    final updated = widget.user.copyWith(
      name: _nameController.text,
      email: _emailController.text,
      company: _nullIfBlank(_companyController.text),
      phone: _nullIfBlank(_phoneController.text),
      address: _nullIfBlank(_addressController.text),
      language: _language,
      notificationsEnabled: _notificationsEnabled,
    );
    widget.onSave(updated);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Profil bearbeiten',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Vollständiger Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'E-Mail-Adresse',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _companyController,
            decoration: const InputDecoration(
              labelText: 'Firma (optional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Telefonnummer (optional)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: 'Adresse (optional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _language,
            decoration: const InputDecoration(
              labelText: 'Sprache',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'de', child: Text('Deutsch')),
              DropdownMenuItem(value: 'en', child: Text('English')),
            ],
            onChanged: (value) => setState(() => _language = value ?? 'de'),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Benachrichtigungen aktivieren'),
            value: _notificationsEnabled,
            onChanged: (value) => setState(() => _notificationsEnabled = value),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Speichern'),
            ),
          ),
        ],
      ),
    );
  }
}
