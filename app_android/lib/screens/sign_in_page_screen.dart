import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:app_android/firebase_options.dart';
import 'package:app_android/screens/register_page_screen.dart';
import '../../ancien_fichiers/user_info_screen.dart';
import '../screens/homepage_screen.dart';
import '../widgets/sign_in_form.dart';

class SignInPageScreen extends StatefulWidget {
  const SignInPageScreen({super.key});

  @override
  State<SignInPageScreen> createState() => _SignInPageScreenState();
}

class _SignInPageScreenState extends State<SignInPageScreen> {

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomepageScreen(
            user: user,
          ),
        ),
      );
    }

    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _emailFocusNode.unfocus();
        _passwordFocusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 40, 16, 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image en dessous
                Image.asset(
                  'assets/launchingpage_image/logo.png',
                  height: 150,
                ),
                SizedBox(height: 20.0),
                // Bouton Google Sign-In en dessous
                FilledButton.tonal(
                  onPressed: () {
                    // Logique Google Sign-In
                  },
                  child: Text('Se connecter avec Google'),
                ),
                SizedBox(height: 20.0),
                // Formulaire avec e-mail et mot de passe en dessous
                FutureBuilder(
                  future: _initializeFirebase(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error initializing Firebase');
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return SignInForm(
                        emailFocusNode: _emailFocusNode,
                        passwordFocusNode: _passwordFocusNode,
                      );
                    }
                    return CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.blueAccent,
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                // Lien "Mot de passe oublié ?" en dessous
                Row(
                  children: [
                    // Texte "Mot de passe oublié ?"
                    Text(
                      'Mot de passe oublié ?',
                      style: TextStyle(
                        color:
                            Color.fromARGB(255, 6, 44, 41), // Couleur du texte
                      ),
                    ),

                    // Espacement entre les textes
                    SizedBox(width: 6.0),

                    // Texte avec un lien "Cliquez ici"
                    GestureDetector(
                      onTap: () {
                        // Logique pour le texte "Cliquez ici"
                      },
                      child: Text.rich(
                        TextSpan(
                          text: 'Cliquez ici',
                          style: TextStyle(
                            color: Color.fromARGB(
                                255, 1, 105, 97), // Couleur du texte
                            decoration:
                                TextDecoration.underline, // Souligner le texte
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 100.0),
                // Bouton "Se connecter" en dessous
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Vous n\'avez pas de compte ?',
                      style: TextStyle(
                        color: Color.fromARGB(255, 6, 44, 41),
                      ),
                    ),
                    SizedBox(width: 6.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPageScreen()),
                        );
                        // Logique pour le texte "S'inscrire"
                      },
                      child: Text.rich(
                        TextSpan(
                          text: 'S\'inscrire',
                          style: TextStyle(
                            color: Color.fromARGB(255, 1, 105, 97),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
