import 'package:emma_app/core/config/app_config.dart';
import 'package:emma_app/features/auth/presentation/providers/auth_account_providers.dart';
import 'package:emma_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:emma_app/features/auth/presentation/view_models/auth_notifier.dart';
import 'package:emma_app/l10n/app_localizations.dart';
import 'package:emma_app/routing/app_routes.dart';
import 'package:emma_app/features/employer/presentation/employer_mobility_host.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final l = AppLocalizations.of(context)!;
    final invoiceRows = ref.watch(customerInvoicesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        children: [
          const SizedBox(height: 24),
          CircleAvatar(
            radius: 40,
            child: Text(authState.user?.name.substring(0, 1) ?? 'G'),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              authState.user?.name ?? 'Gast',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          if (authState.user?.email != null)
            Center(
              child: Text(
                authState.user!.email,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          const SizedBox(height: 32),
          if (authState.user == null) ...[
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Anmelden'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go('/login'),
            ),
          ] else ...[
            if (AppConfig.useFakes) ...[
              ListTile(
                leading: const Icon(Icons.receipt_long_outlined),
                title: const Text('Rechnungen (Demo)'),
                subtitle: invoiceRows.when(
                  data: (list) =>
                      Text('${list.length} Einträge (Fake-Account)'),
                  loading: () => const Text('Laden …'),
                  error: (message, _) => const Text('—'),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(AppRoutes.accountInvoices),
              ),
            ],
            ListTile(
              leading: const Icon(Icons.business),
              title: const Text('Arbeitgebermobilität'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const EmployerMobilityHost(),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Abmelden'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => ref.read(authNotifierProvider.notifier).logout(),
            ),
          ],
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text(l.profileListSettings),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.settings),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Benachrichtigungen'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Ueber emma'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
