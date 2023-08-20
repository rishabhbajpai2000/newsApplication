import 'package:advisor/Providers/NewsProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'FullPageNews.dart';

class BookmarkedNews extends StatefulWidget {
  const BookmarkedNews({super.key});

  @override
  State<BookmarkedNews> createState() => _BookmarkedNewsState();
}

class _BookmarkedNewsState extends State<BookmarkedNews> {
  @override
  void initState() {
    super.initState();
    final newThoughtProvider =
        Provider.of<ThoughtProvider>(context, listen: false);
    newThoughtProvider.readNews();
  }

  @override
  Widget build(BuildContext context) {
    final newThoughtProvider =
        Provider.of<ThoughtProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        body: Container(
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
                  flex: 1,
                  child: Center(child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(Icons.arrow_back, color: Colors.white,),
                        ),
                      ),
                      Expanded(child: Container()),
                      Text("Bookmarked News", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white, decoration: TextDecoration.underline),),
                      Expanded(child: Container()),
                      GestureDetector(
                        onTap: () async{
                          await newThoughtProvider.deleteAllAdvices();
                          // print("all news deleted");
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(Icons.delete, color: Colors.white,),
                        ),
                      ),
                    ],
                  ))),
              Expanded(
                flex: 5,
                child: Consumer<ThoughtProvider>(
                    builder: (BuildContext context, value, child) {
                      // value.readNews();
                      return PageView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                        value.bookmarkedNews.isNotEmpty ? value.bookmarkedNews.length: 0,
                        itemBuilder: (context, index) {

                          if (value.bookmarkedNews.isNotEmpty &&
                              index >= 0 &&
                              index < value.bookmarkedNews.length) {
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
                                                          newsart: value
                                                              .bookmarkedNews[index])));
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(20.0),
                                          child: Container(
                                            width: double.infinity,
                                            height: 200,
                                            color: Colors.grey[200],
                                            child: Image.network(
                                              value.bookmarkedNews[index].urlToImage,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        value.bookmarkedNews[index].title.length > 90
                                            ? "${value.bookmarkedNews[index].title.substring(0, 90)}..."
                                            : value.bookmarkedNews[index].title,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        textAlign: TextAlign.start,
                                        value.bookmarkedNews[index].author,
                                        style:
                                        TextStyle(color: Color(0xff464646)),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        value.news[index].content.length > 250
                                            ? "${value.bookmarkedNews[index].content.substring(0, 250)}..."
                                            : "${value.bookmarkedNews[index].content.toString().substring(0, value.bookmarkedNews[index].content.length - 15)}...",
                                        style:
                                        TextStyle(color: Color(0xff7a7a7a)),
                                      ),
                                      Spacer(),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap:(){
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FullPageNews(
                                                              newsart: value
                                                                  .bookmarkedNews[index])));
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
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text("Read more"),
                                                )),
                                          ),
                                          Spacer(),

                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            // Handle the case when there are no news articles
                            return Center(
                              child: Text("No news articles available."),
                            );
                          }
                        },
                      );
                    }),
              )

            ],


          ),
        )
      ),
    );
  }
}
