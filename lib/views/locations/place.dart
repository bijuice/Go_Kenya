import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_kenya/models/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Place extends StatefulWidget {
  final Location loc;

  const Place({Key? key, required this.loc}) : super(key: key);

  @override
  _PlaceState createState() => _PlaceState();
}

class _PlaceState extends State<Place> {
  //init firebase
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  double distance = 0;
  bool open = false;
  var formatter = DateFormat('MMMd');
  int guests = 1;
  bool showCalendar = false;
  double sliderMaxHeight = 400;
  DateTime dateFrom = DateTime.now(),
      dateTo = DateTime.now().add(Duration(days: 1));

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  //get disance from you
  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    double d = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        double.parse(widget.loc.geolocation![0]),
        double.parse(widget.loc.geolocation![1]));

    setState(() {
      distance = d / 1000;
    });
  }

  //opens links in google maps
  void _getDirections() async {
    MapsLauncher.launchCoordinates(double.parse(widget.loc.geolocation![0]),
        double.parse(widget.loc.geolocation![1]));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SlidingUpPanel(
          onPanelOpened: () {
            setState(() {
              open = true;
            });
          },
          onPanelClosed: () {
            setState(() {
              open = false;
            });
          },
          backdropColor: Colors.grey,
          minHeight: 60,
          maxHeight: sliderMaxHeight,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),

          //slide up panel
          panel: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Icon(
                    open ? Icons.expand_more : Icons.expand_less,
                    color: Theme.of(context).primaryColor,
                    size: 30,
                  ),
                ),
                Center(
                  child: Text(
                    'Reserve',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  'Your trip',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 10),
                  child: Text(
                    'Dates',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "From: ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    TextButton(
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                initialDate: dateFrom,
                                firstDate: dateFrom,
                                lastDate:
                                    DateTime.now().add(Duration(days: 365)))
                            .then((date) => {
                                  if (date != null)
                                    {
                                      setState(() {
                                        dateFrom = date;
                                      })
                                    }
                                });
                      },
                      child: Row(
                        children: [
                          Text(
                            "${formatter.format(dateFrom)}",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.edit,
                            size: 20,
                            color: Theme.of(context).primaryColor,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      "To: ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    TextButton(
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                initialDate: dateFrom,
                                firstDate: dateFrom,
                                lastDate:
                                    DateTime.now().add(Duration(days: 365)))
                            .then((date) => {
                                  if (date != null &&
                                      date.compareTo(dateFrom) == 0)
                                    {
                                      setState(() {
                                        dateTo = date;
                                      })
                                    }
                                });
                      },
                      child: Row(
                        children: [
                          Text(
                            "${formatter.format(dateTo)}",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.edit,
                            size: 20,
                            color: Theme.of(context).primaryColor,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    'Guests',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "$guests ${guests < 2 ? "guest" : "guests"}",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () {
                          if (guests > 1) {
                            setState(() {
                              guests = guests - 1;
                            });
                          }
                        },
                        icon: Icon(
                          Icons.remove_circle_outline,
                          size: 30,
                        )),
                    SizedBox(
                      width: 8,
                    ),
                    IconButton(
                        onPressed: () {
                          if (guests < widget.loc.capacity!.toInt()) {
                            setState(() {
                              guests = guests + 1;
                            });
                          }
                        },
                        icon: Icon(
                          Icons.add_circle_outline,
                          size: 30,
                        )),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: _getDirections,
                      child: Text(
                        'Directions',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                    VerticalDivider(
                      width: 40,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Book Now',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),

          //main body
          body: Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
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
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 2.0),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: AspectRatio(
                                            aspectRatio: 16 / 10,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
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
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                child: BackButton(
                                  color: Colors.white,
                                ),
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                              Spacer(),
                              CircleAvatar(
                                child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.favorite,
                                      color: Colors.white,
                                    )),
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),

                    //title
                    Text(
                      widget.loc.locName.toString(),
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
                    ),

                    //rating, capacity, e.t.c
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Row(
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
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  "${distance.toStringAsFixed(0)} KM away",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      fontStyle: FontStyle.italic),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),

                    Divider(
                      thickness: 1,
                      indent: 60,
                      endIndent: 60,
                      color: Theme.of(context).primaryColor,
                    ),
                    //description
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      child: Text(
                        widget.loc.description.toString(),
                        style: TextStyle(fontSize: 16, letterSpacing: 1),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      indent: 60,
                      endIndent: 60,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${widget.loc.prices![0]} USD ",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "/ night - residents",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${widget.loc.prices![1]} USD ",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "/ night - non-residents",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(
                      thickness: 1,
                      indent: 60,
                      endIndent: 60,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 70, right: 70, bottom: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Icon(
                                    Icons.bed,
                                    size: 50,
                                  ),
                                  Text(
                                    "Capacity",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                widget.loc.capacity.toString(),
                                style: TextStyle(fontSize: 22),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Column(
                                children: [
                                  Icon(
                                    Icons.kitchen_rounded,
                                    size: 50,
                                  ),
                                  Text(
                                    "Kitchen",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(Icons.check)
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Icon(
                                    Icons.local_parking,
                                    size: 50,
                                  ),
                                  Text(
                                    "Parking",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(Icons.check),
                              SizedBox(
                                width: 30,
                              ),
                              Column(
                                children: [
                                  Icon(
                                    Icons.wifi,
                                    size: 50,
                                  ),
                                  Text(
                                    "Wifi",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(Icons.check)
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      indent: 60,
                      endIndent: 60,
                      color: Theme.of(context).primaryColor,
                    ),
                    Text('Reviews')
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
