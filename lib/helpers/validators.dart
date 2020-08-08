abstract class StringValidator {
  String errorMessage;
  bool isValid(String value);
}

// General validator to just make sure string isn't empty
class NonEmptyStringValidator implements StringValidator {
  @override
  String errorMessage = "Please complete all fields";

  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }

}

class EmailStringValidator implements StringValidator {
  @override
  String errorMessage = "Please enter a valid email";

  @override
  bool isValid(String value) {
    if (value.isEmpty) return false;
    RegExp regEx = new RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$");
    return regEx.hasMatch(value);
  }
}

class PasswordStringValidator implements StringValidator {
  @override
  String errorMessage = "Passwords need to be at least 6 characters";

  @override
  bool isValid(String value) {
    if (value.length < 6) return false;
    return true;
  }
}

class EmailAndPasswordValidators {
  final StringValidator emailValidator = EmailStringValidator();
  final StringValidator passwordValidator = PasswordStringValidator();
}

class RegistrationValidators{
  final StringValidator emailValidator = EmailStringValidator();
  final StringValidator nonEmptyStringValidator = NonEmptyStringValidator();
  final StringValidator passwordValidator = PasswordStringValidator();
}

class EventValidators{
  final StringValidator dateValidator = new NonEmptyStringValidator();
  final StringValidator timeValidator = new NonEmptyStringValidator();
  final StringValidator nameValidator = new NonEmptyStringValidator();
  final StringValidator descValidator = new NonEmptyStringValidator();
}
