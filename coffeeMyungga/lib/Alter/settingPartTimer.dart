import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tip_dialog/tip_dialog.dart';

class SettingPartTimer extends StatefulWidget {
  SettingPartTimer({Key key}) : super(key: key);

  @override
  _SettingPartTimerState createState() => _SettingPartTimerState();
}

class _SettingPartTimerState extends State<SettingPartTimer> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController textEditingController;
  bool createButton;
  List<dynamic> partTimerProvider;
  @override
  void initState() {
    textEditingController = TextEditingController();
    createButton = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    partTimerProvider = Provider.of<List<dynamic>>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("PartTimer Setting"),
      ),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          children: _makePartTimerListTile()..add(_createPartTimer()),
        ),
      ),
    );
  }

  _setSlidableDrawerDismissal(int index) {
    String _partTimerName = partTimerProvider[index];

    return SlidableDismissal(
      child: SlidableDrawerDismissal(
        key: UniqueKey(),
      ),
      onDismissed: (actionType) {
        setState(() {
          partTimerProvider.remove(_partTimerName);
          _firestoreDataUpdate(_partTimerName, isUndo: false);
        });

        _scaffoldKey.currentState
            .showSnackBar(_snackBar(index, _partTimerName));
      },
    );
  }

  Future _firestoreDataUpdate(String partTimerName,
      {@required bool isUndo}) async {
    FirebaseFirestore.instance
        .collection("PartTimer")
        .doc("partTimerDoc")
        .update({"PartTimerList": partTimerProvider});
  }

  _snackBar(int index, String _partTimerName) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: Duration(milliseconds: 1500),
      content: Text('삭제 완료!'),
      action: SnackBarAction(
        label: '취소',
        textColor: Colors.redAccent,
        onPressed: () {
          setState(() {
            partTimerProvider.insert(index, _partTimerName);
            _firestoreDataUpdate(
              _partTimerName,
              isUndo: true,
            );
          });
        },
      ),
    );
  }

  List<Widget> customSwipeIconWidget(int index) {
    String _partTimerName = partTimerProvider[index];
    return [
      IconSlideAction(
        caption: 'Delete!',
        color: Colors.redAccent,
        icon: Icons.delete,
        closeOnTap: false,
        onTap: () {
          setState(() {
            partTimerProvider.remove(_partTimerName);
            _firestoreDataUpdate(_partTimerName, isUndo: false);
          });
          _scaffoldKey.currentState
              .showSnackBar(_snackBar(index, _partTimerName));
        },
      )
    ];
  }

  _createPartTimer() {
    if (createButton) {
      return Container(
          height: 80,
          child: Center(
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  createButton = false;
                });
              },
            ),
          ));
    } else {
      return Container(
          decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(width: 1, color: Colors.black12)),
          margin: EdgeInsets.only(left: 50, right: 50, top: 20, bottom: 20),
          padding: EdgeInsets.only(left: 10),
          child: TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '이름을 작성하세요.',
                hintStyle: TextStyle(color: Colors.grey[300])),
            cursorColor: Colors.blue,
            maxLines: 1,
            textInputAction: TextInputAction.go,
            onSubmitted: (value) {
              setState(() {
                partTimerProvider.add(value);
                _firestoreDataUpdate(value, isUndo: false);
                createButton = true;
                textEditingController.clear();
              });
            },
            controller: textEditingController,
          ));
    }
  }

  _makePartTimerListTile() {
    List<Widget> _list = [];
    if (partTimerProvider != null)
      partTimerProvider.asMap().forEach((index, element) {
        _list.add(Slidable(
          key: ValueKey(element + index.toString()),
          actionPane: SlidableDrawerActionPane(),
          secondaryActions: customSwipeIconWidget(index),
          dismissal: _setSlidableDrawerDismissal(index),
          child: new ListTile(
            leading: Icon(Icons.person),
            title: Text(element),
          ),
        ));
      });
    return _list;
  }
}
