class User {
  String uid;
  String displayName;
  String email;
  String imageUrl;
  List<String> friends;
  List<String> outgoingFriendRequests;
  List<String> incomingFriendRequests;

  AuthenticationMethod authenticationMethod;

  User({this.uid, this.displayName, this.email, this.imageUrl,
      this.authenticationMethod, this.friends, this.incomingFriendRequests, this.outgoingFriendRequests});

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'displayName': this.displayName,
      'email': this.email,
      'imageUrl': this.imageUrl,
      'authenticationMethod': (this.authenticationMethod??AuthenticationMethod.GOOGLE).toString(),
      'friends': this.friends??new List<String>(),
      'outgoingFriendRequests': this.outgoingFriendRequests??new List<String>(),
      'incomingFriendRequests': this.incomingFriendRequests??new List<String>()
    };
  }

  User fromMap(Map<String, dynamic> data){
    return User(
      uid: data["uid"],
      displayName: data["displayName"],
      email: data["email"],
      imageUrl: data["imageUrl"],
      authenticationMethod: (data["authenticationMethod"]).toString().split('.')[1] == "GOOGLE" ? AuthenticationMethod.GOOGLE : AuthenticationMethod.EMAIL_AND_PASSWORD,
      friends: getListOfStrings(data["friends"]),
      outgoingFriendRequests: getListOfStrings(data["outgoingFriendRequests"]),
      incomingFriendRequests: getListOfStrings(data["incomingFriendRequests"]),
    );
  }

  @override
  bool operator ==(other) {
    return this.uid == other.uid;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;

  List<String> getListOfStrings(List<dynamic> data) {
    List<String> returnStrings = new List<String>();
    if(data == null) return returnStrings;
    for(int i = 0; i < data.length; i++){
      returnStrings.add(data[i].toString());
    }

    return returnStrings;
  }

}

enum AuthenticationMethod{
  GOOGLE,
  EMAIL_AND_PASSWORD
}

