import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../model/NewsArt.dart';
import '../model/contants.dart';

class ThoughtProvider with ChangeNotifier {
  // variable declaration
  List<String> _adviceList = [];
  List<String> get adviceList => _adviceList;
  String _toDisplay = "";
  String get thought => _toDisplay;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<NewsArticle> news = [];
  String category  = 'general';
  List<NewsArticle> bookmarkedNews = [];

  Future<void> refreshData() async {
    if (await _checkConnectivity()) {
      // Perform the data refresh here
      news.clear();
      getNewNews();
      getNewNews();
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
    return File('$path/Bookmarks.json');
  }


  Future<void> readNews() async {
    try {
      final file = await _localFile;

      if (await file.exists()) {
        final String contents = await file.readAsString();
        final List<String> lines = contents.split("this will be end statement ");
        // print(lines);
        bookmarkedNews.clear();

        bookmarkedNews = lines
            .where((line) => line.isNotEmpty)
            .map((line) {
          final newsArticleJson = jsonDecode(line);
          // print("this is the news article json");
          // print(newsArticleJson);
          return NewsArticle.fromJSON(newsArticleJson);
        }).toList();

        for (var newsArticle in bookmarkedNews) {
            debugPrint(newsArticle.url);
            debugPrint(newsArticle.title);
            debugPrint(newsArticle.author);
            debugPrint(newsArticle.urlToImage);
            debugPrint(newsArticle.description);
        }
      } else {
        bookmarkedNews = []; // No bookmarks in the file
      }
      notifyListeners();
    } catch (e) {
      // Handle the error appropriately
      if (kDebugMode) {
        print('Error reading news: $e');
      }
    }
  }


  Future<File> writeNews(NewsArticle newsArticle) async {

    final file = await _localFile;
    // Write the file
    final newsArticleJson = newsArticle.toJson();

    // Convert the JSON to a string
    final newsArticleJsonString = jsonEncode(newsArticleJson);

    // Write the JSON data to the file
    return file.writeAsString("$newsArticleJsonString this will be end statement ", mode: FileMode.append);

  }


  void getNewNews() async {
    setLoading(true);
    notifyListeners();
    final _random = new Random();

    Response response = await get(Uri.parse("https://newsapi.org/v2/top-headlines?country=in&category=$category&apiKey=$aPIKeyPriyanka"));

    if (response.statusCode == 200) {
      Map bodyData = jsonDecode(response.body);
      List articles = bodyData["articles"];
      var myArticle = articles[_random.nextInt(articles.length)];
      // print(myArticle);
      news.add(NewsArticle.fromJSON(myArticle));
      // print("new advice was loaded in ");
    }
    else{
      print(response.statusCode);
    }
    setLoading(false);
    notifyListeners();
  }

  void setLoading(bool bool) {
    _isLoading = bool;
    notifyListeners();
  }

  Future<File> deleteAllAdvices() async {
    final file = await _localFile;
    // Write the file
    _toDisplay = "";
    return file.writeAsString("");
  }


  Future<void> getLastOfflineNews() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        var advices = contents.split("\n");
        _toDisplay = advices[0];
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
