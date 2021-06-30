import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_kenya/models/location.dart';
import 'package:go_kenya/services/location_service.dart';
import 'package:go_kenya/widgets/loading.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> with AutomaticKeepAliveClientMixin {
  final DatabaseService _database = new DatabaseService();
  Future<QuerySnapshot>? getLocations;

  @override
  void initState() {
    setState(() {
      getLocations = _database.getAllLocations();
    });
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Container(
          padding: EdgeInsets.only(top: 5),
          child: FutureBuilder<QuerySnapshot>(
              future: getLocations,
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
                      rating: doc['rating'].toDouble(),
                      geolocation: doc['geo_location'],
                      tags: doc['tags']);

                  locations.add(loc);
                });

                return ListView.builder(
                    itemCount: locations.length,
                    itemBuilder: (context, index) {
                      return Card(
                        loc: locations[index],
                      );
                    });
              })),
    );
  }
}

class Card extends StatefulWidget {
  final Location loc;
  const Card({Key? key, required this.loc}) : super(key: key);

  @override
  _CardState createState() => _CardState();
}

class _CardState extends State<Card> {
  //final DatabaseService _database = new DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              autoPlay: false,
            ),
            items: widget.loc.images!.map((url) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Stack(
                        children: [
                          Center(
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  url,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ));
                },
              );
            }).toList(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  Icons.star,
                  size: 20,
                  color: Colors.yellow[700],
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  widget.loc.rating.toString(),
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 15,
              ),
              child: Text(
                widget.loc.locName.toString(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
              ),
            ),
          ),
          SizedBox(
            height: 7,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "${widget.loc.prices![0]} KSH ",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "/ night - residents",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Row(
                      children: [
                        Text(
                          "${widget.loc.prices![1]} USD ",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "/ night - non-residents",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
