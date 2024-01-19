import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_android/screens/homepage_screen.dart';
import '../../ancien_fichiers/user_info_screen.dart';
import '../utils/authentication.dart';
import '../utils/validator.dart';

import 'custom_form_field.dart';

class SignInForm extends StatefulWidget {
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;

  const SignInForm({
    Key? key,
    required this.emailFocusNode,
    required this.passwordFocusNode,
  }) : super(key: key);
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _signInFormKey = GlobalKey<FormState>();

  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signInFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: 24.0,
            ),
            child: Column(
              children: [
                CustomFormField(
                  controller: _emailController,
                  focusNode: widget.emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  inputAction: TextInputAction.next,
                  validator: (value) => Validator.validateEmail(
                    email: value,
                  ),
                  label: 'Email',
                  hint: 'Entrez votre email',
                ),
                SizedBox(height: 16.0),
                CustomFormField(
                  controller: _passwordController,
                  focusNode: widget.passwordFocusNode,
                  keyboardType: TextInputType.text,
                  inputAction: TextInputAction.done,
                  validator: (value) => Validator.validatePassword(
                    password: value,
                  ),
                  isObscure: true,
                  label: 'Mot de passe',
                  hint: 'Entrez votre mot de passe',
                ),
              ],
            ),
          ),
          _isSigningIn
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      const Color.fromARGB(255, 28, 53, 97),
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(left: 0.0, right: 0.0),
                  child: Container(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.blueAccent ,
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        widget.emailFocusNode.unfocus();
                        widget.passwordFocusNode.unfocus();

                        setState(() {
                          _isSigningIn = true;
                        });

                        if (_signInFormKey.currentState!.validate()) {
                          User? user =
                              await Authentication.signInUsingEmailPassword(
                            context: context,
                            email: _emailController.text,
                            password: _passwordController.text,
                          );

                          if (user != null) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => HomepageScreen(
                                  user: user,

                                  // a remplacer avec resultat de requete sur bdd 
                                  address: '',
                                  city: '',
                                  longitude: 0,
                                  latitude: 0,
                                ),
                              ),
                            );
                          }
                        }

                        setState(() {
                          _isSigningIn = false;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                        child: Text(
                          'Connexion',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 255, 255),
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
