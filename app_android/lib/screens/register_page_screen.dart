import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:app_android/firebase_options.dart';
import 'package:app_android/screens/sign_in_page_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:app_android/widgets/register_form.dart';
import 'package:app_android/utils/authentication.dart';
import 'homepage_screen.dart';



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
              // Formulaire avec e-mail et mot de passe en dessous
              RegisterForm(
                nameFocusNode: _nameFocusNode,
                emailFocusNode: _emailFocusNode,
                passwordFocusNode: _passwordFocusNode,
                confirmPasswordFocusNode: _confirmPasswordFocusNode,
              ),

              // Lien "Mot de passe oublié ?" en dessous
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Vous avez déja un compte ?',
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
                            builder: (context) => SignInPageScreen()),
                      );
                      // Logique pour le texte "S'inscrire"
                    },
                    child: Text.rich(
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
