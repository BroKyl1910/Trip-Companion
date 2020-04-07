import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tripcompanion/blocs/error_bloc.dart';
import 'package:tripcompanion/blocs/log_in_bloc.dart';
import 'package:tripcompanion/helpers/exceptions.dart';
import 'package:tripcompanion/helpers/validators.dart';
import 'package:tripcompanion/screens/register_screen.dart';
import 'package:tripcompanion/services/auth.dart';
import 'package:tripcompanion/widgets/custom_outlined_text_field.dart';
import 'package:tripcompanion/widgets/custom_raised_button.dart';
import 'package:tripcompanion/widgets/custom_raised_icon_button.dart';
import 'package:tripcompanion/widgets/error_dialog.dart';

class LoginScreen extends StatefulWidget with EmailAndPasswordValidators {
  static Widget create(BuildContext context) {
    return Provider<ErrorBloc>(
      create: (_) => ErrorBloc(),
      dispose: (context, bloc) => bloc.dispose(),
      child: Provider<LogInBloc>(
        create: (_) => LogInBloc(auth: Provider.of<AuthBase>(context, listen: false)),
        dispose: (context, bloc) => bloc.dispose(),
        child: LoginScreen(),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _errorAnimationController;

  @override
  void initState() {
    super.initState();
    _errorAnimationController = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: Duration(milliseconds: 200),
    );
  }

  Future<void> _signInWithGoogle() async {
    final bloc = Provider.of<LogInBloc>(context, listen: false);
    try {
      await bloc.signInWithGoogle();
//      Navigator.of(context).pop();
    } catch (e) {
      _showErrorDialog((e as AuthenticationException).message);
    }
  }

  //Submit email and password to Firebase
  void _onSubmit(BuildContext context) async {
    if (!widget.emailValidator.isValid(_emailController.text)) {
      _showErrorDialog(widget.emailValidator.errorMessage);
      return;
    }

    if (!widget.passwordValidator.isValid(_passwordController.text)) {
      _showErrorDialog(widget.passwordValidator.errorMessage);
      return;
    }

    String email = _emailController.text;
    String password = _passwordController.text;

    FocusScope.of(context).requestFocus(new FocusNode());

    final bloc = Provider.of<LogInBloc>(context, listen: false);
    try {
      await bloc
          .signInWithEmailAndPassword(email, password);
    } catch (e) {
      _showErrorDialog((e as AuthenticationException).message);
    }
  }

  void _openRegistrationScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterScreen.create(context)
      ),
    );
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  //Focus shifting
  void _emailEditingComplete(BuildContext context) {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  void _passwordEditingComplete(BuildContext context) {
    FocusScope.of(context).unfocus();
    _onSubmit(context);
  }

  void _updateState() {
    setState(() {});
  }

  void _showErrorDialog(String errorMessage) {
      _errorAnimationController.forward();

      final errorBloc = Provider.of<ErrorBloc>(context, listen: false);
      errorBloc.setHasError(true);
      errorBloc.errorMessage = errorMessage;

  }

  void _hideErrorDialog() {
    final errorBloc = Provider.of<ErrorBloc>(context, listen: false);
    errorBloc.setHasError(false);
  }

  Widget _buildErrorDialog(bool hasError, String errorMessage) {
    if (hasError == true) {
      return Positioned(
        width: MediaQuery
            .of(context)
            .size
            .width,
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

  Widget _buildHeader(bool isLoading) {
    if (isLoading) {
      return Container(
        height: 100,
        width: 100,
        child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white70)
        ),
      );
    }

    return Image(
      image: AssetImage('assets/images/logo.png'),
      height: 100,
      width: 100,
    );
  }

  Widget _buildBody(BuildContext context, bool isLoading, bool hasError, String errorMessage) {
    bool loginEnabled = !isLoading;

    return Stack(
      children: <Widget>[
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 80,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _buildHeader(isLoading),
                          SizedBox(
                            height: 50,
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                CustomOutlinedTextField(
                                  hintText: 'Email',
                                  keyboardType: TextInputType.emailAddress,
                                  obscured: false,
                                  textEditingController: _emailController,
                                  action: TextInputAction.next,
                                  focusNode: _emailFocusNode,
                                  onEditingComplete: () {
                                    _emailEditingComplete(context);
                                  },
                                  onChanged: (text) => _updateState(),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                CustomOutlinedTextField(
                                  hintText: 'Password',
                                  keyboardType: TextInputType.text,
                                  obscured: true,
                                  textEditingController: _passwordController,
                                  action: TextInputAction.done,
                                  focusNode: _passwordFocusNode,
                                  onEditingComplete: () {
                                    _passwordEditingComplete(context);
                                  },
                                  onChanged: (text) => _updateState(),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                CustomRaisedButton(
                                  color: Colors.blue[400],
                                  textColor: Colors.white,
                                  text: 'Login',
                                  onTap: loginEnabled
                                      ? () {
                                    _onSubmit(context);
                                  }
                                      : null,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                          child:
                                          Divider(color: Colors.white)),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        "OR",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                CustomRaisedIconButton(
                                  color: Colors.red[400],
                                  textColor: Colors.white,
                                  text: 'Login with Google',
                                  onTap: loginEnabled
                                      ? () {
                                    _signInWithGoogle();
                                  }
                                      : null,
                                  iconData: FontAwesomeIcons.google,
                                  iconColor: Colors.white70,
                                ),
                              ],
                            ),
                          ),
                        ]),
                    Container(
                      child: GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'Not a member yet? Sign up',
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                        onTap: () {
                          _openRegistrationScreen(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        _buildErrorDialog(hasError, errorMessage),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final loginBloc = Provider.of<LogInBloc>(context);
    final errorBloc = Provider.of<ErrorBloc>(context);

    return Scaffold(
      body: StreamBuilder<bool>(
        stream: errorBloc.hasErrorStream,
        initialData: false,
        builder: (context, errorSnapshot){
          return StreamBuilder<bool>(
            stream: loginBloc.isLoadingStream,
            initialData: false,
            builder: (context, loadingSnapshot) {
              // Body now needs to know if loading, if there's an error, and what the error is
              return _buildBody(context, loadingSnapshot.data, errorSnapshot.data, errorBloc.errorMessage);
            },
          );
        },
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  @override
  void dispose() {
    _errorAnimationController.dispose();
    super.dispose();
  }
}
