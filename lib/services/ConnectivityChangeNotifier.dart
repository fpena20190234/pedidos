import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

final String serverDown = 'lib/images/serverDown.svg';
final String connected = 'lib/images/connected.svg';
final String noWifi = 'lib/images/noWifi.svg';

class ConnectivityChangeNotifier extends ChangeNotifier {
  ConnectivityChangeNotifier() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      resultHandler(result);
    });
  }

  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  String _svgUrl = serverDown;
  String _pageText =
      'Actualmente conectado a ninguna red. Conéctese a una red wifi!';

  ConnectivityResult get connectivity => _connectivityResult;
  String get svgUrl => _svgUrl;
  String get pageText => _pageText;

  void resultHandler(ConnectivityResult result) {
    _connectivityResult = result;
    if (result == ConnectivityResult.none) {
      _svgUrl = serverDown;

      // _svgUrl = '../../assets/serverDown.svg';
      _pageText =
          'Actualmente no esta conectado a ninguna red. Conéctese a una red wifi!';
    } else if (result == ConnectivityResult.mobile) {
      _svgUrl = noWifi;
      _pageText =
          'Actualmente conectado a una red celular. Conéctese a una red wifi!';
    } else if (result == ConnectivityResult.wifi) {
      _svgUrl = connected;
      _pageText = 'Conectado a una red wifi!';
    }
    notifyListeners();
  }

  void initialLoad() async {
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    resultHandler(connectivityResult);
  }
}
