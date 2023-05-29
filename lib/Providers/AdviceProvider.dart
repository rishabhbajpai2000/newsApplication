import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class ThoughtProvider with ChangeNotifier {
  // variable declaration
  List<String> _adviceList = [];
  List<String> get adviceList => _adviceList;
  String _toDisplay = "";
  String get thought => _toDisplay;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> refreshData() async {
    if (await _checkConnectivity()) {
      // Perform the data refresh here
      getNewAdvice();
    }
  }

  Future<bool> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

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
      if (kDebugMode) {
        print('Error reading advices: $e');
      }
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
      await writeAdvice(_toDisplay);
    }
    setLoading(false);
    notifyListeners();
  }

  void setLoading(bool bool) {
    _isLoading = bool;
    notifyListeners();
  }

  Future<void> getLastOfflineAdvice() async {
    try {
      final file = await _localFile;

      if (await file.exists()) {
        final contents = await file.readAsString();
        _toDisplay = contents.split("\n")[0];
      } else {
        // File doesn't exist yet, handle this case accordingly

        _toDisplay = "Do something selfless";
      }
      notifyListeners();
    } catch (e) {
      // Handle the error appropriately
      if (kDebugMode) {
        print('Error reading advices: $e');
      }
    }
  }
}
