import 'dart:async';
import 'dart:convert';

import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

import '../../../services/database.dart';

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
  List<double> plotValues = [];
  int pos = -1;
  double? width;
  double? height;
  int canPlot = -1;

  final StreamController<Map> _streamController = StreamController();

  Future<void> fetchData() async {
    final response = await get(Uri.parse(widget.url));
    if (response.statusCode == 200) {
      Map sheetData = jsonDecode(response.body);
      try {
        _streamController.sink.add(sheetData);
      } catch (e) {}
    }
  }

  @override
  void initState() {
    //print(widget.url);
    Timer.periodic(Duration(seconds: 5), (timer) {
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
      pos;
      plotValues;
      canPlot;
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      width = MediaQuery.of(context).size.width.round() - 20 as double?;
      height = (width! * 0.7) - 70;
      plotValues;
      canPlot;
    });

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.redAccent,
        elevation: 0.0,
        title: Text(widget.sheetName),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: SizedBox(
                          height: 180,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Sheet name:",
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          widget.sheetName,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: Colors.black38,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                          splashRadius: 15.0,
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(
                                                text: widget.sheetName)).whenComplete(() {
                                              final snackBar = SnackBar(
                                                content: Text(
                                                  'Script name copied to clipboard',
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                backgroundColor: Colors.green,
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            });
                                          },
                                          icon: Icon(
                                            Icons.copy,
                                            color: Colors.redAccent,
                                          ))
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Sheet script link:",
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          widget.url,
                                          maxLines: 3,
                                          style: TextStyle(
                                            color: Colors.black38,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                          splashRadius: 15.0,
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(
                                                    text: widget.url))
                                                .whenComplete(() {
                                              final snackBar = SnackBar(
                                                content: Text(
                                                  'Script link copied to clipboard',
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                backgroundColor: Colors.green,
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            });
                                          },
                                          icon: Icon(
                                            Icons.copy,
                                            color: Colors.redAccent,
                                          ))
                                    ],
                                  ),
                                ),
                                IconButton(
                                    splashRadius: 1.0,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icon(
                                      Icons.cancel_rounded,
                                      size: 35,
                                      color: Colors.redAccent,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
              icon: Icon(Icons.info_outline_rounded),
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: IconButton(
                onPressed: () async {
                  //await _auth.signOut();
                  try {
                    await DatabaseService(uid: widget.uid)
                        .deleteLink(widget.sheetName)
                        .whenComplete(() {
                      final snackBar = SnackBar(
                        content: Text(
                          'Removed ${widget.sheetName}',
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: Colors.red,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    });
                    dispose();
                    Navigator.pop(context);
                  } catch (e) {
                    final snackBar = SnackBar(
                      content: Text(
                        'Problem occurred, try later ',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: Colors.red,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                icon: Icon(
                  Icons.delete_outline_outlined,
                  color: Colors.white,
                )),
          ),
        ],
      ),
      body: Column(children: [
        StreamBuilder<Map>(
            stream: _streamController.stream,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Center(child: Text('No Connection Message'));
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
                    String? selectedItem;
                    if (pos != -1) {
                      try {
                        double value = double.parse(values[pos]);
                        plotValues.add(value);
                        canPlot = 1;
                        print(plotValues);
                      } catch (e) {
                        //print("cant parse");
                        canPlot = 2;
                      }
                    }

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
                      SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 40),
                        child: Center(
                          child: SizedBox(
                            height: 50,
                            child: DropdownButtonFormField<String>(
                              focusColor: Color(0x0000ffff),
                              iconEnabledColor: Colors.redAccent,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.add_chart,
                                    size: 24,
                                    color: Colors.redAccent,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.redAccent[200]!,
                                        width: 2.0),
                                  )),
                              value: selectedItem,
                              hint: Text("Select a chart attribute"),
                              items: headers
                                  .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: TextStyle(fontSize: 15),
                                      )))
                                  .toList(),
                              onChanged: (String? item) {
                                setState(() {
                                  selectedItem = item;
                                  plotValues.clear();
                                  pos = headers
                                      .indexWhere((element) => element == item);
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //Text(plotValues.toString()),
                      if (canPlot == 1)
                        Center(
                          child: SizedBox(
                            width: width,
                            height: height,
                            child: Card(
                              elevation: 6,
                              color: Color(0xFFF1F1F1),
                              shadowColor: Color(0xFF363535),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8, 10, 2, 12),
                                child: Sparkline(
                                  lineColor: Colors.black38,
                                  pointsMode: PointsMode.last,
                                  pointSize: 5.0,
                                  lineWidth: 2.0,
                                  pointColor: Colors.redAccent,
                                  kLine: const ['max', 'min', 'first', 'last'],
                                  enableGridLines: true,
                                  data: plotValues,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (canPlot == 2)
                        Center(
                          child: Text(
                            "Can only plot values!",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.red,
                            ),
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
