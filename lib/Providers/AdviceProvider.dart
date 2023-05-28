import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ThoughtProvider with ChangeNotifier {
  // variable declaration
  List<String> _adviceList = [];
  List<String> get adviceList => _adviceList;
  String _toDisplay =
      ""; // we need to have it equal to previous searched thought
  String get thought => _toDisplay;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // for accessing the local data file to write in it.
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/previousThoughts.txt');
  }

  Future<void> readAdvices() async {
    // setLoading(true);
    try {
      final file = await _localFile;

      if (await file.exists()) {
        final contents = await file.readAsString();
        _adviceList = contents.split("\n");
      } else {
        // File doesn't exist yet, handle this case accordingly
        // For example, you can set _adviceList to an empty list
        _adviceList = [];
      }

      notifyListeners();
    } catch (e) {
      // Handle the error appropriately
      print('Error reading advices: $e');
    }
  }

  Future<File> writeAdvice(String advice) async {
    final file = await _localFile;
    // Write the file
    return file.writeAsString("$advice\n", mode: FileMode.append);
  }

  Future<File> deleteAllAdvices() async {
    final file = await _localFile;
    // Write the file
    _toDisplay = "";
    return file.writeAsString("");
  }

  void getNewAdvice() async {
    setLoading(true);
    notifyListeners();
    final response =
        await http.get(Uri.parse("https://api.adviceslip.com/advice"));
    if (response.statusCode == 200) {
      _toDisplay = jsonDecode(response.body)["slip"]["advice"].toString();
      // _adviceList.add(_toDisplay);
      await writeAdvice(_toDisplay);
    }
    setLoading(false);
    notifyListeners();
  }

  void setLoading(bool bool) {
    _isLoading = bool;
    notifyListeners();
  }
}
