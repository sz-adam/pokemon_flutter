import 'package:flutter/material.dart';

class PaginationController {
  final ScrollController scrollController = ScrollController();
  bool isLoading = false;
  int offset = 0;
  final int limit;

  PaginationController({required this.limit});

  void addScrollListener(Function onLoadMore) {
    scrollController.addListener(() {
      if (scrollController.position.extentAfter < 500 && !isLoading) {
        onLoadMore();
      }
    });
  }

  void dispose() {
    scrollController.dispose();
  }
}
