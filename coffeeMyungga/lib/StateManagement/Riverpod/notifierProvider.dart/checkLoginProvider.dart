import 'package:cakeorder/StateManagement/Riverpod/providerImplement.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginProvider extends StateNotifier<bool>
    implements CustomProviderInterface {
  LoginProvider() : super(false);

  bool fetching = false;

  @override
  get dropDownData => throw UnimplementedError();

  @override
  fetchData() {
    //Login check
    //state =.....
  }

  @override
  // TODO: implement getData
  get getData => throw UnimplementedError();

  @override
  // TODO: implement isFetching
  get isFetching => fetching;
}
