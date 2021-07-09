import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_kenya/models/location.dart';

class Place extends StatelessWidget {
  final Location loc;

  const Place({Key? key, required this.loc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
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
                      items: loc.images!.map((url) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 2.0),
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
                          )
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
                  loc.locName.toString(),
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
                ),

                //rating, capacity, e.t.c
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                              loc.rating.toString(),
                              style: TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                          child: Row(
                        children: [
                          Icon(
                            Icons.bed,
                            size: 20,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            loc.capacity.toString(),
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      )),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                          height: 20,
                          child: Row(
                            children: [
                              Text(
                                "${loc.prices![0].toString()}Ksh",
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "\$${loc.prices![1].toString()}",
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          )),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  child: Text(
                    loc.description.toString(),
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
                // Center(
                //   child: Container(
                //     margin: EdgeInsets.all(20),
                //     child: GridView.builder(
                //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //             crossAxisCount: 3, childAspectRatio: 2),
                //         scrollDirection: Axis.vertical,
                //         physics: NeverScrollableScrollPhysics(),
                //         shrinkWrap: true,
                //         itemCount: loc.tags!.length,
                //         itemBuilder: (context, index) {
                //           return Padding(
                //             padding: const EdgeInsets.all(8.0),
                //             child: Container(
                //                 decoration: BoxDecoration(
                //                     border: Border.all(
                //                         color: Colors.black, width: 1.5),
                //                     borderRadius:
                //                         BorderRadius.all(Radius.circular(20))),
                //                 child: Center(
                //                   child: Text(
                //                     loc.tags![index],
                //                     style: TextStyle(
                //                         fontSize: 16,
                //                         fontWeight: FontWeight.bold),
                //                   ),
                //                 )),
                //           );
                //         }),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
