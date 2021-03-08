import 'package:cakeorder/ProviderPackage/cakeDataClass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class BackUpPage extends StatefulWidget {
  BackUpPage({Key key}) : super(key: key);

  @override
  _BackUpPageState createState() => _BackUpPageState();
}

class _BackUpPageState extends State<BackUpPage> {
  ScrollController scrollController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<CakeData> cakeList = [];
  bool isDone;
  bool hasError;
  @override
  void initState() {
    super.initState();
    isDone = false;
    hasError = false;
    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    cakeList =
        Provider.of<List<CakeDataCalendarPickUp>>(context, listen: false);
    // storeData();
    // delete();
    return Scaffold(
        key: scaffoldKey,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: RaisedButton(
                      onPressed: () {
                        scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text("현재는 비활성화 되어있습니다."),
                        ));
                        return null;
                        // storeData();
                        // setState(() {});
                      },
                      child: Text("BackUp")),
                ),
                RaisedButton(
                  onPressed: () {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text("현재는 비활성화 되어있습니다."),
                    ));
                    // deleteBackUpFile();
                  },
                  child: Text("DELETED"),
                ),
                RaisedButton(
                  onPressed: () {
                    // toFireBase();
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text("현재는 비활성화 되어있습니다."),
                    ));
                  },
                  child: Text("To Firebase"),
                ),
                FutureBuilder(
                  future: checkBackUpFile(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return CupertinoActivityIndicator();
                      default:
                        if (snapshot.hasError) {
                          return Center(
                              child: Column(
                            children: [
                              Text("Something Error"),
                              Text(snapshot.error.toString()),
                            ],
                          ));
                        } else {
                          print(snapshot.data);
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data ?? "Empty",
                              style: TextStyle(fontSize: 10),
                            );
                          }
                        }
                    }
                  },
                )
                //         FutureBuilder(
                //   future: storeData(),
                //   builder: (context, snapshot) {
                //         switch (snapshot.connectionState) {
                //           case ConnectionState.none:
                //           case ConnectionState.waiting:
                //             return Center(child: CupertinoActivityIndicator());
                //           default:
                //             if (snapshot.hasError) {
                //               return Center(
                //                   child: Column(
                //                 children: [
                //                   Text("Something Error"),
                //                   Text(snapshot.error.toString()),
                //                 ],
                //               ));
                //             } else {
                //               readCounter();
                //               return Center(child: Text("Done"));
                //             }
                //         }
                //   },
                // ),
              ],
            ),
          ),
        ));
  }

  Future storeData() async {
    int i = 0;
    String stringData = '';
    if (cakeList.isNotEmpty)
      cakeList.forEach((element) {
        print(i++);
        String parseString = element.cakeDataToParseString;
        stringData += parseString;
        // print(parseString);
      });
    return await writeCounter(stringData)
        .then((value) {
          print(value.toString());
        })
        .catchError((onError) {})
        .whenComplete(() {
          return true;
          // print("hi2");
        });

    // await writeCounter(
    //         "?cake=딸기케이크&cakeSize=1호?cake=단호박케이크&cakeSize=1호?cake=초코케이크&cakeSize=1호")
    //     .then((value) {
    //   print("Done");
    // });
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/test.txt');
  }

  checkBackUpFile() async {
    final file = await _localFile;
    // print(File('$path/test.txt').existsSync().toString());
    return await file.readAsString();
  }

  Future<File> writeCounter(String counter) async {
    final file = await _localFile;

    // 파일 쓰기
    return file.writeAsString('$counter');
  }

  Future<int> toFireBase() async {
    try {
      final file = await _localFile;

      // 파일 읽기.
      String contents = await file.readAsString();
      // print(contents);
      contents.split('?').forEach((element) async {
        CakeData cakeData = CakeData.fromStringCakeDataToCakeData(element);
        if (cakeData != null)
          await cakeData
              .toFireStore()
              .then((value) => null)
              .catchError((error) {
            print(error);
            // setState(() {
            //   isDone = false;
            //   hasError = true;
            // });
          }).whenComplete(() => null);
      });
    } catch (e) {
      // 에러가 발생할 경우 0을 반환.
      // return 0;
      print("error");
    }
  }

  Future<int> deleteBackUpFile() async {
    try {
      final file = await _localFile;

      // 파일 읽기.

      await file.delete();

      setState(() {});

      // return int.parse(contents);
      print("Deleted");
    } catch (e) {
      // 에러가 발생할 경우 0을 반환.
      // return 0;
      print("error");
    }
  }
}
