import 'dart:async';
import 'dart:convert';
import 'constant/strings.dart';
import 'models/newsInfo.dart';
import 'package:http/http.dart' as http;

enum NewsAction { Fetch, Delete }

class NewsBloc {
  final _stateStreamController = StreamController<List<Article>>();
  StreamSink<List<Article>> get counterSink => _stateStreamController.sink;
  Stream<List<Article>> get counterStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<NewsAction>();
  StreamSink<NewsAction> get _eventSink => _eventStreamController.sink;
  Stream<NewsAction> get _eventStream => _eventStreamController.stream;

  NewsBloc() {
    _eventStream.listen((event) async {
      if (event == NewsAction.Fetch) {
        var news = await getNews();
      } else if (event == NewsAction.Delete) {}
    });
  }

  Future<NewsModel> getNews() async {
    var client = http.Client();
    late NewsModel newsModel;

    try {
      var uri = Uri.parse(Strings.news_url);
      var response = await client.get(uri);
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);

        newsModel = NewsModel.fromJson(jsonMap);
      }
    } on Exception {
      return newsModel;
    }

    return newsModel;
  }
}
