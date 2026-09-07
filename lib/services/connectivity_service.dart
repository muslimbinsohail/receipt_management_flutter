import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

/// Real-time connectivity monitoring service
class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  final RxBool isConnected = false.obs;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  Timer? _periodicCheck;

  @override
  void onInit() {
    super.onInit();
    _checkConnectivity();
    _subscription = _connectivity.onConnectivityChanged.listen(_onChanged);

    // Periodic real internet check every 30 seconds
    _periodicCheck = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _checkRealInternet(),
    );
  }

  void _onChanged(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.none)) {
      isConnected.value = false;
    } else {
      // Have a connection type, verify actual internet
      _checkRealInternet();
    }
  }

  Future<void> _checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    if (results.contains(ConnectivityResult.none)) {
      isConnected.value = false;
    } else {
      await _checkRealInternet();
    }
  }

  /// Verify actual internet connectivity via DNS lookup
  Future<void> _checkRealInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      isConnected.value = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isConnected.value = false;
    } on TimeoutException catch (_) {
      isConnected.value = false;
    } catch (_) {
      isConnected.value = false;
    }
  }

  /// Force a connectivity check
  Future<bool> forceCheck() async {
    await _checkRealInternet();
    return isConnected.value;
  }

  @override
  void onClose() {
    _subscription?.cancel();
    _periodicCheck?.cancel();
    super.onClose();
  }
}
