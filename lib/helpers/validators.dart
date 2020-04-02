abstract class StringValidator {
  bool isValid(String value);
}

// General validator to just make sure string isn't empty
class NonEmptyStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

class EmailStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    if (value.isEmpty) return false;
    RegExp regEx = new RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$");
    return regEx.hasMatch(value);
  }
}

class PasswordStringValidator implements StringValidator {
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
