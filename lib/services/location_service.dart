import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //get all locations
  Future<QuerySnapshot> getAllLocations() async {
    return await firestore.collection('locations').get();
  }
}
