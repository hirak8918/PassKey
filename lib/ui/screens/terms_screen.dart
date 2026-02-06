import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms & Conditions',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'PassKey is a fully offline password manager designed to store and generate passwords locally on your device. By using this application, you agree to the following terms and conditions.\n\n'
              'PassKey operates entirely offline and does not collect, transmit, store, or share any personal data, passwords, analytics, usage information, or identifiers. All data created within the app is stored locally on the user’s device and encrypted for security purposes. The developer has no access to user data under any circumstances.\n\n'
              'Access to PassKey is protected by a numeric PIN chosen by the user during setup. If the PIN is forgotten, lost, or compromised, all stored data becomes permanently inaccessible. PassKey does not provide any recovery, reset, or backup mechanism by design, and the developer is not responsible for any data loss resulting from forgotten credentials, app uninstallation, device resets, hardware failure, or software issues.\n\n'
              'PassKey automatically locks itself when the app is minimized, backgrounded, or closed to ensure user privacy. Users are solely responsible for maintaining the security of their device and PIN.\n\n'
              'The password generation feature creates random passwords locally on the device. The responsibility for how generated or stored passwords are used, shared, or managed outside the app lies entirely with the user.\n\n'
              'PassKey is provided “as is” without warranties of any kind. While reasonable security measures are implemented, the developer does not guarantee protection against unauthorized access caused by device compromise, malware, or user negligence.\n\n'
              'PassKey is an open-source application distributed via GitHub. The developer reserves the right to modify the application or these terms at any time. Continued use of the app indicates acceptance of these terms.\n\n'
              'Developer: Hirak Barman',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
