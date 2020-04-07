import 'dart:async';

class LoadingBloc{
  final StreamController<bool> _isLoadingController = StreamController<bool>();
  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void dispose(){
    _isLoadingController.close();
  }

  void setIsLoading(bool val) => _isLoadingController.add(val);
}