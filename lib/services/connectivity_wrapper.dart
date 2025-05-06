import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;

  // optional list of functions to call on connection available/restored.
  final List<VoidCallback>? onConnectionRestored;

  const ConnectivityWrapper(
      {super.key, required this.child, this.onConnectionRestored});

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _isOffline = false;
  bool _initialCheckDone = false;
  bool _showOnlineOverlay = false;

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

    if (_isOffline != isOffline || isInitial) {
      setState(() {
        _isOffline = isOffline;
        _initialCheckDone = true;
        _showOnlineOverlay = !isOffline && !isInitial;
      });

      if (!isOffline && widget.onConnectionRestored != null) {
        for (var callback in widget.onConnectionRestored!) {
          callback();
        }
      }

      if (_showOnlineOverlay) {
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _showOnlineOverlay = false;
            });
          }
        });
      }
    }
  }

  void _retryConnection() async {
    final results = await Connectivity().checkConnectivity();
    final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
    _updateConnectionStatus(result);
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

    return Stack(
      children: [
        if (!_isOffline) widget.child,
        if (_isOffline) _buildOfflineOverlay(),
        if (_showOnlineOverlay) _buildOnlineOverlay(),
      ],
    );
  }

  Widget _buildOfflineOverlay() {
    return Container(
      color: Colors.red.shade600,
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off, size: 64, color: Colors.white),
          const SizedBox(height: 12),
          const Text(
            "No Internet Connection",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _retryConnection,
            icon: const Icon(Icons.refresh),
            label: const Text("Retry"),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildOnlineOverlay() {
    return Container(
      color: Colors.green.shade600,
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi, size: 64, color: Colors.white),
          SizedBox(height: 12),
          Text(
            "Back Online",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
