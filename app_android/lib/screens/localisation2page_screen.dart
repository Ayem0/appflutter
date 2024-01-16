import 'package:flutter/material.dart';

class Localisation2PageScreen extends StatefulWidget {
  const Localisation2PageScreen({super.key});

  @override
  State<Localisation2PageScreen> createState() =>
      _Localisation2PageScreenState();
}

class _Localisation2PageScreenState extends State<Localisation2PageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        // Flèche de retour
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Action à effectuer lors du clic sur la flèche de retour
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            // Barre de recherche
            Expanded(
              child: TextField(
                style: TextStyle(
                    color: Colors.black), // Couleur du texte de recherche
                decoration: InputDecoration(
                  hintText: 'Rechercher...',
                  hintStyle: TextStyle(
                      color: Colors.black38), // Couleur du texte d'indice
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .black), // Couleur de la bordure de la barre de recherche
                  ),
                ),
              ),
            ),
            // Bouton de recherche
            IconButton(
              icon: Icon(Icons.search, color: Colors.black),
              onPressed: () {
                // Action à effectuer lors du clic sur le bouton de recherche
                // Ajoutez votre logique de recherche ici
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Contenu de la page'),
      ),
      backgroundColor: Colors.white, // Fond blanc pour la page entière
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          height: 56.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bouton "Continuer" centré horizontalement
              ElevatedButton(
                onPressed: () {
                  // Action à effectuer lors du clic sur le bouton "Continuer"
                },
                child: Text('Continuer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
