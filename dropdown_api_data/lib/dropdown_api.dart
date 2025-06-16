import 'dart:convert';
import 'dart:io';

import 'package:dropdown_api_data/Dropdown_model';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DropdownApi extends StatefulWidget {
  const DropdownApi({super.key});

  @override
  State<DropdownApi> createState() => _DropdownApiState();
}

class _DropdownApiState extends State<DropdownApi> {
  Future<List<DropdownModel>> getPost() async {
    try {
      final response = await http.get(
        Uri.parse(' https://jsonplaceholder.typicode.com/posts'),
      );
      final body = json.decode(response.body) as List;

      if (response.statusCode == 200) {
        return body.map((e) {
          final map = e as Map<String, dynamic>;
          return DropdownModel(
            userId: map['userId'],
            id: map['id'],
            title: map['title'],
            body: map['body'],
          );
        }).toList();
      }
    } on SocketException {
      throw Exception('No internet connection');
    }
    throw Exception('Error fetching data');
  }

  var selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dropdown Api' , style: TextStyle(fontSize: 25 , fontWeight: FontWeight.bold),),
      backgroundColor: Colors.pinkAccent,
      centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<List<DropdownModel>>(
              future: getPost(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return DropdownButton(
                    hint: Text('Select value'),
                    isExpanded: true,
                    value: selectedValue,
                    items: snapshot.data!.map((e) {
                      return DropdownMenuItem(
                        value: e.id.toString(),
                        child: Text(e.id.toString()),
                      );
                    }).toList(),

                    onChanged: (value) {
                      selectedValue = value;
                      setState(() {});
                    },
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
