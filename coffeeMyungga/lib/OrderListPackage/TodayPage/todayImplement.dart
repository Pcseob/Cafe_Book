import 'package:cakeorder/StateManagement/DeclareData/cakeData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class TodayListImplement {
  //TodayList에서 Provider를 설정하기 위한 부분

  //  StreamProvider<List<CakeData>> initProvier => a;
  //Listview의 UI에 관련된 함수.
  //애니메이션이 있는 ListView
  //https://pub.dev/packages/flutter_staggered_animations 을 사용하였음.
  Widget listViewBuilder(
    List cakeList,
  ) {
    return AnimationLimiter(
      child: ListView.builder(
        itemCount: cakeList.length,
        itemBuilder: (BuildContext context, int index) {
          CakeData currentCakeData = cakeList[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  // secondaryActions: customSwipeIconWidget(index),
                  // dismissal: setSlidableDrawerActionPane(index),
                  child: InkWell(
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 5.h, horizontal: 3.w),
                        // padding: EdgeInsets.only(
                        //     left: 5.w, right: 5.w, top: 3.h),
                        // decoration: setListContainerBoxDecoration(index),
                        // height: MediaQuery.of(context).size.height / 7,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //가격과 케이크 예약수, 전체가격을 보여주는 라인
                            // listViewFirstRow(currentCakeData),
                            //결제상태와 결제수단(현금 카드)
                            listViewSecondRow(currentCakeData),
                            //주문한 날짜와 픽업 날짜
                            listViewThirdRow(currentCakeData),
                            //메모
                            listViewFourthdRow(currentCakeData)
                          ],
                        )),
                  ),

                  //Slidable을 사용할 때 각 리스트마다 구분을 해야하므로 Key가 필요하다.
                  //Firestore의 DocumentId(Primery Key)를 이용하여 Key를 구성함.
                  key: ValueKey(cakeList[index].documentId),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  //첫번째 라인
  listViewFirstRow(OrderCakeData cakeData);
  //두번째 라인
  listViewSecondRow(CakeData cakeData);
  //세번째 라인
  listViewThirdRow(CakeData cakeData);
  //네번째 라인
  listViewFourthdRow(CakeData cakeData);
  // //TodayList에서 Swipe 할 때 어떤 동작을 하는 지 설정하는 곳.
  swipeAction();
}
