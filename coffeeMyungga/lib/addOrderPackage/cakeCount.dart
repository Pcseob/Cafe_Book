import 'package:flutter/material.dart';

class CakeCountWidget {
  int cakeCount;
  Function callback;
  final bool isDetailPage;
  CakeCountWidget({this.cakeCount, this.callback, this.isDetailPage});

  Widget countWidget({bool isvisible}) {
    cakeCount = cakeCount ?? 0;
    isvisible = isvisible ?? false;
    return Visibility(
      visible: isvisible,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 15),
            child: Text(
              '수량',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            // margin: EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: !isDetailPage
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.center,
              children: [_minusButton(), _countTextField(), _plusButton()],
            ),
          ),
        ],
      ),
    );
  }

  _minusButton() {
    return !isDetailPage
        ? Visibility(
            visible: cakeCount > 1,
            child: Container(
                child: IconButton(
              icon: Icon(Icons.horizontal_rule),
              onPressed: () {
                callback(--cakeCount);
              },
            )))
        : Container();
  }

  _countTextField() {
    String _text =
        !isDetailPage ? cakeCount.toString() : cakeCount.toString() + "개";
    return Container(
        child: Text(
      _text,
      style: TextStyle(
          fontSize: !isDetailPage ? 13 : 15, fontWeight: FontWeight.bold),
    ));
  }

  _plusButton() {
    return !isDetailPage
        ? Container(
            child: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              callback(++cakeCount);
            },
          ))
        : Container();
  }
}
