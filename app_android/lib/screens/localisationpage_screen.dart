import 'package:flutter/material.dart';
import 'package:app_android/screens/localisation2page_screen.dart';

class LocalisationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.black), // Couleur de la flèche
          onPressed: () {
            // Action à effectuer lors du clic sur la flèche de retour
            Navigator.pop(context);
          },
        ),
        // Vous pouvez également personnaliser l'appBar selon vos besoins
        backgroundColor: Colors.white, // Couleur de fond de l'appBar
        elevation: 0, // Pour supprimer l'ombre de l'appBar
      ),
      backgroundColor: Colors.white, // Couleur de fond de la page entière
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Texte au milieu de la page avec un padding en bas
          Padding(
            padding: EdgeInsets.only(bottom: 25.0),
            child: Center(
              child: Text(
                'Veuillez renseigner une localisation',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black), // Couleur du texte
              ),
            ),
          ),

          // Bouton "Utiliser ma localisation actuelle"
          ElevatedButton(
            onPressed: () {
              // Action à effectuer lors du clic sur le bouton
              // "Utiliser ma localisation actuelle"
            },
            child: Text('Utiliser ma localisation actuelle'),
          ),
          // Bouton "Choisir un lieu"
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Localisation2PageScreen()),
              );
            },
            child: Text('Choisir un lieu'),
          ),
        ],
      ),
    );
  }
}
