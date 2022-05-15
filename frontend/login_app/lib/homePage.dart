import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_app/jsonData.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  //HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Item>> futureData;
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;
  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  Future<List<Item>> fetchData() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Item.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // TODO: implement build
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
            Colors.blueAccent,
            Colors.deepPurple,
            Colors.redAccent
          ])),
      child: SizedBox(
        //width: 600,
        //height: 600,
        child: Card(
          margin: const EdgeInsets.all(100),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Container(
                  height: 50,
                  width: 450,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: const Text(
                    'User Inventory',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    height: 25,
                    width: 150,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: const Text('Name'),
                  ),
                  Container(
                    height: 25,
                    width: 150,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: const Text('Quantity'),
                  ),
                  Container(
                    height: 25,
                    width: 150,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: const Text('Type'),
                  ),
                ]),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                height: 800,
                width: 450,
                child: FutureBuilder<List<Item>>(
                    future: futureData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Item> data = snapshot.requireData;
                        return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                height: size.height,
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                        child: ListView.builder(
                                            controller: controller,
                                            itemCount: data.length,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              double scale = 1.0;
                                              if (topContainer > 0.5) {
                                                scale =
                                                    index + 0.5 - topContainer;
                                                if (scale < 0) {
                                                  scale = 0;
                                                } else if (scale > 1) {
                                                  scale = 1;
                                                }
                                              }
                                              return Opacity(
                                                  opacity: scale,
                                                  child: Transform(
                                                    transform:
                                                        Matrix4.identity()
                                                          ..scale(scale, scale),
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Align(
                                                      heightFactor: 0.7,
                                                      alignment:
                                                          Alignment.topCenter,
                                                      child: Container(
                                                          height: 150,
                                                          margin:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical: 10),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          20.0)),
                                                              color:
                                                                  Colors.white,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors
                                                                        .black
                                                                        .withAlpha(
                                                                            100),
                                                                    blurRadius:
                                                                        10.0),
                                                              ]),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        20.0,
                                                                    vertical:
                                                                        10),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: const <
                                                                      Widget>[
                                                                    Text(
                                                                      //data[index].title,
                                                                      "Banana",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              28,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    Text(
                                                                      "quantity",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              17,
                                                                          color:
                                                                              Colors.grey),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Text(
                                                                      "Fruit",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              25,
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    )
                                                                  ],
                                                                ),
                                                                //Image.asset(
                                                                //"assets/bild.jpg,
                                                                //height: double.infinity,
                                                                //)
                                                              ],
                                                            ),
                                                          )),
                                                    ),
                                                  ));
                                            })),
                                  ],
                                ),
                              );
                            });
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return const CircularProgressIndicator();
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  List<Widget> itemsData = [];

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      double value = controller.offset / 119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height * 0.30;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: Icon(
            Icons.menu,
            color: Colors.black,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.person, color: Colors.black),
              onPressed: () {},
            )
          ],
        ),
        body: Container(
          height: size.height,
          child: Column(
            children: <Widget>[
              Expanded(
                  child: ListView.builder(
                      controller: controller,
                      itemCount: itemsData.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        double scale = 1.0;
                        if (topContainer > 0.5) {
                          scale = index + 0.5 - topContainer;
                          if (scale < 0) {
                            scale = 0;
                          } else if (scale > 1) {
                            scale = 1;
                          }
                        }
                        return Opacity(
                          opacity: scale,
                          child: Transform(
                            transform: Matrix4.identity()..scale(scale, scale),
                            alignment: Alignment.bottomCenter,
                            child: Align(
                                heightFactor: 0.7,
                                alignment: Alignment.topCenter,
                                child: itemsData[index]),
                          ),
                        );
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
