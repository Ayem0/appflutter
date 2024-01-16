import 'package:flutter/material.dart';

class OffreDetailPage extends StatefulWidget {
  @override
  _OffreDetailPageState createState() => _OffreDetailPageState();
}

class _OffreDetailPageState extends State<OffreDetailPage> {
  bool isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image en haut de la page
          Container(
            height: 200.0,
            child: Stack(
              children: [
                Image.asset(
                  'assets/launchingpage_image/interieur-boulangerie.jpg',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
                // Flèche de retour
                Positioned(
                  top: 16.0,
                  left: 8.0,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      // Action à effectuer lors du clic sur la flèche de retour
                      // Navigator.pop(context);
                    },
                  ),
                ),
                // Cœur cliquable en haut à droite
                Positioned(
                  top: 16.0,
                  right: 16.0,
                  child: IconButton(
                    icon: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // Action à effectuer lors du clic sur le cœur
                      setState(() {
                        isFavorited = !isFavorited;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // En-tête avec couleur de fond grise
              Container(
                color: Colors.grey,
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Boulangerie de la mairie',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ),
              // Espacement
              SizedBox(height: 10.0),
              // Nom, distance, description
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Pain au chocolat',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Couleur noire
                      ),
                    ),
                  ),
                  // Ajout d'un padding à droite
                  Padding(
                    padding: EdgeInsets.only(right: 12.0),
                    child: Text(
                      '3,99 €',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Couleur noire
                      ),
                    ),
                  ),
                ],
              ),
              // Espacement
              SizedBox(height: 8.0),
              // Heure et distance sur la même ligne
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                    child: Text(
                      'Récupérer à : 12:00-14:00',
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Colors.black, // Couleur noire
                      ),
                    ),
                  ),

                  // Ajout d'un padding à droite
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 5, 16, 0),
                    child: Text(
                      '7 kms',
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Colors.black, // Couleur noire
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 0, 0, 2),
                    child: Text(
                      'Adresse : 123 Avenue de la libération',
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Colors.black, // Couleur noire
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 0, 0, 2),
                    child: IconButton(
                      icon: Icon(Icons.info),
                      onPressed: () {
                        // Action à effectuer lors du clic sur le bouton "Plus d'informations"
                        // Par exemple, afficher une nouvelle page avec plus de détails
                        /* Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MoreInformationPage()),
              ); */
                      },
                    ),
                  ),

                  // Ajout d'un padding à droite
                ],
              ),
            ],
          ),
          // Contenu de la page dans une SingleChildScrollView
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.0, 5, 16, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur iaculis malesuada ullamcorper. Aliquam erat volutpat. Etiam arcu lacus, malesuada quis mi eu, vulputate lobortis metus. Mauris dolor mi, congue eu quam at, accumsan hendrerit nunc. Nulla id felis accumsan, molestie arcu eu, rutrum mi. Ut nec porttitor tortor, vel tincidunt lorem. Nulla porta elit auctor urna elementum, non pharetra orci cursus. Donec cursus, sem at ultrices vehicula, eros arcu hendrerit est, ut finibus odio dui ac nulla. Donec eleifend enim et condimentum dictum. Integer vehicula accumsan urna, nec imperdiet dui ultricies eget. Integer lobortis arcu metus, sed faucibus mi efficitur ac. Nulla ante quam, laoreet in malesuada in, facilisis vel ipsum. Nullam et urna eget elit posuere tristique ac quis arcu.',
                    style: TextStyle(color: Colors.black), // Couleur noire
                  ),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur iaculis malesuada ullamcorper. Aliquam erat volutpat. Etiam arcu lacus, malesuada quis mi eu, vulputate lobortis metus. Mauris dolor mi, congue eu quam at, accumsan hendrerit nunc. Nulla id felis accumsan, molestie arcu eu, rutrum mi. Ut nec porttitor tortor, vel tincidunt lorem. Nulla porta elit auctor urna elementum, non pharetra orci cursus. Donec cursus, sem at ultrices vehicula, eros arcu hendrerit est, ut finibus odio dui ac nulla. Donec eleifend enim et condimentum dictum. Integer vehicula accumsan urna, nec imperdiet dui ultricies eget. Integer lobortis arcu metus, sed faucibus mi efficitur ac. Nulla ante quam, laoreet in malesuada in, facilisis vel ipsum. Nullam et urna eget elit posuere tristique ac quis arcu.',
                    style: TextStyle(color: Colors.black), // Couleur noire
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double
                .infinity, // Ceci étend le conteneur à la largeur maximale disponible
            padding: EdgeInsets.fromLTRB(16, 8, 16,
                8), // Ajoutez un padding horizontal pour l'espacement
            child: ElevatedButton(
              onPressed: () {
                // Action à effectuer lors du clic sur le bouton Réserver
              },
              child: Text(
                'Réserver',
                style: TextStyle(color: Colors.white), // Couleur blanche
              ),
            ),
          )
        ],
      ),
    );
  }
}
