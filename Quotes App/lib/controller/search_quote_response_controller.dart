import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quotes_app/models/quote.dart';

class SearchQuotesResponseController {
  String query;
  int limit;

  SearchQuotesResponseController({
    required this.query,
    required this.limit,
  });

  Future<List<Quote>> getSearchQuoteResponse() async {
    String queryString = query.replaceAll(" ", "+");
    var url = Uri.parse("https://api.quotable.io/search/quotes?query=$queryString&limit=$limit");
    final response = await http.get(url);
    Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      List<Quote> quotes = [];
      for (int i = 0; i < limit; i++) {
        String content = data['results'][i]['content'];
        String id = data['results'][i]['_id'];
        String author = data['results'][i]['author'];
        Quote quote = Quote(
          author: author,
          content: content,
          id: id,
        );
        quotes.add(quote);
      }
      return quotes;
    } else {
      throw Exception('Failed to load');
    }
  }
}
