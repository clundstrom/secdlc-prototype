import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_app/apiCalls.dart';

class DialogForm extends StatelessWidget {
  final nameController = TextEditingController();
  final quantityController = TextEditingController();
  final typeController = TextEditingController();
  final descriptionController = TextEditingController();
  String apiResponse = "";

  final String title;
  final int functionType;

  DialogForm(this.title, this.functionType);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding:
          EdgeInsets.only(left: 800, right: 800, top: 400, bottom: 400),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.all(5.0),
          child: TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'Item name',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(5.0),
          child: TextFormField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: const InputDecoration(
              hintText: 'Item Quantity',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(5.0),
          child: TextFormField(
            controller: typeController,
            decoration: const InputDecoration(
              hintText: 'Item Type',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(5.0),
          child: TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(
              hintText: 'Item Description',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Material(
            color: Colors.grey,
            elevation: 5.0,
            borderRadius: BorderRadius.circular(5.0),
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
              onPressed: () async {
                ApiCalls function = ApiCalls();
                try {
                  if (functionType == 1) {
                    apiResponse = await function.addItem(
                        nameController.text,
                        int.parse(quantityController.text),
                        int.parse(typeController.text),
                        descriptionController.text);
                  } else {
                    apiResponse = await function.updateItem(
                        nameController.text,
                        int.parse(quantityController.text),
                        int.parse(typeController.text),
                        descriptionController.text);
                  }
                } catch (e) {
                  //error
                }
                print(apiResponse);
                Navigator.pop(context, 'OK');
              },
              child: const Text(
                "Confirm",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19.0,
                  //fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
