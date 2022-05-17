import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:login_app/LoginPage.dart';
import 'package:login_app/apiCalls.dart';
import 'package:login_app/dialogClass.dart';
import 'package:login_app/item_api.dart';
import 'package:login_app/listItem.dart';
import 'package:login_app/signUpPage.dart';
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
  //late Future<List<Item>> futureData;
  String now = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String itemTypeString = "";
  //List<Character> characterList = new List<Character>();
  List<Item> itemList = <Item>[];
  ApiCalls function = ApiCalls();
  String apiResponse = "";
  final nameController = TextEditingController();
  final quantityController = TextEditingController();
  final typeController = TextEditingController();
  final descriptionController = TextEditingController();
  int fruitQuantity = 0;
  int meatQuantity = 0;
  int cleaningQuantity = 0;
  int snacksQuantity = 0;
  int officeQuantity = 0;
  int totalQuantity = 0;
  List<int> fruitList = <int>[];
  List<int> meatList = <int>[];
  List<int> snackList = <int>[];
  List<int> cleaningList = <int>[];
  List<int> officeList = <int>[];

  @override
  void initState() {
    super.initState();
    getItemfromApi();
    //futureData = fetchData();
  }

  List<Item> parseUser(String responseBody) {
    var list = json.decode(responseBody) as List<dynamic>;
    var users = list.map((e) => Item.fromJson(e)).toList();
    return users;
  }

  void addSumms() {
    int temp = 0;
    var newList = fruitList + meatList + snackList + cleaningList + officeList;
    for (var element in newList) {
      temp = temp + element;
    }
  }

  void getItemfromApi() async {
    await ItemApi.getItems().then((response) {
      setState(() {
        fruitQuantity = 0;
        meatQuantity = 0;
        cleaningQuantity = 0;
        snacksQuantity = 0;
        officeQuantity = 0;
        totalQuantity = 0;
        Iterable list = json.decode(response.body);
        itemList = list.map((model) => Item.fromJson(model)).toList();

        for (var element in itemList) {
          switch (element.type) {
            case 1:
              {
                fruitQuantity = int.parse(element.quantity) + fruitQuantity;
                totalQuantity = int.parse(element.quantity) + totalQuantity;
                fruitList.add(int.parse(element.quantity));
              }
              break;

            case 2:
              {
                meatQuantity = int.parse(element.quantity) + meatQuantity;
                totalQuantity = int.parse(element.quantity) + totalQuantity;
                meatList.add(int.parse(element.quantity));
              }
              break;

            case 3:
              {
                cleaningQuantity =
                    int.parse(element.quantity) + cleaningQuantity;
                totalQuantity = int.parse(element.quantity) + totalQuantity;
                cleaningList.add(int.parse(element.quantity));
              }
              break;

            case 4:
              {
                snacksQuantity = int.parse(element.quantity) + snacksQuantity;
                totalQuantity = int.parse(element.quantity) + totalQuantity;
                snackList.add(int.parse(element.quantity));
              }
              break;

            case 5:
              {
                officeQuantity = int.parse(element.quantity) + officeQuantity;
                totalQuantity = int.parse(element.quantity) + totalQuantity;
                officeList.add(int.parse(element.quantity));
              }
              break;

            default:
              {
                print("Invalid type");
              }
              break;
          }
        }
      });
    });
  }

  String setTypeString(int type) {
    if (type == 1) {
      return "Fruit";
    } else if (type == 2) {
      return "Meat";
    } else if (type == 3) {
      return "Cleaning";
    } else if (type == 4) {
      return "Snacks";
    } else if (type == 5) {
      return "Office";
    }
    return "";
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
                children: [
                  const Padding(
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
                  const Padding(
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
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 5,
                      left: 40,
                    ),
                    child: Text(
                      'UserName',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  ),
                  const Padding(
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
                    padding: const EdgeInsets.only(
                      top: 40,
                      left: 40,
                    ),
                    child: InkWell(
                      onTap: () {
                        try {
                          if (function.logout == 200) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignInScreen()),
                            );
                          } else {
                            print("Something went wrong" +
                                function.logout.toString());
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignInScreen()),
                            );
                          }
                        } catch (e) {
                          //error
                        }
                      },
                      child: const Text(
                        "Logout",
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
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
                              color: Colors.white,
                            ),
                            height: size.height * 0.6,
                            width: size.width * 0.4,
                            child: ListView.builder(
                                itemCount: itemList.length,
                                itemBuilder: (context, index) {
                                  return ListItem(
                                    int.parse(itemList[index].quantity),
                                    itemList[index].name,
                                    itemTypeString =
                                        setTypeString(itemList[index].type),
                                    () {
                                      //Deletefunktion här
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const Text("Confirm"),
                                          content: const Text(
                                              "Do you want to delete the item?"),
                                          actions: <Widget>[
                                            TextButton(
                                                onPressed: () async {
                                                  ApiCalls function =
                                                      ApiCalls();
                                                  try {
                                                    await function.removeItem(
                                                      itemList[index].name,
                                                    );
                                                  } catch (e) {
                                                    //print('There is an exception.');
                                                  }
                                                  setState(() {
                                                    getItemfromApi();
                                                  });
                                                  Navigator.pop(context, 'OK');
                                                },
                                                child: const Text('OK')),
                                            TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, 'Cancel'),
                                                child: const Text('Cancel')),
                                          ],
                                        ),
                                      );
                                    },
                                    () async {
                                      //Deletefunktion här
                                      await showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              DialogForm("Update item", 2));

                                      setState(() {
                                        getItemfromApi();
                                      });
                                    },
                                  );
                                }),

                            /*
                            child: FutureBuilder<List<Item>>(
                                future: futureData,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List<Item> data = snapshot.requireData;
                                    return ListView.builder(
                                        itemCount: data.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return ListItem(
                                            quantity: itemList[index].quantity,
                                            name: itemList[index].name,
                                            type: itemTypeString =
                                                setTypeString(
                                                    itemList[index].type),
                                          );
                                        });
                                  } else if (snapshot.hasError) {
                                    return Text("Error: ${snapshot.error}");
                                  }
                                  return const CircularProgressIndicator();
                                }),
                                */
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                              left: 80,
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                await showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        DialogForm("Add Item", 1));

                                setState(() {
                                  getItemfromApi();
                                });
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
                          Padding(
                            padding: EdgeInsets.only(left: 25, top: 40),
                            child: Text("Fruit: " + fruitQuantity.toString()),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: LinearPercentIndicator(
                              width: size.width * 0.20,
                              animation: true,
                              lineHeight: 10.0,
                              animationDuration: 2000,
                              percent: fruitQuantity.toDouble() / totalQuantity,
                              //center: const Text("90.0%"),
                              barRadius: const Radius.circular(16),
                              progressColor: Colors.green,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 25, top: 40),
                            child: Text("Meat: " + meatQuantity.toString()),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: LinearPercentIndicator(
                              width: size.width * 0.20,
                              animation: true,
                              lineHeight: 10.0,
                              animationDuration: 2500,
                              percent: meatQuantity.toDouble() / totalQuantity,
                              //center: const Text("80.0%"),
                              barRadius: const Radius.circular(16),
                              progressColor: Colors.green,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 25, top: 40),
                            child: Text(
                                "Cleaning: " + cleaningQuantity.toString()),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: LinearPercentIndicator(
                              width: size.width * 0.20,
                              animation: true,
                              lineHeight: 10.0,
                              animationDuration: 2500,
                              percent:
                                  cleaningQuantity.toDouble() / totalQuantity,
                              //center: const Text("80.0%"),
                              barRadius: const Radius.circular(16),
                              progressColor: Colors.green,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 25, top: 40),
                            child: Text("Snacks: " + snacksQuantity.toString()),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: LinearPercentIndicator(
                              width: size.width * 0.20,
                              animation: true,
                              lineHeight: 10.0,
                              animationDuration: 2500,
                              percent:
                                  snacksQuantity.toDouble() / totalQuantity,
                              //center: const Text("80.0%"),
                              barRadius: const Radius.circular(16),
                              progressColor: Colors.green,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 25, top: 40),
                            child: Text("Office: " + officeQuantity.toString()),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, bottom: 150),
                            child: LinearPercentIndicator(
                              width: size.width * 0.20,
                              animation: true,
                              lineHeight: 10.0,
                              animationDuration: 2500,
                              percent:
                                  officeQuantity.toDouble() / totalQuantity,
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
