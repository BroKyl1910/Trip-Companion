import 'package:flutter/material.dart';
import 'package:tripcompanion/helpers/exceptions.dart';
import 'package:tripcompanion/helpers/validators.dart';
import 'package:tripcompanion/services/auth.dart';
import 'package:tripcompanion/services/auth_provider.dart';
import 'package:tripcompanion/widgets/custom_flat_text_field.dart';
import 'package:tripcompanion/widgets/custom_outlined_text_field.dart';
import 'package:tripcompanion/widgets/custom_raised_button.dart';
import 'package:tripcompanion/widgets/error_dialog.dart';

class RegisterScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with RegistrationValidators, SingleTickerProviderStateMixin {
  bool showErrorDialog = false;
  String _errorMessage = "";
  AnimationController _errorAnimationController;

  @override
  void initState() {
    super.initState();
    _errorAnimationController = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: Duration(milliseconds: 200),
    );
  }

  //Text controllers
  final TextEditingController _firstNameTextController =
      TextEditingController();
  final TextEditingController _surnameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _confirmPasswordTextController =
      TextEditingController();

  //Focus Nodes
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _surnameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  //Focus Shifting
  void _shiftFocus(BuildContext context, FocusNode nextNode) {
    FocusScope.of(context).requestFocus(nextNode);
  }

  void _submit(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());

    String firstName = _firstNameTextController.text;
    String surname = _surnameTextController.text;
    String email = _emailTextController.text;
    String password = _passwordTextController.text;
    String confirmPassword = _confirmPasswordTextController.text;

    bool _validFirstName = nonEmptyStringValidator.isValid(firstName);
    bool _validSurname = nonEmptyStringValidator.isValid(surname);
    bool _validEmail = emailValidator.isValid(email);
    bool _validPassword = passwordValidator.isValid(password);
    bool _validConfirmPassword = password == confirmPassword;

    if (!_validFirstName) {
      _showErrorDialog(nonEmptyStringValidator.errorMessage);
//      _shiftFocus(context, _firstNameFocusNode);
      return;
    } else if (!_validSurname) {
      _showErrorDialog(nonEmptyStringValidator.errorMessage);
//      _shiftFocus(context, _surnameFocusNode);
      return;
    } else if (!_validEmail) {
      _showErrorDialog(emailValidator.errorMessage);
//      _shiftFocus(context, _emailFocusNode);
      return;
    } else if (!_validPassword) {
      _showErrorDialog(passwordValidator.errorMessage);
//      _shiftFocus(context, _passwordFocusNode);
      return;
    } else if (!_validConfirmPassword) {
      _showErrorDialog("Passwords don't match");
//      _shiftFocus(context, _confirmPasswordFocusNode);
      return;
    }

    try {
      await AuthProvider.of(context).registerWithEmailAndPassword(email, password);
      Navigator.of(context).pop();
    } catch (e) {
      _showErrorDialog((e as AuthenticationException).message);
    }
  }

  void _showErrorDialog(String errorMessage) {
    print('Error $_errorMessage');
    setState(() {
      _errorAnimationController.forward();
      showErrorDialog = true;
      _errorMessage = errorMessage;
    });
  }

  void _hideErrorDialog() {
    setState(() {
      showErrorDialog = false;
    });
  }

  Widget _buildErrorDialog() {
    print("Show error dialog: $showErrorDialog");
    if (showErrorDialog == true) {
      return Positioned(
        width: MediaQuery.of(context).size.width,
        bottom: 10,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                ErrorDialog(
                  errorMessage: _errorMessage,
                  onClosed: _hideErrorDialog,
                  animationController: _errorAnimationController,
                ),
              ],
            ),
          ],
        ),
      );
    }
    return Container();
  }

  void _updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
//    bool registerButtonEnabled = _firstNameTextController.text.isNotEmpty &&
//        _surnameTextController.text.isNotEmpty &&
//        _emailTextController.text.isNotEmpty &&
//        _passwordTextController.text.isNotEmpty &&
//        _confirmPasswordTextController.text.isNotEmpty;

    bool registerButtonEnabled = true;

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
                                      action: TextInputAction.next,
                                      focusNode: _firstNameFocusNode,
                                      onEditingComplete: () {
                                        _shiftFocus(context, _surnameFocusNode);
                                      },
                                      onChanged: (text) => _updateState(),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    CustomFlatTextField(
                                      hintText: 'Surname',
                                      textEditingController:
                                          _surnameTextController,
                                      action: TextInputAction.next,
                                      focusNode: _surnameFocusNode,
                                      onEditingComplete: () {
                                        _shiftFocus(context, _emailFocusNode);
                                      },
                                      onChanged: (text) => _updateState(),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    CustomFlatTextField(
                                      hintText: 'Email',
                                      keyboardType: TextInputType.emailAddress,
                                      textEditingController:
                                          _emailTextController,
                                      action: TextInputAction.next,
                                      focusNode: _emailFocusNode,
                                      onEditingComplete: () {
                                        _shiftFocus(
                                            context, _passwordFocusNode);
                                      },
                                      onChanged: (text) => _updateState(),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    CustomFlatTextField(
                                      hintText: 'Password',
                                      obscured: true,
                                      textEditingController:
                                          _passwordTextController,
                                      action: TextInputAction.next,
                                      focusNode: _passwordFocusNode,
                                      onEditingComplete: () {
                                        _shiftFocus(
                                            context, _confirmPasswordFocusNode);
                                      },
                                      onChanged: (text) => _updateState(),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    CustomFlatTextField(
                                      hintText: 'Confirm Password',
                                      obscured: true,
                                      textEditingController:
                                          _confirmPasswordTextController,
                                      action: TextInputAction.done,
                                      focusNode: _confirmPasswordFocusNode,
                                      onEditingComplete: () {
                                        _submit(context);
                                      },
                                      onChanged: (text) => _updateState(),
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
                                  onTap: registerButtonEnabled
                                      ? () {
                                          _submit(context);
                                        }
                                      : null,
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
          ),
          _buildErrorDialog(),
        ],
      ),
    );
  }
}
