import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_kenya/models/location.dart';
import 'package:go_kenya/services/location_service.dart';
import 'package:go_kenya/widgets/loading.dart';

class Explore extends StatelessWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DatabaseService _database = new DatabaseService();

    return Scaffold(
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: FutureBuilder<QuerySnapshot>(
              future: _database.getAllLocations(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Loading();
                }

                List<Location> locations = [];

                snapshot.data!.docs.forEach((doc) {
                  Location loc = new Location(
                      locID: doc.id,
                      locName: doc['loc_name'],
                      description: doc['description'],
                      staffID: doc['staff_id'],
                      images: doc['images'],
                      availability: doc['availability'],
                      prices: doc['price'],
                      rating: doc['rating'],
                      geolocation: doc['geo_location'],
                      tags: doc['tags']);

                  locations.add(loc);
                });

                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Text(snapshot.data!.docs[0]['loc_name']);
                    });
              })),
    );
  }
}
