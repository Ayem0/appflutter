import 'dart:io';
import 'package:app_android/screens/localisationCommercePage_Screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_android/screens/homepage_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreateOfferScreen extends StatefulWidget {
  const CreateOfferScreen({
    Key? key,
    required User user,
  })  : _user = user,
        super(key: key);

  final User _user;

  @override
  State<CreateOfferScreen> createState() => _CreateOfferScreenState();
}

class _CreateOfferScreenState extends State<CreateOfferScreen> {
  File? _image;
  final TextEditingController _nomOffreController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Méthode pour sélectionner une image depuis la galerie
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  static Future<void> createOffer(String userId, String nomDuCommerce,
      String description, String imageUrl) async {
    // Ajoutez un document dans la collection 'vendeurs' avec les informations du vendeur
    await FirebaseFirestore.instance.collection('offres').doc(userId).set({
      'uid_vendeur': userId,
      'nom_du_commerce': nomDuCommerce,
      'nom_offre': "",
      'description': description,
      'image_url': imageUrl,
      'etat': "disponible",
      'duree': 1,
      'nombre': 1,
      'prix': 3.99,
      'adresse': "",
      'city': "",
      'country': "",
      'latitude': 0,
      'longitude': 1,
      'heure_recup': "13:00-14:00",
      'date_creation': "",

      // Ajoutez d'autres champs si nécessaire
    });
  }

  Future<String> uploadImage(File image) async {
    // Générez un nom unique pour l'image
    String imageName =
        'vendeur_${DateTime.now().millisecondsSinceEpoch.toString()}';

    // Référence du fichier dans Firebase Storage
    Reference storageReference =
        FirebaseStorage.instance.ref().child('images/$imageName.jpg');

    // Téléchargez l'image sur Firebase Storage
    await storageReference.putFile(image);

    // Obtenez l'URL de téléchargement de l'image
    String imageUrl = await storageReference.getDownloadURL();

    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 20, 16, 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ), // Image en dessous
              Image.asset(
                'assets/launchingpage_image/logo.png',
                height: 150,
              ),
              TextFormField(
                controller: _nomOffreController,
                style: TextStyle(
                  color: Colors.black, // Couleur du texte de l'étiquette
                ),
                decoration: InputDecoration(
                  labelText: "Nom de l'offre",
                  labelStyle: TextStyle(
                    color: Colors.black, // Couleur du texte de l'étiquette
                  ),
                ),
              ),
              TextFormField(
                controller: _descriptionController,
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
              TextFormField(
                controller: _descriptionController,
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
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  _pickImage();
                },
                child: Text('Ajouter une image'),
              ),
              SizedBox(height: 20.0),
              FilledButton.tonal(
                onPressed: () async {
                  // logique d'ajout de commerce

                  if (_image != null) {
                    String imageUrl = await uploadImage(_image!);
                    createOffer(
                      widget._user.uid,
                      _nomOffreController.text,
                      _descriptionController.text,
                      imageUrl,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LocalisationCommerceScreen(
                          user: widget._user,
                        ),
                      ),
                    );
                  } else {
                    // Gérer le cas où aucune image n'est sélectionnée
                  }
                },
                child: Text('Créer une offre'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
