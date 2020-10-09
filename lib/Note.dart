import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/template.dart';
import 'Home.dart';
import 'dart:async';

class Newnote extends StatefulWidget {
  @override
  _NewnoteState createState() => _NewnoteState();
}

class _NewnoteState extends State<Newnote> {
  @override
  Widget build(BuildContext context) {
    Color newnotebuttoncolor = _colorFromHex("43658b");
    return Scaffold(
      backgroundColor: Colors.yellow[300],
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(
          Icons.save,
          color: Colors.white,
        ),
        label: Text(
          'Save',
          style: TextStyle(color: Colors.white, fontFamily: 'Lato-BoldItalic'),
        ),
        backgroundColor: newnotebuttoncolor,
        onPressed: () async {
          final String title = titleController.text;
          final String description = descriptionController.text;
          var addnote = await postData(title, description);
          print(addnote);
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Homenote(),
              ));
        },
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 100, left: 20, right: 20),
        children: <Widget>[
          TextField(
            controller: titleController,
            style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'New_font'),
            decoration: InputDecoration(hintText: "Title"),
            keyboardType: TextInputType.multiline,
            maxLines: 1,
          ),
          SizedBox(height: 10),
          TextField(
              style: TextStyle(fontFamily: 'New_font'),
              controller: descriptionController,
              decoration: InputDecoration(hintText: "Description"),
              keyboardType: TextInputType.multiline,
              maxLines: null),
        ],
      ),
    );
  }

  final TextEditingController titleController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  Future<List<PostData>> postData(String title, String description) async {
    final String apiUrl = "https://note-api-cynergy.herokuapp.com";
    var body = {
      "title": title,
      "description": description,
    };
    var encodedbody = json.encode(body);
    try {
      var response = await http.post(apiUrl, body: encodedbody, headers: {
        "Accept": "application/json", // Must
        "Content-Type": "application/json" // Must
      });
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("Writen");
        final String responseString = response.body;
        var temp = postDataFromJson(responseString);
        return temp;
      }
    } catch (err) {
      print(err);
    }
  }
}

Color _colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}
