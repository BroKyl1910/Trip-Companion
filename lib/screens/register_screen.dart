import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripcompanion/blocs/error_bloc.dart';
import 'package:tripcompanion/blocs/register_bloc.dart';
import 'package:tripcompanion/helpers/exceptions.dart';
import 'package:tripcompanion/helpers/validators.dart';
import 'package:tripcompanion/services/auth.dart';
import 'package:tripcompanion/services/db.dart';
import 'package:tripcompanion/widgets/custom_flat_text_field.dart';
import 'package:tripcompanion/widgets/custom_raised_button.dart';
import 'package:tripcompanion/widgets/error_dialog.dart';

class RegisterScreen extends StatefulWidget {

  static Widget create(BuildContext context){
    return Provider<ErrorBloc>(
      create: (_) => ErrorBloc(),
      dispose: (context, bloc) => bloc.dispose(),
      child: Provider<RegisterBloc>(
        create: (_) => RegisterBloc(auth: Provider.of<AuthBase>(context, listen: false), db: Provider.of<DatabaseBase>(context, listen: false)),
        dispose: (context, bloc) => bloc.dispose(),
        child: RegisterScreen(),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with RegistrationValidators, SingleTickerProviderStateMixin {
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

    String firstName = _firstNameTextController.text.trim();
    String surname = _surnameTextController.text.trim();
    String email = _emailTextController.text.trim();
    String password = _passwordTextController.text.trim();
    String confirmPassword = _confirmPasswordTextController.text.trim();

    bool _validFirstName = nonEmptyStringValidator.isValid(firstName);
    bool _validSurname = nonEmptyStringValidator.isValid(surname);
    bool _validEmail = emailValidator.isValid(email);
    bool _validPassword = passwordValidator.isValid(password);
    bool _validConfirmPassword = password == confirmPassword;

    if (!_validFirstName) {
      _showErrorDialog(nonEmptyStringValidator.errorMessage);
      return;
    } else if (!_validSurname) {
      _showErrorDialog(nonEmptyStringValidator.errorMessage);
      return;
    } else if (!_validEmail) {
      _showErrorDialog(emailValidator.errorMessage);
      return;
    } else if (!_validPassword) {
      _showErrorDialog(passwordValidator.errorMessage);
      return;
    } else if (!_validConfirmPassword) {
      _showErrorDialog("Passwords don't match");
      return;
    }

    final RegisterBloc registerBloc = Provider.of<RegisterBloc>(context, listen: false);
    try {
      await registerBloc.registerWithEmailAndPassword(firstName, surname, email, password);
      Navigator.of(context).pop();
    } catch (e) {
      _showErrorDialog((e as AuthenticationException).message);
    }
  }

  void _showErrorDialog(String errorMessage) {
      _errorAnimationController.forward();

      final ErrorBloc bloc = Provider.of<ErrorBloc>(context, listen: false);
      bloc.setHasError(true);
      bloc.errorMessage = errorMessage;
  }

  void _hideErrorDialog() {
    final ErrorBloc bloc = Provider.of<ErrorBloc>(context, listen: false);
    bloc.setHasError(false);
  }

  Widget _buildErrorDialog(bool hasError, String errorMessage) {
    if (hasError == true) {
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
                  errorMessage: errorMessage,
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

  Widget _buildLoadingIndicator(bool isLoading){
    if(!isLoading) return Container();

    return Container(
      width: 10,
      height: 10,
      child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.black12)
      ),
    );
  }

  Widget _buildBody(BuildContext context, bool isLoading, bool hasError, String errorMessage){
    return Stack(
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
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        _buildLoadingIndicator(isLoading),
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
                                onTap: !isLoading
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
        _buildErrorDialog(hasError, errorMessage),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final registerBloc = Provider.of<RegisterBloc>(context);
    final errorBloc = Provider.of<ErrorBloc>(context);//, listen: false

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        body: StreamBuilder(
          stream: errorBloc.hasErrorStream,
          initialData: false,
          builder: (context, errorSnapshot){
            return StreamBuilder<bool>(
              stream: registerBloc.isLoadingStream,
              initialData: false,
              builder: (context, loadingSnapshot) {
                // Body now needs to know if loading, if there's an error, and what the error is
                return _buildBody(context, loadingSnapshot.data, errorSnapshot.data, errorBloc.errorMessage);
              },
            );
          },
        )
    );

  }
}
