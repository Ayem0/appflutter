import 'package:flutter/material.dart';

class RegisterProScreen extends StatefulWidget {
  const RegisterProScreen({super.key});

  @override
  State<RegisterProScreen> createState() => _RegisterProScreeState();
}

class _RegisterProScreeState extends State<RegisterProScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 40, 16, 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image en dessous
              Image.asset(
                'assets/launchingpage_image/logo.png',
                height: 150,
              ),
              // Bouton Google Sign-In en dessous
              // Formulaire avec e-mail et mot de passe en dessous
              TextFormField(
                style: TextStyle(
                  color: Colors.black, // Couleur du texte de l'étiquette
                ),
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  labelStyle: TextStyle(
                    color: Colors.black, // Couleur du texte de l'étiquette
                  ),
                ),
              ),
              TextFormField(
                obscureText: true,
                style: TextStyle(
                  color: Colors.black, // Couleur du texte de l'étiquette
                ),
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  labelStyle: TextStyle(
                    color: Colors.black, // Couleur du texte de l'étiquette
                  ),
                ),
              ),

              TextFormField(
                obscureText: true,
                style: TextStyle(
                  color: Colors.black, // Couleur du texte de l'étiquette
                ),
                decoration: InputDecoration(
                  labelText: 'Confirmer mot de passe',
                  labelStyle: TextStyle(
                    color: Colors.black, // Couleur du texte de l'étiquette
                  ),
                ),
              ),
              TextFormField(
                style: TextStyle(
                  color: Colors.black, // Couleur du texte de l'étiquette
                ),
                decoration: InputDecoration(
                  labelText: 'Nom du commerce',
                  labelStyle: TextStyle(
                    color: Colors.black, // Couleur du texte de l'étiquette
                  ),
                ),
              ),
              TextFormField(
                style: TextStyle(
                  color: Colors.black, // Couleur du texte de l'étiquette
                ),
                decoration: InputDecoration(
                  labelText: 'Adresse',
                  labelStyle: TextStyle(
                    color: Colors.black, // Couleur du texte de l'étiquette
                  ),
                ),
              ),
              TextFormField(
                style: TextStyle(
                  color: Colors.black, // Couleur du texte de l'étiquette
                ),
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(
                    color: Colors.black, // Couleur du texte de l'étiquette
                  ),
                ),
              ),

              // Lien "Mot de passe oublié ?" en dessous

              // Espacement entre les textes
              SizedBox(height: 20.0),
              // Bouton "Se connecter" en dessous
              FilledButton.tonal(
                onPressed: () {
                  // Logique de connexion
                },
                child: Text('Créer un compte professionnel'),
              ),

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
                      // Logique pour le texte "Se connecter"
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
