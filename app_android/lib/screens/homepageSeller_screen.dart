// Importez les packages nécessaires
import 'package:app_android/screens/createOffer_screen.dart';
import 'package:app_android/screens/homepage_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SellerHomepageScreen extends StatefulWidget {
  const SellerHomepageScreen({
    super.key,
    required User user,
  }) : _user = user;

  final User _user;

  @override
  State<SellerHomepageScreen> createState() => _SellerHomepageScreenState();
}

class _SellerHomepageScreenState extends State<SellerHomepageScreen> {
  List<Map<String, dynamic>> availableOffers = [];
  List<Map<String, dynamic>> soldOffers = [];
  List<Map<String, dynamic>> canceledOffers = [];
  String nomDuCommerce = '';

  @override
  void initState() {
    super.initState();
    // Appeler la fonction pour récupérer les offres lors de l'initialisation de la page
    getAvailableOffers();
    getNomDuCommerce();
  }

  Future<void> getAvailableOffers() async {
    try {
      // Récupérer les offres du vendeur depuis Firestore
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('offres')
              .where('uid_vendeur', isEqualTo: widget._user.uid)
              .where('etat', isEqualTo: "disponible")
              .get();

      setState(() {
        availableOffers = querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      print('Erreur lors de la récupération des offres : $e');
    }
  }

  Future<void> getSoldOffers() async {
    try {
      // Récupérer les offres du vendeur depuis Firestore
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('offres')
              .where('uid_vendeur', isEqualTo: widget._user.uid)
              .where('etat', isEqualTo: "vendue")
              .get();

      setState(() {
        soldOffers = querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      print('Erreur lors de la récupération des offres : $e');
    }
  }

  Future<void> getCanceledOffers() async {
    try {
      // Récupérer les offres du vendeur depuis Firestore
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('offres')
              .where('uid_vendeur', isEqualTo: widget._user.uid)
              .where('etat', isEqualTo: "annulee")
              .get();

      setState(() {
        canceledOffers = querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      print('Erreur lors de la récupération des offres : $e');
    }
  }

  Future<void> getNomDuCommerce() async {
  try {
    // Récupérer le document du vendeur depuis Firestore en utilisant l'UID de l'utilisateur
    DocumentSnapshot<Map<String, dynamic>> userDocument =
        await FirebaseFirestore.instance
            .collection('vendeurs')
            .doc(widget._user.uid)
            .get();

    // Vérifier si le document existe
    if (userDocument.exists) {
      // Récupérer le nom du commerce du document
      setState(() {
        nomDuCommerce = userDocument['nom_du_commerce'] ?? ""; // Remplacez 'nom_du_commerce' par le nom correct du champ dans votre document
      });
    } else {
      print('Le document du vendeur n\'existe pas.');
    }
  } catch (e) {
    print('Erreur lors de la récupération du nom du commerce : $e');
  }
}


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
         Padding(
            padding: const EdgeInsets.only(top: 24.0, left: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomepageScreen(
                              user: widget._user,
                              address: "",
                              city: "",
                              latitude: 0,
                              longitude: 0,
                              country: "",
                            )),
                  );
                },
                child: const Text(
                  "Revenir à l'interface utilisateur",
                  style: TextStyle(
                    color: Color.fromARGB(160, 0, 0, 0), // Couleur du texte
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 28, bottom: 20),
            child: Text(
              nomDuCommerce,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateOfferScreen(
                              user: widget._user,
                            )),
                  );
                },
                child: const Text(
                  "Ajouter une offre",
                  style: TextStyle(
                    color: Color.fromARGB(160, 0, 0, 0), // Couleur du texte
                  ),
                ),
              ),
            ),
          ),

          // Le reste du contenu dans une SingleChildScrollView
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildCategory("Offres disponibles"),
                  buildOfferList(availableOffers),
                  buildCategory("Offres vendues"),
                  buildOfferList(soldOffers),
                  buildCategory("Offres annulées"),
                  buildOfferList(canceledOffers),
                  // Répétez le même modèle pour d'autres catégories...
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fonction inchangée
  Widget buildCategory(String categoryName) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            categoryName,
            style: const TextStyle(color: Colors.black),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle "Tout Voir" button click
              // Add your logic here
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
              ),
              minimumSize: MaterialStateProperty.all<Size>(const Size(0, 0)),
            ),
            child: const Text(
              "Tout voir",
              style: TextStyle(fontSize: 11, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOfferList(list) {
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 2,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(list.length, (index) {
              Map<String, dynamic> offer = list[index];

              return Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 0, 4),
                child: SizedBox(
                  height: 150,
                  width: 210,
                  child: Card(
                    elevation: 3,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 70,
                          width: 210,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(offer['image_url']),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                // Ajoutez ici la logique pour supprimer l'offre
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 3, 1, 1),
                          child: Text(
                            offer['nom_du_commerce'] ?? '',
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 1, 1, 1),
                          child: Text(
                            offer['nom_offre'] ?? '',
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 1, 1, 1),
                              child: Text(
                                "${offer['heure_recup_debut']}-${offer['heure_recup_fin']}",
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 1, 1, 1),
                              child: Text(
                                "7 kms", // Remplacez par le champ approprié
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
                              child: Text(
                                "${offer['prix']} €",
                                style: const TextStyle(
                                  color: Colors.black,
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
            }),
          ),
        ),
      ),
    );
  }
}
