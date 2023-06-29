import 'package:form_validator/form_validator.dart';

extension CustomValidationBuilder on ValidationBuilder {
  password(password) => add((value) {
        if (value != password) {
          return 'Passwords do not match';
        }
        return null;
      });
}
