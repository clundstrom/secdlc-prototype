import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/linear_percent_indicator.dart';
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
  String name = "banan";
  int quantity = 1;
  int type = 1;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  Future<List<Data>> fetchData() async {
    final response = await http
        //.get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Data.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  void addItem() async {
    http.post(Uri.parse('http://localhost:2022/addItem'), //något liknande här
        body: {"name": name, "quantity": quantity, "type": type});
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
          //username + log out column
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
          //Vit box
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              color: Colors.black,
                            ),
                            height: size.height * 0.6,
                            width: size.width * 0.4,
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
                                    return Text("${snapshot.error}");
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
                        ]),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.35),
                      ),
                      width: size.width * 0.25,
                      height: size.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 40.0, left: 25),
                            child: Text(
                              'Inventory Overlook',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 25, top: 40),
                            child: Text("Fruit: " "amount"),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: LinearPercentIndicator(
                              width: size.width * 0.20,
                              animation: true,
                              lineHeight: 10.0,
                              animationDuration: 2000,
                              percent: 0.9,
                              //center: const Text("90.0%"),
                              barRadius: const Radius.circular(16),
                              progressColor: Colors.green,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 25, top: 40),
                            child: Text("Meat: " "amount"),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: LinearPercentIndicator(
                              width: size.width * 0.20,
                              animation: true,
                              lineHeight: 10.0,
                              animationDuration: 2500,
                              percent: 0.1,
                              //center: const Text("80.0%"),
                              barRadius: const Radius.circular(16),
                              progressColor: Colors.green,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 25, top: 40),
                            child: Text("Cleaning: " "amount"),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: LinearPercentIndicator(
                              width: size.width * 0.20,
                              animation: true,
                              lineHeight: 10.0,
                              animationDuration: 2500,
                              percent: 0.7,
                              //center: const Text("80.0%"),
                              barRadius: const Radius.circular(16),
                              progressColor: Colors.green,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 25, top: 40),
                            child: Text("Snacks: " "amount"),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: LinearPercentIndicator(
                              width: size.width * 0.20,
                              animation: true,
                              lineHeight: 10.0,
                              animationDuration: 2500,
                              percent: 0.3,
                              //center: const Text("80.0%"),
                              barRadius: const Radius.circular(16),
                              progressColor: Colors.green,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 25, top: 40),
                            child: Text("Office: " "amount"),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, bottom: 150),
                            child: LinearPercentIndicator(
                              width: size.width * 0.20,
                              animation: true,
                              lineHeight: 10.0,
                              animationDuration: 2500,
                              percent: 0.5,
                              //center: const Text("80.0%"),
                              barRadius: const Radius.circular(16),
                              progressColor: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
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

  void removeItem() async {
    http.post(
        Uri.parse('http://localhost:2022/removeItem'), //något liknande här
        body: {"name": name});
  }

  void updateItem() async {
    http.post(
        Uri.parse('http://localhost:2022/updateItem'), //något liknande här
        body: {"name": name});
  }

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
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      " " + name,
                      style: const TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                        //width: 200.0,
                        child: Text(
                      " " + type,
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
