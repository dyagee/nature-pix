import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;

  // optional list of functions to call on connection available/restored.
  final List<VoidCallback>? onConnectionRestored;

  const ConnectivityWrapper(
      {super.key, required this.child, this.onConnectionRestored});

  // Expose a static ValueNotifier for connection status
  static final ValueNotifier<bool> connectionStatus = ValueNotifier(true);

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _isOffline = false;

  bool _initialCheckDone = false;

  // boolean variables used to show full overlay
  // bool _showOnlineOverlay = false;
  SnackBar? _snackBar;

  @override
  void initState() {
    super.initState();
    _checkInitialConnection();
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      final result =
          results.isNotEmpty ? results.first : ConnectivityResult.none;
      _updateConnectionStatus(result);
    });
  }

  Future<void> _checkInitialConnection() async {
    final results = await Connectivity().checkConnectivity();
    final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
    _updateConnectionStatus(result, isInitial: true);
  }

  void _updateConnectionStatus(ConnectivityResult result,
      {bool isInitial = false}) {
    final isOffline = result == ConnectivityResult.none;

    // Notify listeners for connection status
    ConnectivityWrapper.connectionStatus.value =
        result != ConnectivityResult.none;

    if (_isOffline != isOffline || isInitial) {
      setState(() {
        _isOffline = isOffline;
        _initialCheckDone = true;
        // _showOnlineOverlay = !isOffline && !isInitial;
      });

      if (isOffline) {
        // First hide the red one if visible
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        _showDisconnectedSnackBar();
      }
      if (!isInitial && !isOffline) {
        // First hide the red one if visible
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        _showReconnectedSnackBar();

        // delay for connection available notice to pop
        if (widget.onConnectionRestored != null) {
          Future.delayed(const Duration(seconds: 4), () {
            for (var callback in widget.onConnectionRestored!) {
              callback();
            }
          });
        }
      }

      if (isInitial && !isOffline) {
        if (widget.onConnectionRestored != null) {
          for (var callback in widget.onConnectionRestored!) {
            callback();
          }
        }
      }

      // if (_showOnlineOverlay) {
      //   Future.delayed(const Duration(seconds: 3), () {
      //     if (mounted) {
      //       setState(() {
      //         _showOnlineOverlay = false;
      //       });
      //     }
      //   });
      // }
    }
  }

  // void _retryConnection() async {
  //   final results = await Connectivity().checkConnectivity();
  //   final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
  //   _updateConnectionStatus(result);
  // }

  void _showDisconnectedSnackBar() {
    _snackBar = const SnackBar(
      content: Row(
        children: [
          Icon(Icons.wifi_off, color: Colors.white),
          SizedBox(width: 10),
          Text('No Internet Connection'),
        ],
      ),
      backgroundColor: Colors.red,
      duration: Duration(days: 1), // persistent
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(_snackBar!);
  }

  void _showReconnectedSnackBar() {
    const snackBar = SnackBar(
      content: Row(
        children: [
          Icon(Icons.wifi, color: Colors.white),
          SizedBox(width: 10),
          Text('Connection Restored'),
        ],
      ),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialCheckDone) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return widget.child;
    // return Stack(
    //   children: [
    //     if (!_isOffline) widget.child,
    //     if (_isOffline) _buildOfflineOverlay(),
    //     if (_showOnlineOverlay) _buildOnlineOverlay(),
    //   ],
    // );
  }

  /// Custom widgets
  // Widget _buildOfflineOverlay() {
  //   return Container(
  //     color: Colors.red.shade600,
  //     width: double.infinity,
  //     height: double.infinity,
  //     alignment: Alignment.center,
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         const Icon(Icons.wifi_off, size: 64, color: Colors.white),
  //         const SizedBox(height: 12),
  //         const Text(
  //           "No Internet Connection",
  //           style: TextStyle(
  //               fontSize: 20,
  //               color: Colors.white,
  //               decoration: TextDecoration.none),
  //         ),
  //         const SizedBox(height: 16),
  //         ElevatedButton.icon(
  //           onPressed: _retryConnection,
  //           icon: const Icon(Icons.refresh),
  //           label: const Text("Retry"),
  //           style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.white, foregroundColor: Colors.red),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildOnlineOverlay() {
  //   return Container(
  //     color: Colors.green.shade600,
  //     width: double.infinity,
  //     height: double.infinity,
  //     alignment: Alignment.center,
  //     child: const Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Icon(Icons.wifi, size: 64, color: Colors.white),
  //         SizedBox(height: 12),
  //         Text(
  //           "Back Online",
  //           style: TextStyle(
  //               fontSize: 20,
  //               color: Colors.white,
  //               decoration: TextDecoration.none),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
