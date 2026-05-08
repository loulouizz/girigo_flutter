import 'dart:async';

import 'package:flutter/cupertino.dart';

class RecordingController extends ChangeNotifier{
  bool _isRecording = false;
  double _lastValue = 0;
  double _currentValue = 0;

  bool get isRecording => _isRecording;
  double get lastValue => _lastValue;
  double get currentValue => _currentValue;

  late Timer _timer;
  static const int _recordingTimeLimit = 60;


  void startRecording(){
    _isRecording = true;

    // this line is needed or the timer only starts counting 1s later
    _currentValue = 1/_recordingTimeLimit;
    notifyListeners();

    _timer = Timer.periodic(Duration(seconds: 1), (timer){
      if(timer.tick <= _recordingTimeLimit){
        _lastValue = _currentValue;
        _currentValue = (timer.tick + 1)/ _recordingTimeLimit;
        notifyListeners();
      } else {
        stopRecording();
      }
    });

  }

  void stopRecording(){
    _timer.cancel();
    _isRecording = false;
    _lastValue = 0;
    _currentValue = 0;
    notifyListeners();
  }
}