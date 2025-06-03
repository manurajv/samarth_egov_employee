import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart' as ConnectivityResult;
import 'package:flutter/foundation.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }
}