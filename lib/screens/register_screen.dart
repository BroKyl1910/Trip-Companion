import 'package:flutter/material.dart';
import 'package:tripcompanion/services/auth.dart';
import 'package:tripcompanion/widgets/custom_flat_text_field.dart';
import 'package:tripcompanion/widgets/custom_outlined_text_field.dart';
import 'package:tripcompanion/widgets/custom_raised_button.dart';

class RegisterScreen extends StatefulWidget {
  final AuthBase auth;

  RegisterScreen({@required this.auth});

  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _firstNameTextController =
      TextEditingController();
  final TextEditingController _surnameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _confirmPasswordTextController =
      TextEditingController();

  void _submit(BuildContext context) async {
    String email = _emailTextController.text;
    String password = _passwordTextController.text;
    try {
      await widget.auth.registerWithEmailAndPassword(email, password);
      Navigator.of(context).pop();
    }catch(e){
      print(e);
    }
//    print(_firstNameTextController.text);
//    print(_surnameTextController.text);
//    print();
//    print();
//    print(_confirmPasswordTextController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          //Background image and overlay
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            left: 0,
            child: Image(
              image: AssetImage('assets/images/map_backgrounds/map_1.PNG'),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(120, 0, 0, 0),
            ),
            constraints: BoxConstraints.expand(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 40.0,
                  ),
                  //Top bar
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromARGB(120, 0, 0, 0),
                            offset: Offset(0.0, 2.0),
                            blurRadius: 6.0)
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Material(
                              type: MaterialType.transparency,
                              child: IconButton(
                                icon: Icon(Icons.arrow_back),
                                iconSize: 20.0,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                splashColor: Color.fromARGB(130, 0, 0, 0),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          Text(
                            'Register',
                            style: Theme.of(context).textTheme.title,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Column(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(120, 0, 0, 0),
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 6.0,
                                  )
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    CustomFlatTextField(
                                      hintText: 'First Name',
                                      textEditingController:
                                          _firstNameTextController,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    CustomFlatTextField(
                                      hintText: 'Surname',
                                      textEditingController:
                                          _surnameTextController,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    CustomFlatTextField(
                                      hintText: 'Email',
                                      keyboardType: TextInputType.emailAddress,
                                      textEditingController:
                                          _emailTextController,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    CustomFlatTextField(
                                      hintText: 'Password',
                                      obscured: true,
                                      textEditingController:
                                          _passwordTextController,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    CustomFlatTextField(
                                      hintText: 'Confirm Password',
                                      obscured: true,
                                      textEditingController:
                                          _confirmPasswordTextController,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                CustomRaisedButton(
                                  color: Colors.blue[400],
                                  textColor: Colors.white,
                                  text: 'Register',
                                  onTap: (){_submit(context);},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
