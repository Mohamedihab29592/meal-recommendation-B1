class FormInputValidation {
  static String? phoneNumberValidation(String? value) {
    if (value?.isEmpty ?? true) {
      return "Required Field ";
    }
    if (value!.length != 11) {
      return "it must be 11 numbers";
    }
    if (value.substring(0, 3) == "010" ||
        value.substring(0, 3) == "011" ||
        value.substring(0, 3) == "012" ||
        value.substring(0, 3) == "015") {
      return null;
    } else {
      return "Your Number Must Begin With 010 / 011 / 012 / 015";
    }
  }

  static String? passwordValidation(String? value) {
    if (value?.isEmpty ?? true) {
      return "Required Field";
    } else {
      List<String> messages = [];
      if (value!.length < 8) {
        messages.add("Password must be at least 8 characters long.");
      }
      if (!RegExp(r'[A-Z]').hasMatch(value)) {
        messages.add("Password must contain at least one uppercase letter.");
      }
      if (!RegExp(r'[a-z]').hasMatch(value)) {
        messages.add("Password must contain at least one lowercase letter.");
      }
      if (!RegExp(r'[0-9]').hasMatch(value)) {
        messages.add("Password must contain at least one digit.");
      }
      if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
        messages.add(
            r"Password must contain at least one special character (!@#$&*~).");
      }

      if (messages.isNotEmpty) {
        return "Password validation failed:\n${messages.join("\n")}";
      } else {
        return null;
      }
    }
  }

  static String? emptyValueValidation(value) {
    if (value?.isEmpty ?? true) {
      return "Required Field ";
    }
    return null;
  }

  static String? emailValidation(String? value) {
    if (value?.isEmpty ?? true) {
      return "Required Field";
    } else {
      final bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(value!);
      if (!emailValid) {
        return "This Email is Invalid !! ";
      } else {
        return null;
      }
    }
  }
}
