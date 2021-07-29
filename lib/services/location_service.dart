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

  //save trip to user
  Future<void> saveTrip(
      {required String locName,
      required String uid,
      required String locID,
      required DateTime dateFrom,
      required DateTime dateTo,
      required int guests,
      required bool isResident}) async {
    CollectionReference user = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('trips');

    user
        .add({
          'loc_id': locID,
          'dateFrom': dateFrom.toString(),
          'dateTo': dateTo.toString(),
          'guests': guests,
          'isResident': isResident,
          'locName': locName,
        })
        .then((value) => print('trip added'))
        .catchError((error) => print('failed to add trip'));
  }

  //get all trips for user
  Future<QuerySnapshot> getTrips({required uid}) async {
    return await firestore
        .collection('users')
        .doc(uid)
        .collection('trips')
        .get();
  }
}
