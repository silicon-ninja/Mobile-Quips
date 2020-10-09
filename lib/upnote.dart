import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'models/template.dart';
import 'Home.dart';
import 'dart:async';
import 'dart:convert';

class EditNote extends StatefulWidget {
  final Note thedata;
  EditNote(this.thedata);

  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  Color newnotebuttoncolor = _colorFromHex("43658b");
  Widget build(BuildContext context) {
    TextEditingController titleController =
        TextEditingController(text: widget.thedata.title);
    TextEditingController descriptionController =
        TextEditingController(text: widget.thedata.description);

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
          var patchnote =
              await patchPost(widget.thedata.id, title, description);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Homenote()),
          );
        },
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 100, left: 20, right: 20),
        children: <Widget>[
          TextField(
            controller: titleController,
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            decoration: InputDecoration(),
            keyboardType: TextInputType.multiline,
            maxLines: 1,
          ),
          SizedBox(height: 10),
          TextField(
              controller: descriptionController,
              decoration: InputDecoration(hintText: "Description"),
              keyboardType: TextInputType.multiline,
              maxLines: null),
        ],
      ),
    );
  }

  Future<List<Note>> patchPost(
      String id, String title, String description) async {
    final String apiUrl = "https://note-api-cynergy.herokuapp.com/?id=$id";
    var body = {
      "title": title,
      "description": description,
    };
    var encodedbody = json.encode(body);
    Response patch = await http.patch(apiUrl, body: encodedbody, headers: {
      "Accept": "application/json", // Must
      "Content-Type": "application/json" // Must
    });
    if (patch.statusCode == 200) {
      print("patched");
    } else {
      print("Not Patched");
    }
  }
}

Color _colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}
