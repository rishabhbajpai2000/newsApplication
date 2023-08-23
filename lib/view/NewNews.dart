import 'dart:async';

import 'package:advisor/model/contants.dart';
import 'package:advisor/view/FullPageNews.dart';
import 'package:advisor/view/BookMarkedNews.dart';
import 'package:advisor/Providers/NewsProvider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Utils/utils.dart';

class NewAdvicePage extends StatefulWidget {

  bool offlineMode; // this variable will be used to check if the app is in offline mode or not.
  NewAdvicePage({super.key, required this.offlineMode});

  @override
  State<NewAdvicePage> createState() => _NewAdvicePageState();
}

class _NewAdvicePageState extends State<NewAdvicePage> {

  final Connectivity _connectivity = Connectivity(); // this will be used to check the network connectivity.
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  PageController _pageController = PageController(); // when the user swipes right, this controller will insure to load a new advice

  @override
  void initState() {
    super.initState();
    var offlineMode = widget.offlineMode;
    // making a provider.
    final newThoughtProvider =
        Provider.of<ThoughtProvider>(context, listen: false);
    // this will listen when the user swipes right, a new advice will be loaded into the app.
    _pageController.addListener(() {
      if (_pageController.page == _pageController.page!.roundToDouble()) {
        // print("the user swiped right! ");
        newThoughtProvider.getNewNews();
      }
    });

    // Listen for network connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) {
        if (result != ConnectivityResult.none) {
          Utils().toastMessage("Found the internet, new news coming soon!");
          newThoughtProvider.refreshData();
          newThoughtProvider.getNewNews();
          setState(() {
            widget.offlineMode = false;
          });
        } else if (result == ConnectivityResult.none) {
          setState(() {
            widget.offlineMode = true;
          });
        }
      },
    );

    // getting the new advice loaded up before firing the widget.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (offlineMode == true) {
        newThoughtProvider.getLastOfflineNews();
      } else {
        newThoughtProvider.getNewNews();
      }
    });
  }

  @override
  void dispose() {
    // Cancel the connectivity subscription when the widget is disposed
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offlineMode = widget.offlineMode;
    final newThoughtProvider =
        Provider.of<ThoughtProvider>(context, listen: false);

    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade300,
          body: GestureDetector(
            onVerticalDragEnd: (DragEndDetails details) =>
                _onVerticalDrag(details, newThoughtProvider, offlineMode),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.grey,
                image: DecorationImage(
                  image: AssetImage("assets/bluebackground.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            children: [
                              const Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: " Search...",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () {
                                  // Implement your search logic here
                                },
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  newThoughtProvider.category = "technology";
                                  newThoughtProvider.refreshData();
                                  setState(() {});
                                },
                                child: Text("Technology",
                                    style: newThoughtProvider.category ==
                                            "technology"
                                        ? selectedStyle
                                        : unselectedStyle)),
                            GestureDetector(
                                onTap: () {
                                  newThoughtProvider.category = "health";
                                  newThoughtProvider.refreshData();
                                  setState(() {});
                                },
                                child: Text("Health",
                                    style: newThoughtProvider.category == "health"
                                        ? selectedStyle
                                        : unselectedStyle)),
                            GestureDetector(
                                onTap: () {
                                  newThoughtProvider.category = "business";
                                  newThoughtProvider.refreshData();
                                  setState(() {});
                                },
                                child: Text("Business",
                                    style:
                                        newThoughtProvider.category == "business"
                                            ? selectedStyle
                                            : unselectedStyle)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Consumer<ThoughtProvider>(
                        builder: (BuildContext context, value, child) {
                      return PageView.builder(
                        controller: _pageController,
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            value.news.isNotEmpty ? value.news.length - 1 : 0,
                        itemBuilder: (context, index) {

                          if (value.news.isNotEmpty &&
                              index >= 0 &&
                              index < value.news.length) {
                            return Center(
                              child: Container(
                                height: 550,
                                width: MediaQuery.of(context).size.width * 0.8,
                                decoration: BoxDecoration(
                                  // red border
                                  border: Border.all(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FullPageNews(
                                                          newsArticle: value
                                                              .news[index])));
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          child: Container(
                                            width: double.infinity,
                                            height: 200,
                                            color: Colors.grey[200],
                                            child: Image.network(
                                              value.news[index].urlToImage,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        value.news[index].title.length > 90
                                            ? "${value.news[index].title.substring(0, 90)}..."
                                            : value.news[index].title,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        textAlign: TextAlign.start,
                                        value.news[index].author,
                                        style:
                                            const TextStyle(color: Color(0xff464646)),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        value.news[index].content.length > 250
                                            ? "${value.news[index].content.substring(0, 250)}..."
                                            : "${value.news[index].content.toString().substring(0, value.news[index].content.length - 15)}...",
                                        style:
                                            const TextStyle(color: Color(0xff7a7a7a)),
                                      ),
                                      const Spacer(),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => FullPageNews(newsArticle: value.news[index])));
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  // red border
                                                  border: Border.all(
                                                    color: Colors.blue,
                                                    width: 1,
                                                  ),
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(10.0),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text("Read more"),
                                                )),
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () async {
                                              await newThoughtProvider.writeNews(value.news[index]);
                                              value.news[index].isBookmarked = true;
                                              setState(() {});
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.blue,
                                                    width: 1,
                                                  ),
                                                  color: value.news[index].isBookmarked == true?Colors.blue:Colors.grey[200],
                                                  borderRadius:
                                                  BorderRadius.circular(10.0),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: value.news[index].isBookmarked == true?const Text("Bookmarked"):const Text("Add Bookmark")
                                                )),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            // Handle the case when there are no news articles
                            return const Center(
                              child: Text("No news articles available."),
                            );
                          }
                        },
                      );
                    }),
                  ),
                  Expanded(
                    flex: 1,
                      child: Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.keyboard_arrow_up),
                            onPressed: () {
                            },
                          ),
                          const Text("Swipe up for Bookmarked News"),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // on vertically dragging the up from the screen the bookmarked news will be loaded
  _onVerticalDrag(DragEndDetails details, ThoughtProvider newThoughtProvider,
      bool offlineMode) {
    if (details.primaryVelocity == 0) {
      return;
    }
    if (details.primaryVelocity?.compareTo(0) == -1) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const BookmarkedNews()));
    } else {
      if (offlineMode) {
        Utils().toastMessage(
            "The network is not available, page will refresh once its available. ");
      } else {
        newThoughtProvider.getNewNews();
      }
    }
  }
}
