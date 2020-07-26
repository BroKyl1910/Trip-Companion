import 'dart:async';

import 'package:rxdart/rxdart.dart';

class CreateEventBloc{
  StreamController<DateTime> _dateController = new BehaviorSubject<DateTime>();
  StreamController<DateTime> _timeController = new BehaviorSubject<DateTime>();
  Stream<DateTime> get dateStream => _dateController.stream;
  Stream<DateTime> get timeStream => _timeController.stream;

  void addDate(DateTime dateTime){
    _dateController.sink.add(dateTime);
  }

  void addTime(DateTime dateTime){
    _timeController.sink.add(dateTime);
  }

  void dispose(){
    _dateController.close();
    _timeController.close();
  }
}