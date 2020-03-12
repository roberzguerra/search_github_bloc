import 'package:search_github_bloc/models/SearchItem.dart';

class SearchResult {
  final List<SearchItem> items;

  SearchResult(this.items);

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    final listItems = (json["items"] as List).cast<Map<String, dynamic>>()?.map((item) {
      return SearchItem.fromJson(item);
    })?.toList();

    return SearchResult(listItems);
  }

}