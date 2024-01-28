import 'package:app_android/screens/localisationpage_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_android/screens/sign_in_page_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:app_android/widgets/register_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> createUserDocument(
    String userId, String email, String name) async {
  // Ajoutez un document dans la collection 'utilisateurs' avec le champ 'isSeller'
  await FirebaseFirestore.instance.collection('utilisateurs').doc(userId).set({
    'prenom': name,
    'isSeller': false,
    'email': email,
    // Ajoutez d'autres champs si nécessaire
  });
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

class RegisterPageScreen extends StatefulWidget {
  const RegisterPageScreen({super.key});

  @override
  State<RegisterPageScreen> createState() => _RegisterPageScreenState();
}

class _RegisterPageScreenState extends State<RegisterPageScreen> {
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
              const SizedBox(height: 20.0),
              SignInButton(
                Buttons.google,
                text: "S'inscrire avec Google",
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 5,
                onPressed: () async {
                  try {
                    UserCredential userCredential = await signInWithGoogle();
                    // L'opération a réussi, vous pouvez accéder à l'utilisateur authentifié
                    User user = userCredential.user!;
                    String uid = userCredential.user!.uid.toString();
                    String name = userCredential.user!.displayName.toString();
                    String email = userCredential.user!.email.toString();
                    createUserDocument(uid, email, name);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            LocalisationPageScreen(user: user),
                      ),
                    );
                  } catch (e) {
                    // Une erreur s'est produite lors de la connexion avec Google
                    print('Erreur de connexion avec Google: $e');
                  }
                },
              ),
              const SizedBox(height: 20.0),
              // Formulaire avec e-mail et mot de passe en dessous
              RegisterForm(
                nameFocusNode: _nameFocusNode,
                emailFocusNode: _emailFocusNode,
                passwordFocusNode: _passwordFocusNode,
                confirmPasswordFocusNode: _confirmPasswordFocusNode,
              ),

              // Lien "Mot de passe oublié ?" en dessous
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Vous avez déja un compte ?',
                    style: TextStyle(
                      color: Color.fromARGB(255, 6, 44, 41),
                    ),
                  ),
                  const SizedBox(width: 6.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInPageScreen()),
                      );
                      // Logique pour le texte "S'inscrire"
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: 'Se connecter',
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
    );
  }
}
