import 'dart:io';
import 'package:app_android/screens/localisationCommercePage_Screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_android/screens/homepage_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RegisterProScreen extends StatefulWidget {
  const RegisterProScreen({
    super.key,
    required User user,
    required String address,
    required double latitude,
    required double longitude,
    required String city,
    required String country,
  })  : _user = user,
        _address = address,
        _latitude = latitude,
        _longitude = longitude,
        _city = city,
        _country = country;

  final User _user;
  final String _address;
  final double _latitude;
  final double _longitude;
  final String _city;
  final String _country;

  @override
  State<RegisterProScreen> createState() => _RegisterProScreenState();
}

class _RegisterProScreenState extends State<RegisterProScreen> {
  File? _image;
  final TextEditingController _nomDuCommerceController =
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

  static Future<void> setUserSeller(String userId) async {
    // Ajoutez un document dans la collection 'utilisateurs' avec le champ 'isSeller'
    await FirebaseFirestore.instance
        .collection('utilisateurs')
        .doc(userId)
        .update({
      'isSeller': true,
      // Ajoutez d'autres champs si nécessaire
    });
  }

  static Future<void> createSellerDocument(String userId, String nomDuCommerce,
      String description, String imageUrl) async {
    // Ajoutez un document dans la collection 'vendeurs' avec les informations du vendeur
    await FirebaseFirestore.instance.collection('vendeurs').doc(userId).set({
      'uid_utilisateur': userId,
      'nom_du_commerce': nomDuCommerce,
      'description': description,
      'image_url': imageUrl,
      // Ajoutez d'autres champs si nécessaire
    });
  }

  Future<String> uploadImage(File image, userId) async {
    // Générez un nom unique pour l'image
    String imageName =
        'vendeur_${userId}_${DateTime.now().millisecondsSinceEpoch}';

    // Référence du fichier dans Firebase Storage
    Reference storageReference =
        FirebaseStorage.instance.ref().child('images_vendeurs/$imageName.jpg');

    // Téléchargez l'image sur Firebase Storage
    await storageReference.putFile(image);

    // Obtenez l'URL de téléchargement de l'image
    String imageUrl = await storageReference.getDownloadURL();

    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 20, 16, 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomepageScreen(
                            user: widget._user,
                            address: widget._address,
                            city: widget._city,
                            latitude: widget._latitude,
                            longitude: widget._longitude,
                            country: widget._country,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ), // Image en dessous
              Image.asset(
                'assets/launchingpage_image/logo.png',
                height: 150,
              ),
              TextFormField(
                controller: _nomDuCommerceController,
                style: const TextStyle(
                  color: Colors.black, // Couleur du texte de l'étiquette
                ),
                decoration: const InputDecoration(
                  labelText: 'Nom du commerce',
                  labelStyle: TextStyle(
                    color: Colors.black, // Couleur du texte de l'étiquette
                  ),
                ),
              ),
              TextFormField(
                controller: _descriptionController,
                style: const TextStyle(
                  color: Colors.black, // Couleur du texte de l'étiquette
                ),
                decoration: const InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(
                    color: Colors.black, // Couleur du texte de l'étiquette
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  _pickImage();
                },
                child: const Text('Ajouter une image'),
              ),
              const SizedBox(height: 20.0),
              FilledButton.tonal(
                onPressed: () async {
                  // logique d'ajout de commerce

                  if (_image != null) {
                    setUserSeller(widget._user.uid);
                    String imageUrl = await uploadImage(_image!, widget._user.uid);
                    createSellerDocument(
                      widget._user.uid,
                      _nomDuCommerceController.text,
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
                child: const Text('Ajouter mon commerce'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
