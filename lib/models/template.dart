import 'package:flutter/material.dart';
import "dart:collection";
import 'dart:convert';

class Note {
  // Getting the Note
  Note({
    @required this.title,
    @required this.description,
    @required this.id,
  });

  String title;
  String description;
  String id;
}

List<PostData> postDataFromJson(String str) =>
    List<PostData>.from(json.decode(str).map((x) => PostData.fromJson(x)));

String postDataToJson(List<PostData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostData {
  PostData({
    this.id,
    this.title,
    this.description,
    this.v,
  });

  String id;
  String title;
  String description;
  int v;

  factory PostData.fromJson(Map<String, dynamic> json) => PostData(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "__v": v,
      };
}
