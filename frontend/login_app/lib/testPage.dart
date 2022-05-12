import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'jsonData.dart';
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  //TestPage();

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late Future<List<Data>> futureData;
  String now = DateFormat("yyyy-MM-dd").format(DateTime.now());
  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  Future<List<Data>> fetchData() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Data.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // TODO: implement build
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.black),
        height: size.height,
        width: size.width,
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.only(bottom: 40, top: 40),
            child: SizedBox(
              height: size.height,
              width: size.width * 0.2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 0,
                      left: 40,
                    ),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 100,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 5,
                      left: 40,
                    ),
                    child: Text(
                      'NameOfTheUser',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 5,
                      left: 40,
                    ),
                    child: Text(
                      'UserName',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 100,
                      left: 40,
                    ),
                    child: Text(
                      'Project Info',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                    
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 40,
                      left: 40,
                    ),
                    child: Text(
                      'Log out',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: SizedBox(
              height: size.height,
              width: size.width * 0.8,
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0)),
                child: Row(
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                              top: 40,
                              left: 80,
                            ),
                            child: Text(
                              'User Inventory',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 5,
                              left: 80,
                            ),
                            child: Text(
                              now,
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.grey),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                              top: 70,
                              left: 80,
                            ),
                            child: Text(
                              "Items",
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 80.0),
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              color: Colors.white,
                            ),
                            height: size.height * 0.4,
                            width: 500,
                            child: FutureBuilder<List<Data>>(
                                future: futureData,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List<Data> data = snapshot.requireData;
                                    return ListView.builder(
                                        itemCount: data.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return ListItem(
                                            4, //data[index].quantity,
                                            "Banan", //data[index].name,
                                            "Frukt", //data[index].type,
                                          );
                                        });
                                  } else if (snapshot.hasError) {
                                    return Text("Error: ${snapshot.error}");
                                  }
                                  return const CircularProgressIndicator();
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                              left: 80,
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                showDialog<String>(
                                  context: context, 
                                  builder: (BuildContext context) => AlertDialog(
                                    title: const Text("Item added"),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, 'OK'),
                                        child: const Text('OK')),
                                    ],
                                  ),
                                  );
                                //lägg till item funktion här
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.grey),
                              ),
                              label: const Text(
                                'Add Item',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                            
                          )
                        ])
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  static const colorDarkRed = Color(0xffb66a6b);
  final int quantity;
  final String name;
  final String type;

  ListItem(this.quantity, this.name, this.type);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 6.0),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  height: 80.0,
                  width: 80.0,
                  child: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                width: 16.0,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      name,
                      style: const TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                        width: 200.0,
                        child: Text(
                          type,
                          style: TextStyle(fontSize: 17.0, color: Colors.grey),
                        )),
                  ],
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(4.0)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.format_list_numbered,
                    size: 20.0,
                    color: Colors.black,
                  ),
                  Text(quantity.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17.0,
                      ))
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              //Deletefunktion här
                showDialog<String>(
                                  context: context, 
                                  builder: (BuildContext context) => AlertDialog(
                                    title: const Text("Confirm"),
                                    content: const Text("Do you want to delete the item?"),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, 'OK'),
                                        child: const Text('OK')
                                        ),
                                        TextButton(
                                        onPressed: () => Navigator.pop(context, 'Cancel'),
                                        child: const Text('Cancel')
                                        ),
                                    ],
                                  ),
                                  );
            },


            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Icon(
                Icons.delete,
                size: 30.0,
                color: Colors.black,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
