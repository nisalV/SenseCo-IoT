import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class SheetData extends StatefulWidget {
  final String uid;
  final String sheetName;
  final String url;

  const SheetData(this.uid, this.sheetName, this.url, {Key? key})
      : super(key: key);

  @override
  _SheetDataState createState() => _SheetDataState();
}

class _SheetDataState extends State<SheetData> {
  Map data = {};
  List headers = [];
  List values = [];

  final StreamController<Map> _streamController = StreamController();

  Future<void> fetchData() async {
    final response = await get(Uri.parse(widget.url));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map sheetData = jsonDecode(response.body);
      try {
        _streamController.sink.add(sheetData);
      } catch (e) {
      }
    }
  }

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 10), (timer) {
      fetchData();
    });
    super.initState();
  }

  @override
  void dispose() {
    closeStream();
    super.dispose();
  }

  Future<void> closeStream() async {
    try {
      await _streamController.close();
    } catch (error) {
      //print(error);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      headers;
      values;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        elevation: 0.0,
        title: Text(widget.sheetName),
      ),
      body: Column(children: [
        StreamBuilder<Map>(
            stream: _streamController.stream,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error occurred!"),
                    );
                  } else {
                    headers = snapshot.data!.keys.toList();
                    values = snapshot.data!.values.toList();
                    print(values.toString());
                    return Column(children: [
                      SizedBox(
                        height: 6,
                      ),
                      SizedBox(
                        height: 90,
                        child: ListView.builder(
                          
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: headers.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Center(
                              child: Card(
                                  child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(headers[index],
                                          style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w900,
                                          )),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(values[index],
                                          style: TextStyle(
                                            color: Color(0xFF4BC95C),
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.w900,
                                          ))
                                    ],
                                  ),
                                ),
                              )),
                            );
                          },
                        ),
                      ),
                    ]);
                  }
              }
            }),
      ]),
    );
  }
}
