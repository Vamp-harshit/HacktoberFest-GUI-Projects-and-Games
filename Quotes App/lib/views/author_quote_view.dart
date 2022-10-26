import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quotes_app/controller/author_quotes_response_controller.dart';
import 'package:quotes_app/models/quote.dart';
import 'package:quotes_app/providers/providers.dart';
import 'package:quotes_app/views/quote_view.dart';

class AuthorQuoteView extends ConsumerStatefulWidget {
  const AuthorQuoteView({Key? key}) : super(key: key);

  @override
  ConsumerState<AuthorQuoteView> createState() => _AuthorQuoteViewState();
}

class _AuthorQuoteViewState extends ConsumerState<AuthorQuoteView>
    with AutomaticKeepAliveClientMixin {
  bool _quoteArrived = false;
  bool _quoteLoading = false;
  bool _errLoading = false;

  late Quote quote;
  final TextEditingController _authorController = TextEditingController();

  Future<void> searchAuthorQuote() async {
    try {
      setState(() => _quoteLoading = true);
      quote = ref.read(authorQuoteProvider.state).state ??
          await AuthorQuotesResponseController(
                  author: _authorController.text.trim())
              .getAuthorQuoteResponse()
              .then(
                  (value) => ref.read(authorQuoteProvider.state).state = value)
              .whenComplete(() => setState(() => _quoteLoading = false));
    } catch (e) {
      setState(() => _errLoading = true);
    }
  }

  void _initialState() {
    _errLoading = false;
    _quoteArrived = false;
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
                onPressed: () => _initialState(),
              ),
            ],
          )
        : !_quoteArrived
            ? Center(
                child: !_quoteLoading
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.yellowAccent,
                        ),
                        width: MediaQuery.of(context).size.width - 50,
                        height: 50,
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: TextField(
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                                controller: _authorController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Search Author",
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                ref.watch(authorQuoteProvider.state).state =
                                    null;
                                searchAuthorQuote().whenComplete(
                                    () => setState(() => _quoteArrived = true));
                              },
                              splashRadius: 1,
                              icon: const Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const CircularProgressIndicator(color: Colors.yellow),
              )
            : Center(
                child: QuoteView(
                  quote: quote,
                  initialState: _initialState,
                  fromSearchQuotePage: true,
                ),
              );
  }

  @override
  bool get wantKeepAlive => true;
}
