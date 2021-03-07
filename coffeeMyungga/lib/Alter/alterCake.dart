import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CakeSetting extends StatefulWidget {
  CakeSetting({Key key}) : super(key: key);

  @override
  _CakeSettingState createState() => _CakeSettingState();
}

class _CakeSettingState extends State<CakeSetting> {
  final GlobalKey<ScaffoldState> _scaffoldGlobalKey =
      GlobalKey<ScaffoldState>();
  TextEditingController textEditingControllerCakeName;

  bool createButton;
  int cakeListCount;
  bool isEmptyTextField;
  Map<String, dynamic> cakeSizePriceData = {};
  List<String> saveCakeSizeList;
  List<dynamic> saveCakePriceList;
  @override
  void initState() {
    super.initState();
    // _textEditingInitNDispose(true);
    textEditingControllerCakeName = TextEditingController();
    createButton = true;
    cakeListCount = 1;
    saveCakeSizeList = [];
    saveCakePriceList = [];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldGlobalKey,
      appBar: AppBar(
        title: Text("Cake Setting"),
      ),
      body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: setFuturebuilder()),
    );
  }

  Future fetchData() {
    final _db = FirebaseFirestore.instance;

    return _db.collection("CakeList").get();
  }

  Widget setFuturebuilder() {
    return FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(
                child: CupertinoActivityIndicator(),
              );
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
                var cakeListSnapshot = snapshot.data.docs;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.size,
                          itemBuilder: (BuildContext context, int index) {
                            return Slidable(
                              closeOnScroll: true,
                              dismissal: SlidableDismissal(
                                child: SlidableDrawerDismissal(
                                  key: UniqueKey(),
                                ),
                                onDismissed: (actionType) {
                                  setState(() {
                                    _firestoreDataUpdate(
                                        cakeListSnapshot[index],
                                        isUndo: false);
                                  });
                                  _scaffoldGlobalKey.currentState.showSnackBar(
                                      _snackBar(cakeListSnapshot[index]));
                                },
                              ),
                              actionPane: SlidableDrawerActionPane(),
                              secondaryActions: customSwipeIconWidget(
                                  cakeListSnapshot[index]),
                              key: ValueKey(index.toString()),
                              child: ListTile(
                                onTap: () {
                                  showAlertDialog(
                                      cakeData: cakeListSnapshot[index]);
                                },
                                leading: Icon(Icons.cake_outlined),
                                title: Text(cakeListSnapshot[index].id),
                                subtitle: Text(cakeListSnapshot[index]
                                        ["CakePrice"]
                                    .toString()
                                    .split('')
                                    .getRange(
                                        1,
                                        cakeListSnapshot[index]["CakePrice"]
                                                .toString()
                                                .length -
                                            1)
                                    .join()),
                              ),
                            );
                          }),
                    ),
                    Center(
                      child: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => showAlertDialog()),
                    )
                  ],
                );
              }
          }
        });
  }

  List<Widget> customSwipeIconWidget(var data) {
    return [
      IconSlideAction(
        caption: 'Delete!',
        color: Colors.redAccent,
        icon: Icons.delete,
        closeOnTap: false,
        onTap: () {
          setState(() {
            _firestoreDataUpdate(data, isUndo: false);
          });
          _scaffoldGlobalKey.currentState.showSnackBar(_snackBar(data));
        },
      )
    ];
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void showAlertDialog({var cakeData}) async {
    bool isAlter = cakeData != null ? true : false;
    textEditingControllerCakeName..text = isAlter ? cakeData.id : "";
    if (cakeData != null) {
      saveCakePriceList = cakeData["CakePrice"].values.toList();
      saveCakeSizeList = cakeData["CakePrice"].keys.toList();
    }

    cakeListCount = 1;
    if (cakeData != null) cakeListCount = cakeData["CakePrice"].keys.length;
    await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => StatefulBuilder(
                  builder: (BuildContext context, setState) => new Dialog(
                    child:
                        // Scaffold(
                        //   key: _scaffoldKey,
                        //   body:
                        Container(
                      // padding: EdgeInsets.all(5),
                      // width: MediaQuery.of(context).size.width / 1.3,
                      // width: double.infinity,
                      height: MediaQuery.of(context).size.height / 2,
                      // height: double.infinity,
                      child: Scaffold(
                        key: _scaffoldKey,
                        body: SingleChildScrollView(
                          child: Stack(children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 15, left: 5),
                                  child: Text("케이크 이름",
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 5),
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 2),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: TextFormField(
                                      controller: textEditingControllerCakeName,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "케이크 이름")),
                                ),
                              ]
                                // ..addAll(widgetList)
                                ..addAll(_dialogCakeSizePriceLine(
                                    cakeListCount, setState,
                                    cakeData: cakeData)),
                            ),
                            Positioned(
                              left: MediaQuery.of(context).size.width / 1.5,
                              child: IconButton(
                                icon: Icon(
                                  Icons.cancel_outlined,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                            )
                          ]),
                        ),
                      ),
                    ),
                  ),
                ))

        // content: Container(

        //   decoration: new BoxDecoration(
        //     shape: BoxShape.rectangle,
        //     color: const Color(0xFFFFFF),
        //     borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
        //   ),
        //   child: //Contents here
        // ),
        .then((value) => null)
        .whenComplete(() {
      setState(() {});
    });
  }

  _dialogCakeSizePriceLine(int size, Function setState, {var cakeData}) {
    List<Widget> widgetList = [];

    for (int i = 0; i < size; i++) {
      widgetList
          .add(_setCakeSizePriceContainer(i, setState, cakeData: cakeData));
    }
    return widgetList
      ..add(Column(children: [
        Center(
            child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    FocusScope.of(context).unfocus();
                    cakeListCount += 1;
                  });
                })),
        Center(
          child: RaisedButton(
            color: Colors.white,
            child: Text(
              "저장",
              style: TextStyle(color: Colors.redAccent),
            ),
            onPressed: () async {
              FocusScope.of(context).unfocus();
              saveCakeSizeList.forEach((element) {
                print(element);
              });
              saveCakePriceList.forEach((element) {
                print(element);
              });
              if (checkSaveData())
                await saveCakeData(
                        cakeId: cakeData != null ? cakeData.id : null)
                    .then((value) => null)
                    .whenComplete(() => Navigator.pop(context));
            },
          ),
        )
      ]));
  }

  _setCakeSizePriceContainer(int number, Function setState, {var cakeData}) {
    bool isAlter = cakeData != null ? true : false;
    String initialvalueCakePrice = "";
    String initialvalueCakeSize = "";
    if (isAlter) {
      if (saveCakePriceList.length > number) {
        initialvalueCakePrice = saveCakePriceList[number].toString();
        initialvalueCakeSize = saveCakeSizeList[number].toString();
      }
    }

    return Slidable(
      closeOnScroll: true,
      secondaryActions: [
        IconSlideAction(
          caption: 'Delete!',
          color: Colors.redAccent,
          icon: Icons.delete,
          closeOnTap: true,
          onTap: () async {
            setState(() {
              if (isAlter) {
                if (saveCakePriceList.length > number) {
                  saveCakePriceList.removeAt(number);
                  saveCakeSizeList.removeAt(number);
                }
                // if (checkSaveData()) saveCakeData(cakeId: cakeData.id);
              }

              cakeListCount -= 1;
            });
          },
        )
      ],
      actionPane: SlidableDrawerActionPane(),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            margin: EdgeInsets.only(left: 10),
            width: MediaQuery.of(context).size.width / 3.5,
            child: TextFormField(
              key: ValueKey("Price${number.toString}"),
              initialValue: initialvalueCakeSize,
              decoration: new InputDecoration(
                hintText: "케이크 사이즈",
                hintStyle: TextStyle(fontSize: 13),
              ),
              onChanged: (value) {
                if (saveCakeSizeList.length >= number + 1) {
                  saveCakeSizeList.removeAt(number);
                }
                saveCakeSizeList.insert(number, value);
                saveCakeSizeList.forEach((element) {
                  print("here : " + element.toString());
                });
              },
            )),
        Container(
            margin: EdgeInsets.only(left: 8),
            width: MediaQuery.of(context).size.width / 3.5,
            child: TextFormField(
              key: ValueKey("Size${number.toString}"),
              keyboardType: TextInputType.number,
              initialValue: initialvalueCakePrice,
              decoration: new InputDecoration(
                hintText: "케이크 가격",
                hintStyle: TextStyle(fontSize: 13),
              ),
              onChanged: (value) {
                if (saveCakePriceList.length >= number + 1) {
                  saveCakePriceList.removeAt(number);
                }
                saveCakePriceList.insert(number, value);
                saveCakePriceList.forEach((element) {
                  print("here : " + element.toString());
                });
              },
            )),
      ]),
    );
  }

  Future saveCakeData({String cakeId}) {
    Map saveCakeData = {};
    saveCakeSizeList.asMap().forEach((index, element) {
      saveCakeData.addAll({element: saveCakePriceList[index]});
    });
    if (cakeId != null) {
      if (cakeId != textEditingControllerCakeName.text)
        FirebaseFirestore.instance.collection("CakeList").doc(cakeId).delete();
    }
    return FirebaseFirestore.instance
        .collection("CakeList")
        .doc(textEditingControllerCakeName.text)
        .set({"CakePrice": saveCakeData});
  }

  bool checkSaveData() {
    print("cakeListCount : " + cakeListCount.toString());
    print("saveCakePriceList : " + saveCakePriceList.length.toString());
    print(cakeListCount == saveCakeSizeList.length);
    saveCakeSizeList.forEach((element) {
      print("Element : " + element.toString());
    });

    if (cakeListCount == saveCakePriceList.length) {
      if (cakeListCount == saveCakeSizeList.length) {
        if (!saveCakePriceList.contains('')) {
          if (!saveCakeSizeList.contains('')) return true;
        }
      }
    }
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("빈칸이 있는지 확인 해 주세요!"),
      duration: Duration(seconds: 1),
    ));
    return false;
  }

  _snackBar(var cakeData) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: Duration(milliseconds: 1500),
      content: Text('삭제 완료!'),
      action: SnackBarAction(
        label: '취소',
        textColor: Colors.redAccent,
        onPressed: () {
          setState(() {
            // partTimerProvider.insert(index, _partTimerName);
            _firestoreDataUpdate(
              cakeData,
              isUndo: true,
            );
          });
        },
      ),
    );
  }

  Future _firestoreDataUpdate(var cakeData, {@required bool isUndo}) async {
    if (!isUndo)
      FirebaseFirestore.instance
          .collection("CakeList")
          .doc(cakeData.id)
          .delete();
    else
      FirebaseFirestore.instance
          .collection("CakeList")
          .doc(cakeData.id)
          .set({"CakePrice": cakeData["CakePrice"]});
  }
}
