import 'dart:developer';

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
      required bool isResident,
      required List<dynamic>? prices}) async {
    CollectionReference user = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('trips');

    CollectionReference trip = FirebaseFirestore.instance.collection('trips');

    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((snapshot) => snapshot.data());

    inspect(snapshot!['email']);

    //add trip to user
    user
        .add({
          'loc_id': locID,
          'dateFrom': dateFrom.toString(),
          'dateTo': dateTo.toString(),
          'guests': guests,
          'isResident': isResident,
          'locName': locName,
          'prices': prices,
        })
        .then((value) => print('trip added'))
        .catchError((error) => print('failed to add trip'));

    //add trip to trips collection
    trip
        .add({
          'uid': uid,
          'loc_id': locID,
          'dateFrom': dateFrom.toString(),
          'dateTo': dateTo.toString(),
          'guests': guests,
          'isResident': isResident,
          'locName': locName,
          'prices': prices,
          'firstName': snapshot['first_name'],
          'lastName': snapshot['last_name'],
          'email': snapshot['email'],
          'phoneNumber': snapshot['phoneNumber'],
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

  //get all trips for admin
  Future<QuerySnapshot> getAdminTrips() async {
    return await firestore.collection('trips').get();
  }
}
