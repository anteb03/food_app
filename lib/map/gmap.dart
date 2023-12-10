import 'package:aplikacija2/pages/products/maincartpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GMap extends StatefulWidget {
  const GMap({super.key});

  @override
  State<GMap> createState() => _GMapState();
}

class _GMapState extends State<GMap> {
  TextEditingController controller = TextEditingController();
  List<dynamic> searchResults = [];

  Future<void> performSearch() async {
    final query = controller.text;
    final response = await http.get(Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json'));

    if (response.statusCode == 200) {
      setState(() {
        searchResults = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load searching results');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSizeCoefficient = screenHeight / 700;
    final paddingCoefficient = screenHeight / 100;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: fontSizeCoefficient * 23,
              ))),
      body: Padding(
        padding: EdgeInsets.all(paddingCoefficient * 2),
        child: Stack(fit: StackFit.expand, children: [
          Column(children: [
            SizedBox(
              width: double.infinity,
              height: 50 * fontSizeCoefficient,
              child: TextField(
                onChanged: (value) {
                  performSearch();
                },
                cursorColor: Colors.black,
                controller: controller,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black, width: 1 * fontSizeCoefficient),
                      borderRadius:
                          BorderRadius.circular(10.0 * fontSizeCoefficient),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black, width: 1 * fontSizeCoefficient),
                      borderRadius:
                          BorderRadius.circular(10.0 * fontSizeCoefficient),
                    ),
                    hintText: "Enter address to deliver",
                    hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: fontSizeCoefficient * 13),
                    prefixIcon: Icon(
                      Icons.location_pin,
                      color: Colors.black,
                      size: fontSizeCoefficient * 22,
                    ),
                    suffixIcon: controller.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear,
                                color: Colors.black,
                                size: fontSizeCoefficient * 15),
                            onPressed: () {
                              setState(() {
                                controller.clear();
                              });
                            },
                          )
                        : null),
              ),
            ),
            SizedBox(
              height: 10 * fontSizeCoefficient,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final result = searchResults[index];
                  return ListTile(
                    title: Text(result['display_name'] ?? ''),
                    subtitle: Text(result['type'] ?? ''),
                    onTap: () {
                      setState(() {
                        controller.text = result['display_name'];
                        searchResults = [];
                      });
                    },
                  );
                },
              ),
            ),
          ]),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: paddingCoefficient * 2,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: () {
                  Cart.getAdress(controller.text);
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  height: fontSizeCoefficient * 60,
                  decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.8),
                      border: Border.all(
                          width: 1, color: Colors.grey.withOpacity(0.85)),
                      borderRadius:
                          BorderRadius.circular(fontSizeCoefficient * 15)),
                  child: Center(
                      child: Text(
                    "Confirm adress !",
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.85),
                        fontSize: fontSizeCoefficient * 15),
                  )),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
