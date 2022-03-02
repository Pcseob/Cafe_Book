import 'package:cakeorder/StateManagement/Riverpod/providerImplement.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginProvider extends StateNotifier<bool> {
  LoginProvider() : super(false);

  bool fetching = false;
  bool loginState = false;

  fetchData() {
    state = false;
    //Login check
    //state =.....
  }

  get getData => loginState;

  get isFetching => fetching;
}
