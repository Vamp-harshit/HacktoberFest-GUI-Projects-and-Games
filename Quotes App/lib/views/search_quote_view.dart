import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quotes_app/views/quote_view.dart';

import '../controller/search_quote_response_controller.dart';
import '../models/quote.dart';
import '../providers/providers.dart';

class SearchQuoteView extends ConsumerStatefulWidget {
  const SearchQuoteView({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchQuoteView> createState() => _SearchQuoteViewState();
}

class _SearchQuoteViewState extends ConsumerState<SearchQuoteView>
    with AutomaticKeepAliveClientMixin {
  bool _quotesArrived = false;
  bool _errLoading = false;
  bool _quoteLoading = false;

  List<Quote>? quotes = [];
  final TextEditingController _queryController = TextEditingController();
  final TextEditingController _limitController = TextEditingController();

  Future<void> searchQuotesByQueryAndLimit() async {
    try {
      setState(() => _quoteLoading = true);
      quotes = await SearchQuotesResponseController(
        query: _queryController.text.trim(),
        limit: int.parse(
          _limitController.text.trim(),
        ),
      )
          .getSearchQuoteResponse()
          .then((value) => ref.read(searchQuoteProvider.state).state = value)
          .whenComplete(() => setState(() => _quoteLoading = false));
      if (quotes!.isNotEmpty) {
        _quotesArrived = true;
        _quoteLoading = false;
        setState(() {});
      }
    } catch (e) {
      _errLoading = true;
      _quoteLoading = false;
      setState(() {});
    }
  }

  void initialState() {
    _errLoading = false;
    _quotesArrived = false;
    quotes = [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return _errLoading
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.error, color: Colors.red, size: 28.0),
              const SizedBox(width: 5.0),
              const Text(
                "Something went wrong!",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.cancel_outlined, size: 28.0),
                color: Colors.white,
                onPressed: () => initialState(),
              ),
            ],
          )
        : !_quotesArrived
            ? Center(
                child: !_quoteLoading
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.yellowAccent,
                              ),
                              width: MediaQuery.of(context).size.width - 50,
                              height: 50,
                              child: TextField(
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                                controller: _queryController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Search Query",
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.yellowAccent,
                            ),
                            width: MediaQuery.of(context).size.width - 50,
                            height: 40,
                            child: TextField(
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              controller: _limitController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter limit(1 - 100)",
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.yellowAccent),
                            ),
                            onPressed: () async {
                              searchQuotesByQueryAndLimit();
                            },
                            child: const Text(
                              'Search',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      )
                    : const CircularProgressIndicator(
                        color: Colors.yellow,
                      ),
              )
            : Stack(
                children: [
                  Column(
                    children: [
                      Flexible(
                        flex: 1,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return QuoteView(
                              quote: quotes![index],
                              initialState: initialState,
                              fromSearchQuotePage: false,
                            );
                          },
                          itemCount: quotes!.length,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 30,
                    right: 20,
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.yellowAccent),
                      ),
                      icon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      onPressed: () => initialState(),
                      label: const Text(
                        'Search',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              );
  }

  @override
  bool get wantKeepAlive => true;
}
