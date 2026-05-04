import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:girigoflutter/cubit/recording_state.dart';

class CounterCubit extends Cubit<RecordingState> {
  CounterCubit() : super(RecordingState(isRecording: false, timeRemaining: null));

  final Duration _timerDuration = Duration(seconds: 60);
  late final Timer _timer;

  void startTimer(){
    // inicia um timer
    _timer = Timer.periodic(_timerDuration, (timer){
      emit(RecordingState(isRecording: true, timeRemaining: timer.tick));
    });
  }

  void stopTimer(){
    _timer.cancel();
    emit(RecordingState(isRecording: false, timeRemaining: null));
  }

  void increment() => emit(state);
}