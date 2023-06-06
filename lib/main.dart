import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MaterialApp(
      home: HomeComponent(
    key: Key("1"),
  )));
}

class HomeComponent extends StatefulWidget {
  const HomeComponent({super.key});

  @override
  State<HomeComponent> createState() => _HomeComponentState();
}

// ignore: constant_identifier_names
const double INIT_TIME = 301;

class _HomeComponentState extends State<HomeComponent> {
  Timer? _timer;

  int _lastActive = 0;

  bool _isTimerActive1 = false;
  bool _isTimerActive2 = false;

  int _tenthFraction1 = 0;
  int _tenthFraction2 = 0;

  double _timerSeconds1 = INIT_TIME;
  double _timerSeconds2 = INIT_TIME;

  void _startTimer() {
    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        if (!_isTimerActive1 && !_isTimerActive2) {
          if (_lastActive == 2) {
            _isTimerActive2 = true;
          } else {
            _isTimerActive1 = true;
          }
        }
        if (_isTimerActive1) {
          if (_tenthFraction1 < 10) {
            _tenthFraction1++;
          } else {
            _tenthFraction1 = 0;
          }
          _timerSeconds1 -= 0.1;
          if (_timerSeconds1 < 0) {
            _timerSeconds1 = 0;
            _timer?.cancel();
          }
        } else if (_isTimerActive2) {
          if (_tenthFraction2 < 10) {
            _tenthFraction2++;
          } else {
            _tenthFraction2 = 0;
          }
          _timerSeconds2 -= 0.1;
          if (_timerSeconds2 < 0) {
            _timerSeconds2 = 0;
            _timer?.cancel();
          }
        }
      });
    });
  }

  void _reset() {
    setState(() {
      _timerSeconds1 = INIT_TIME;
      _timerSeconds2 = INIT_TIME;
    });
  }

  String _formatSecondsToMinutes(double seconds) {
    int minutes = seconds ~/ 60; // Integer division
    double remainingSeconds = seconds % 60;

    String remainingSecondsFromated = double.parse(remainingSeconds.toString())
        .toStringAsFixed(0)
        .padLeft(2, "0");

    if (minutes > 0) {
      return '$minutes:${remainingSecondsFromated == '60' ? '59' : remainingSecondsFromated}';
    } else {
      return _formatTime(remainingSeconds);
    }
  }

  String _formatTime(double seconds) {
    if (seconds < 10) {
      return double.parse(seconds.toString()).toStringAsFixed(1);
    } else {
      return double.parse(seconds.toString()).toStringAsFixed(0);
    }
  }

  void _pauseTimer() {
    final timer = _timer;
    if (timer != null) {
      timer.cancel();
    }
    setState(() {
      _isTimerActive1 = false;
      _isTimerActive2 = false;
    });
  }

  void _toggleActive(int timer) {
    if (timer == 1 && !_isTimerActive1) {
      return;
    } else if (timer == 2 && !_isTimerActive2) {
      return;
    }
    setState(() {
      if ((_isTimerActive1 == false) && _isTimerActive2 == false) {
        _isTimerActive1 = !_isTimerActive1;
        _lastActive = 1;
        _startTimer();
      } else {
        _isTimerActive1 = !_isTimerActive1;
        _isTimerActive2 = !_isTimerActive2;

        if (_isTimerActive1) {
          _lastActive = 1;
        } else {
          _lastActive = 2;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Expanded(
            flex: 4,
            child: Material(
                color: !_isTimerActive1
                    ? Colors.grey.shade200
                    : (_timerSeconds1 < 10
                        ? _timerSeconds1 == 0 || _timerSeconds1 < 0
                            ? Colors.red.shade700
                            : Colors.red.shade300
                        : Colors.amber),
                shadowColor: Colors.black,
                child: InkWell(
                    overlayColor: MaterialStateProperty.resolveWith(
                        (states) => Colors.white60),
                    onTap: () => {_toggleActive(1)},
                    child: Center(
                        child: Text(
                      _formatSecondsToMinutes(_timerSeconds1),
                      style: const TextStyle(fontSize: 32),
                    )))),
          ),
          Expanded(
            flex: 1,
            child: Container(
                color: Colors.grey,
                child: Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                      Expanded(
                          flex: 1,
                          child: Material(
                            color: Colors.grey,
                            child: InkWell(
                                onTap: _isTimerActive1 || _isTimerActive2
                                    ? _pauseTimer
                                    : _startTimer,
                                child: Center(
                                    child: Icon(
                                        _isTimerActive1 || _isTimerActive2
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.white))),
                          )),
                      Expanded(
                          flex: 1,
                          child: Material(
                            color: Colors.grey,
                            child: InkWell(
                                onTap: () {},
                                child: const Center(
                                    child:
                                        Icon(Icons.edit, color: Colors.white))),
                          )),
                      Expanded(
                          flex: 1,
                          child: Material(
                            color: Colors.grey,
                            child: InkWell(
                                onTap: _reset,
                                child: const Center(
                                    child: Icon(Icons.restore,
                                        color: Colors.white))),
                          )),
                    ]))),
          ),
          Expanded(
            flex: 4,
            child: Container(
                color: Colors.grey.shade100,
                child: Material(
                    color: !_isTimerActive2
                        ? Colors.grey.shade200
                        : (_timerSeconds2 < 10
                            ? _timerSeconds2 == 0 || _timerSeconds2 < 0
                                ? Colors.red.shade700
                                : Colors.red.shade300
                            : Colors.amber),
                    child: InkWell(
                        overlayColor: MaterialStateProperty.resolveWith(
                            (states) => Colors.white60),
                        onTap: () => {_toggleActive(2)},
                        child: Center(
                            child: Text(
                          _formatSecondsToMinutes(_timerSeconds2),
                          style: const TextStyle(fontSize: 32),
                        ))))),
          ),
        ]),
      ),
    );
  }
}
