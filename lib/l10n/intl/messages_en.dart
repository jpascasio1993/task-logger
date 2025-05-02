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

  static String m0(cmplt) => "${Intl.select(cmplt, {
            'true': 'Completed',
            'false': 'Not yet completed',
            'other': 'Not yet completed'
          })}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "appName": MessageLookupByLibrary.simpleMessage("Task Logger"),
        "completed": MessageLookupByLibrary.simpleMessage("Completed"),
        "createNewTask":
            MessageLookupByLibrary.simpleMessage("Create new task"),
        "createTask": MessageLookupByLibrary.simpleMessage("Create task"),
        "creatingTask":
            MessageLookupByLibrary.simpleMessage("Creating task..."),
        "deletingTask":
            MessageLookupByLibrary.simpleMessage("Deleting task..."),
        "description": MessageLookupByLibrary.simpleMessage("Description"),
        "errorOccurred":
            MessageLookupByLibrary.simpleMessage("An error occurred"),
        "isCompleted": m0,
        "noInternetConnection": MessageLookupByLibrary.simpleMessage(
          "No internet connection",
        ),
        "nothingToShow":
            MessageLookupByLibrary.simpleMessage("Nothing to Show"),
        "retry": MessageLookupByLibrary.simpleMessage("Retry"),
        "title": MessageLookupByLibrary.simpleMessage("Title"),
        "updateTask": MessageLookupByLibrary.simpleMessage("Update task"),
      };
}
