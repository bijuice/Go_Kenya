import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_kenya/models/trip.dart';
import 'package:go_kenya/services/auth.dart';
import 'package:go_kenya/services/location_service.dart';
import 'package:go_kenya/widgets/loading.dart';
import 'package:intl/intl.dart';

class Trips extends StatefulWidget {
  const Trips({Key? key}) : super(key: key);

  @override
  _TripsState createState() => _TripsState();
}

class _TripsState extends State<Trips> {
  //services
  AuthService _auth = new AuthService();
  DatabaseService _db = new DatabaseService();
  Future<QuerySnapshot>? getTrips;
  String uid = '';
  var formatter = DateFormat('MMMd');

  @override
  void initState() {
    super.initState();
    setState(() {
      _getCurrentUser();
    });
  }

  //get current user
  void _getCurrentUser() async {
    var id = await _auth.getCurrentUser();
    setState(() {
      uid = id;
    });
  }

  // void _getTrips() async {
  //   //get current user
  //   var uid = await _auth.getCurrentUser();

  //   setState(() {
  //     getTrips = _db.getTrips(uid: uid);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Trips",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
              child: Container(
                  padding: EdgeInsets.only(
                    top: 5,
                  ),
                  child: FutureBuilder<QuerySnapshot>(
                      future: _db.getTrips(uid: uid),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Loading();
                        }

                        List<Trip> trips = [];

                        snapshot.data!.docs.forEach((doc) {
                          Trip trip = new Trip(
                              dateFrom: DateTime.parse(doc['dateFrom']),
                              dateTo: DateTime.parse(doc['dateTo']),
                              guests: doc['guests'],
                              isResident: doc['isResident'],
                              locID: doc['loc_id'],
                              locName: doc['locName']);

                          trips.add(trip);
                        });

                        return ListView.builder(
                            itemCount: trips.length,
                            itemBuilder: (context, index) {
                              final int stayDuration = trips[index]
                                  .dateTo
                                  .difference(trips[index].dateFrom)
                                  .inDays;
                              return Container(
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Trip to ${trips[index].locName}',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'From ${formatter.format(trips[index].dateFrom)} To ${formatter.format(trips[index].dateTo)}',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text('cost')
                                            ])
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      })))
        ],
      ),
    );
  }
}