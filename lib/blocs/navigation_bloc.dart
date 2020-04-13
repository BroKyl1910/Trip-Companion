import 'dart:async';

class NavigationBloc{
  StreamController<Navigation> _navigationStreamController = new StreamController();
  Stream<Navigation> get navigationStream => _navigationStreamController.stream;

  void navigate(Navigation screen){
    _navigationStreamController.sink.add(screen);
  }

  void dispose(){
    _navigationStreamController.close();
  }
}

enum Navigation{
  HOME,
  SETTINGS
}