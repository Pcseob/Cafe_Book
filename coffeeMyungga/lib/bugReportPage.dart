import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BugReportPage extends StatefulWidget {
  BugReportPage({Key key}) : super(key: key);

  @override
  _BugReportPageState createState() => _BugReportPageState();
}

class _BugReportPageState extends State<BugReportPage> {
  TextEditingController textEditingControllerBug = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          showtDialog();
          textEditingControllerBug.clear();
        },
        child: Icon(
          Icons.add,
          size: 30,
          color: Colors.black,
        ),
      ),
      appBar: AppBar(
        title: Center(
          child: Text(
            "Bug Report.",
          ),
        ),
      ),
      body: setFuturebuilder(),
    );
  }

  fetchData() {
    return FirebaseFirestore.instance
        .collection("BugReport")
        .orderBy("createDate", descending: true)
        .get();
  }

  setFuturebuilder() {
    return FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CupertinoActivityIndicator());
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    children: [
                      Text("데이터 불러오기에 실패하였습니다."),
                      Text("${snapshot.hasError}")
                    ],
                  ),
                );
              } else {
                if (snapshot.data.size == 0) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Container(child: Text("제보된 버그가 없습니다!"))),
                        IconButton(
                            icon: Icon(Icons.add, size: 30),
                            onPressed: () {
                              showtDialog();
                              textEditingControllerBug.clear();
                            })
                      ]);
                }

                return Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.size,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  border:
                                      Border.all(color: Colors.grey, width: 1)),
                              child: ListTile(
                                title: Text(snapshot.data.docs[index]["Bug"]
                                    .toString()),
                              ),
                            );
                          }),
                    ),
                  ],
                );
              }
          }
        });
  }

  void showtDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: MediaQuery.of(context).size.height / 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          icon: Icon(Icons.cancel_outlined, color: Colors.red),
                          onPressed: () => Navigator.pop(context)),
                      Container(
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            "버그 제보하기",
                            style: TextStyle(fontSize: 20),
                          )),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.only(left: 5, right: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black, width: 1)),
                    child: TextField(
                      decoration:
                          InputDecoration(hintText: "최대한 자세하게 작성 부탁드립니다."),
                      controller: textEditingControllerBug,
                      maxLines: 10,
                      minLines: 5,
                    ),
                  ),
                  RaisedButton(
                      child: Text("저장"),
                      onPressed: () {
                        if (textEditingControllerBug.text != "") {
                          FirebaseFirestore.instance
                              .collection("BugReport")
                              .add({
                            "Bug": textEditingControllerBug.text,
                            "createDate": Timestamp.fromDate(DateTime.now()),
                            "isFixed": false
                          }).then((value) {
                            Navigator.pop(context);
                            setState(() {});
                          });
                        }
                      })
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
