class NewsArticle {
  String urlToImage;
  String title;
  String description;
  String content;
  String url;
  String author;
  bool isBookmarked = false;

  NewsArticle(
      {required this.urlToImage,
        required this.content,
        required this.description,
        required this.title,
        required this.url,
        required this.author,
        required bool isBookmarked});

  static NewsArticle fromJSON(Map<String, dynamic> article) {
    return NewsArticle(
        urlToImage: article["urlToImage"] ?? "https://img.freepik.com/free-vector/breaking-news-concept_23-2148514216.jpg?w=2000",
        content: article["content"] ?? "Content Not available",
        description: article["description"] ?? "Article Description not available",
        title: article["title"]  ?? "Article Title not available",
        url: article["url"] ?? "https://news.google.com/topstories?hl=en-IN&gl=IN&ceid=IN:en",
        author: article["author"]?? "author not available",
        isBookmarked: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'urlToImage': urlToImage,
      'content': content,
      'description': description,
      'title': title,
      'url': url,
      'author': author,
      'isBookmarked': isBookmarked,
    };
  }
}
