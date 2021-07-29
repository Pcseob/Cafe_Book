import 'package:cakeorder/ProviderPackage/myprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class CustomerPhone extends StatefulWidget {
  final CustomerProvider customerProvider;
  CustomerPhone({Key key, this.customerProvider}) : super(key: key);

  @override
  _CustomerPhoneState createState() => _CustomerPhoneState();
}

class _CustomerPhoneState extends State<CustomerPhone> {
  final _scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  List<int> clickedList = [];

  CustomerProvider customerProvider;
  ScrollController scrollController;
  double deviceHeight;
  double deviceWidth;
  @override
  void initState() {
    super.initState();
    customerProvider = widget.customerProvider;
    customerProvider.fetchNextProducts();
    scrollController = ScrollController(keepScrollOffset: true);
    scrollController.addListener(() {
      print("set new Stream");
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        customerProvider.fetchNextProducts();
      }
    });
  }

  @override
  void didChangeDependencies() {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    bool customerProviderIsEmpty = customerProvider == null;

    return Scaffold(
        key: _scaffoldGlobalKey,
        appBar: AppBar(
          title: Text("About Customer."),
        ),
        // body: setFuturebuilder(),
        body: !customerProviderIsEmpty
            ? limitedScroll()
            : Center(child: Text(CustomerProvider().errorMessage)));
  }

  limitedScroll() {
    return ListView.builder(
        controller: scrollController,
        itemCount: customerProvider.data.length,
        itemBuilder: (BuildContext context, int index) {
          bool isClickedAtLeastOnce = clickedList.contains(index);
          String customerName = customerProvider.data[index].name;
          String customerPhone = customerProvider.data[index].phoneNumber;
          return Container(
            color: isClickedAtLeastOnce ? Colors.yellowAccent : Colors.white,
            height: deviceHeight / 9,
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text(customerName),
              subtitle: Text(customerPhone),
              trailing: GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: customerPhone));
                  _scaffoldGlobalKey.currentState.showSnackBar(SnackBar(
                    content: Text(
                      "$customerName 전화번호 복사 완료!",
                    ),
                    duration: Duration(seconds: 1),
                  ));
                  if (!isClickedAtLeastOnce) {
                    setState(() {
                      clickedList.add(index);
                    });
                  }
                },
                child: Container(
                  width: deviceWidth / 5,
                  height: deviceHeight / 15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.black),
                  child: Center(
                    child: Text(
                      "COPY",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
