import 'dart:async';

class ErrorBloc{
  StreamController<bool> _hasErrorController = new StreamController<bool>();
  Stream<bool> get hasErrorStream => _hasErrorController.stream;

  String errorMessage;

  void setHasError(bool hasError) => _hasErrorController.sink.add(hasError);

  void dispose(){
    _hasErrorController.close();
  }
}