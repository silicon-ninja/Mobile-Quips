import 'package:flutter/material.dart';
import 'package:notes_app/Note.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'models/template.dart';
import 'upnote.dart';

class Homenote extends StatefulWidget {
  @override
  _HomenoteState createState() => _HomenoteState();
}

class _HomenoteState extends State<Homenote> {
  List<Note> notes = [];
  List<Note> searchnotes = [];

  @override
  Widget build(BuildContext context) {
    Color backgroundcolour = _colorFromHex("e3dfc8");
    Color newnotebuttoncolor = _colorFromHex("43658b");
    Color cardcolor = _colorFromHex("ffd571");
    Color cardbackgroudcolor = _colorFromHex("ffb271");
    //Color newnotebuttoncolor = _colorFromHex("43658b");
    return Scaffold(
        backgroundColor: backgroundcolour,
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(
            Icons.message,
            color: Colors.white,
          ),
          label: Text(
            'New Note',
            style:
                TextStyle(fontFamily: 'Lato-BoldItalic', color: Colors.white),
          ),
          backgroundColor: newnotebuttoncolor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Newnote()),
            );
          },
        ),
        body: Container(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 50, left: 80, bottom: 10),
                    child: Center(
                      child: Text(
                        "Quips",
                        style: TextStyle(
                          fontFamily: 'CinderelaPersonalUseRegular-RDvM',
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 70,
                  ),
                  /*Container(
                        padding: EdgeInsets.only(top: 50, left: 10),
                        child: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              _searchBar();
                            })),*/
                ],
              ),
              FutureBuilder(
                future: loadData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 0),
                        alignment: Alignment(-2, -1.1),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              child: Dismissible(
                                background: Container(
                                  color: Colors.amber,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Icon(
                                    Icons.star,
                                    color: Colors.white,
                                  ),
                                ),
                                secondaryBackground: Container(
                                  color: Colors.red[400],
                                  padding: EdgeInsets.all(20),
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                key: Key(snapshot.data[index].title),
                                child: GestureDetector(
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditNote(snapshot.data[index])),
                                    );
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Row(),
                                      Container(
                                        width: 400,
                                        height: 130,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(25),
                                                topRight: Radius.circular(25),
                                                bottomRight:
                                                    Radius.circular(25),
                                                bottomLeft: Radius.circular(25),
                                              ),
                                              side: BorderSide(
                                                  width: 1.5,
                                                  color: cardbackgroudcolor)),
                                          color: cardcolor,
                                          margin: EdgeInsets.only(
                                              top: 10,
                                              bottom: 10,
                                              left: 20,
                                              right: 20),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 40),
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                  snapshot.data[index].title,
                                                  style: TextStyle(
                                                      fontFamily: 'Note_font',
                                                      fontSize: 25.0,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onDismissed: (DismissDirection dir) async {
                                  await deletePost(snapshot.data[index].id);
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                          dir == DismissDirection.endToStart
                                              ? "Note Deleted"
                                              : "Note Marked"),
                                      action: SnackBarAction(
                                        label: "UNDO",
                                        onPressed: () {
                                          print("hello");
                                          setState(() {
                                            print(snapshot.data);
                                            snapshot.data.insert();
                                          });
                                        },
                                      )));
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("No Network"), heightFactor: 33);
                  } else if (snapshot.hasData == null) {
                    /////////TODO
                    return Center(
                        child: Text("You don't have any notes yet"),
                        heightFactor: 33);
                  } else {
                    return Container(width: 0, height: 0);
                  }
                },
              ),
            ],
          ),
        )));
  }

  Future<List<Note>> loadData() async {
    Response response =
        await http.get('https://note-api-cynergy.herokuapp.com');
    if (response.statusCode == 200) {
      List<Note> notes = [];
      List<dynamic> data = jsonDecode(response.body);
      for (int i = 0; i < data.length; i++) {
        notes.add(
          Note(
              title: data[i]["title"],
              id: data[i]["_id"],
              description: data[i]["description"]),
        );
      }
      return notes;
    } else {
      throw Exception('Failed to load internet');
    }
  }

  Future<List<Note>> deletePost(String id) async {
    Response delres =
        await http.delete('https://note-api-cynergy.herokuapp.com/?id=$id');
    if (delres.statusCode == 200) {
      print("Deleted");
    } else {
      print("Not Possiable");
    }
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(hintText: "Search"),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            searchnotes = notes.where((note) {
              var notetitle = note.title.toLowerCase();
              return notetitle.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

//   @override
//   void initState() {
//     loadData().then((value) {
//       setState(() {
//         notes.addAll(value);
//         searchnotes = notes;
//       });
//     });
//   }
// }

  Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}
