import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_kenya/models/admin_trip.dart';
import 'package:go_kenya/services/location_service.dart';
import 'package:go_kenya/widgets/loading.dart';
import 'package:intl/intl.dart';

class Manage extends StatefulWidget {
  const Manage({Key? key}) : super(key: key);

  @override
  _ManageState createState() => _ManageState();
}

class _ManageState extends State<Manage> {
  DatabaseService _db = new DatabaseService();
  var formatter = DateFormat('MMMd');

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
                "Manage",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: FutureBuilder<QuerySnapshot>(
                  future: _db.getAdminTrips(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Loading();
                    }

                    List<AdminTrip> adminTrips = [];

                    snapshot.data!.docs.forEach((doc) {
                      AdminTrip adminTrip = new AdminTrip(
                          dateFrom: DateTime.parse(doc['dateFrom']),
                          dateTo: DateTime.parse(doc['dateTo']),
                          guests: doc['guests'],
                          isResident: doc['isResident'],
                          locID: doc['loc_id'],
                          locName: doc['locName'],
                          prices: doc['prices'],
                          firstName: doc['firstName'],
                          lastName: doc['lastName'],
                          email: doc['email']);

                      adminTrips.add(adminTrip);
                    });

                    return ListView.builder(
                        itemCount: adminTrips.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Trip to ${adminTrips[index].locName}',
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
                                            'From ${formatter.format(adminTrips[index].dateFrom)} To ${formatter.format(adminTrips[index].dateTo)}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ]),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        '${adminTrips[index].firstName} ${adminTrips[index].lastName}'),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${adminTrips[index].email}'),
                                        Text('Status: Paid')
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  }),
            ),
          )
        ],
      ),
    );
  }
}
