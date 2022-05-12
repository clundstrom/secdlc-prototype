import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
