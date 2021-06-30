import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class DatabaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  //get all locations
  Future<QuerySnapshot> getAllLocations() async {
    return await firestore.collection('locations').get();
  }

  //get image urls
  Future<void> downloadURLs() async {
    //List<String> urls;

    firebase_storage.ListResult result =
        await firebase_storage.FirebaseStorage.instance.ref().listAll();

    result.items.forEach((firebase_storage.Reference ref) {
      print('Found file: $ref');
    });
  }
}
