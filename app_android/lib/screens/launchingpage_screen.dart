
import 'package:flutter/material.dart';
import 'package:app_android/screens/register_page_screen.dart';
import 'package:app_android/screens/sign_in_page_screen.dart';

class LaunchingpageScreen extends StatefulWidget {
  const LaunchingpageScreen({super.key});

  @override
  State<LaunchingpageScreen> createState() => _LaunchingpageScreenState();
}

class _LaunchingpageScreenState extends State<LaunchingpageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 100, 16, 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            Image.asset(
              'assets/launchingpage_image/logo.png',
              height: 200,
            ),
            const Spacer(
              flex: 20,
            ),
            // Texte
            const Text(
              'Avec notre application, finis le gaspillage !',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),

            // Espacement entre le texte et le bouton du bas
            const Spacer(
              flex: 15,
            ),

            Row(
              children: [
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInPageScreen()),
                      );
                    },
                    child: const Text('Se connecter'),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () {
                      // envoie vers page d'inscription
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPageScreen()),
                      );
                    },
                    child: const Text('Créer un compte'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
