import 'package:app_android/screens/homepageSeller_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class CreateOfferScreen extends StatefulWidget {
  const CreateOfferScreen({
    super.key,
    required User user,
  })  : _user = user;

  final User _user;

  @override
  State<CreateOfferScreen> createState() => _CreateOfferScreenState();
}

class _CreateOfferScreenState extends State<CreateOfferScreen> {
  File? _image;
  final TextEditingController _nomOffreController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _prixController = TextEditingController();
  final TextEditingController _quantiteController = TextEditingController();
  int _selectedDuration = 1; // Default duration is set to 1 day
  TimeOfDay heureDebut = TimeOfDay.now();
  TimeOfDay heureFin = TimeOfDay.now();
  // Time options for recovery

  // Duration options
  List<int> durations = [1, 2];

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

  String getCleanHeureRecup(TimeOfDay heure) {
    // Utilise la méthode toString pour obtenir l'heure au format "HH:mm"
    final String formattedHour = heure.toString().substring(10, 15);
    return formattedHour;
  }

  Future<Map<String, dynamic>> getSellerInformation(String userId) async {
    try {
      // Récupère le document utilisateur
      DocumentSnapshot userDocument = await FirebaseFirestore.instance
          .collection('vendeurs')
          .doc(userId)
          .get();

      // Vérifie si le document existe
      if (userDocument.exists) {
        Map<String, dynamic> userData =
            userDocument.data() as Map<String, dynamic>;
        if (userData['adresse'] != null) {
          return userDocument.data() as Map<String, dynamic>;
        } else {
          return {};
        }
        // Renvoie les données du document sous forme de Map
      } else {
        return {};
      }
    } catch (e) {
      print('Erreur lors de la récupération des informations utilisateur : $e');
      return {};
    }
  }

  Future<void> createOffer(String userId) async {
    try {
      // Obtenez les informations du vendeur
      Map<String, dynamic> sellerInfo = await getSellerInformation(userId);

      if (sellerInfo.isNotEmpty) {
        String documentName =
            'offre_${userId}_${DateTime.now().millisecondsSinceEpoch}';

        // Ajoutez un document dans la collection 'offres' avec les informations de l'offre
        await FirebaseFirestore.instance
            .collection('offres')
            .doc(documentName)
            .set({
          'uid_vendeur': userId,
          'nom_du_commerce': sellerInfo['nom_du_commerce'] ?? '',
          'nom_offre': _nomOffreController.text,
          'description': _descriptionController.text,
          'image_url': '',
          'etat': 'disponible',
          'duree': _selectedDuration,
          'quantite': int.parse(_quantiteController.text),
          'prix': double.parse(_prixController.text),
          'adresse': sellerInfo['adresse'] ?? '',
          'ville': sellerInfo['ville'] ?? '',
          'pays': sellerInfo['pays'] ?? '',
          'latitude': sellerInfo['latitude'] ?? 0,
          'longitude': sellerInfo['longitude'] ?? 1,
          'heure_recup_debut': getCleanHeureRecup(heureDebut),
          'heure_recup_fin': getCleanHeureRecup(heureFin),
          'date_creation': FieldValue.serverTimestamp(),
          // Ajoutez d'autres champs si nécessaire
        });

        // Si une image est sélectionnée, téléchargez l'image
        if (_image != null) {
          String imageUrl = await uploadImage(_image!, userId);
          // Mettez à jour le document avec l'URL de l'image
          await FirebaseFirestore.instance
              .collection('offres')
              .doc(documentName)
              .update({'image_url': imageUrl});
        }

        // Naviguez vers la page de localisation du commerce
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SellerHomepageScreen(
              user: widget._user,
            ),
          ),
        );
      } else {
        // Gérer le cas où les informations du vendeur ne sont pas disponibles
        print('Informations du vendeur non disponibles');
      }
    } catch (e) {
      print('Erreur lors de la création de l\'offre : $e');
    }
  }

  Future<String> uploadImage(File image, userId) async {
    // Générez un nom unique pour l'image
    String imageName =
        'offre_${userId}_${DateTime.now().millisecondsSinceEpoch}';

    // Référence du fichier dans Firebase Storage
    Reference storageReference =
        FirebaseStorage.instance.ref().child('images_offres/$imageName.jpg');

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
          padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
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
                style: const TextStyle(
                  color: Colors.black, // Couleur du texte de l'étiquette
                ),
                decoration: const InputDecoration(
                  labelText: "Nom de l'offre",
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
              DropdownButtonFormField<int>(
                value: _selectedDuration,
                onChanged: (int? value) {
                  setState(() {
                    _selectedDuration = value!;
                  });
                },
                items: durations.map((int duration) {
                  return DropdownMenuItem<int>(
                    value: duration,
                    child: Text('$duration jour${duration > 1 ? 's' : ''}'),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Durée',
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              // New field for Quantity
              TextFormField(
                controller: _quantiteController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  labelText: 'Quantité',
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              // New field for Price
              TextFormField(
                controller: _prixController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  labelText: 'Prix',
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Column(
                children: [
                  const Row(
                    children: [Text('Heure de récupération')],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          // heure de début
                          final TimeOfDay? timeOfDay = await showTimePicker(
                            context: context,
                            initialTime: heureDebut,
                            initialEntryMode: TimePickerEntryMode.inputOnly,
                            builder: (BuildContext context, Widget? child) {
                              return MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(alwaysUse24HourFormat: true),
                                child: child!,
                              );
                            },
                          );
                          if (timeOfDay != null) {
                            setState(() {
                              heureDebut = timeOfDay;
                            });
                          }
                        },
                        child: const Text('Heure début'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // heure de début
                          final TimeOfDay? timeOfDay = await showTimePicker(
                            context: context,
                            initialTime: heureFin,
                            initialEntryMode: TimePickerEntryMode.inputOnly,
                            builder: (BuildContext context, Widget? child) {
                              return MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(alwaysUse24HourFormat: true),
                                child: child!,
                              );
                            },
                          );
                          if (timeOfDay != null) {
                            setState(() {
                              heureFin = timeOfDay;
                            });
                          }
                        },
                        child: const Text('Heure fin'),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  _pickImage();
                },
                child: const Text('Ajouter une image'),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  // Ajout de l'offre et un upload de l'image
                  await createOffer(widget._user.uid);
                },
                child: const Text('Créer une offre'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
