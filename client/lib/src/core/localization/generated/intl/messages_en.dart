// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(value) => "Exception occured: ${value}";

  static String m1(value) => "Unknown error: \$${value}";

  static String m2(value) => "Welcome, ${value}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "app_title": MessageLookupByLibrary.simpleMessage("Auther"),
        "dont_have_account":
            MessageLookupByLibrary.simpleMessage("Don\'t have an account?"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "exception_occured": m0,
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "sign_in": MessageLookupByLibrary.simpleMessage("Sign in"),
        "sign_in_to_auther":
            MessageLookupByLibrary.simpleMessage("Sign in to Auther"),
        "sign_out": MessageLookupByLibrary.simpleMessage("Sign out"),
        "sign_up": MessageLookupByLibrary.simpleMessage("Sign up"),
        "sign_up_to_auther":
            MessageLookupByLibrary.simpleMessage("Sign up to Auther"),
        "unknown_error": m1,
        "user_exists": MessageLookupByLibrary.simpleMessage(
            "User with this email already exists"),
        "user_not_found": MessageLookupByLibrary.simpleMessage(
            "Email or password is incorrect"),
        "username": MessageLookupByLibrary.simpleMessage("Username"),
        "welcome_back": MessageLookupByLibrary.simpleMessage("Welcome back"),
        "welcome_user": m2
      };
}
