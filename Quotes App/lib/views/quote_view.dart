import 'package:flutter/material.dart';
import 'package:quotes_app/controller/sharedpref_controller.dart';
import 'package:quotes_app/models/quote.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuoteView extends StatefulWidget {
  final Quote quote;
  final VoidCallback? initialState;
  final bool? fromSearchQuotePage;
  
  const QuoteView({
    Key? key,
    required this.quote,
    this.initialState,
    this.fromSearchQuotePage,
  }) : super(key: key);
  

  @override
  State<QuoteView> createState() => _QuoteViewState();
}

class _QuoteViewState extends State<QuoteView> {
  bool? _isLiked;
  final SharedPrefController sharedPrefController = SharedPrefController();

  Future<void> _toggleSaveQuoteToFavorites() async {
    bool value = await sharedPrefController.contains(widget.quote.id!);
    if (value) {
      await sharedPrefController.remove(widget.quote.id!);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("like${widget.quote.id!}", false);
    } else {
      Map data = widget.quote.toJsonForSP();
      await sharedPrefController.save(widget.quote.id!, data);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("like${widget.quote.id!}", true);
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() => _isLiked = prefs.getBool("like${widget.quote.id!}"));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 8.0),
        child: ListTile(
          title: Text(
            "${widget.quote.content!}\n",
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 22.0,
            ),
          ),
          subtitle: Text(
            widget.quote.author!,
            style: const TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            onPressed: () async {
              _toggleSaveQuoteToFavorites();
            },
            icon: (_isLiked == null || _isLiked == false)
                ? const Icon(Icons.thumb_up_alt_outlined)
                : const Icon(Icons.thumb_up),
            color: Colors.black87,
          ),
          trailing: Visibility(
            visible: widget.fromSearchQuotePage!,
            child: IconButton(
              icon: const Icon(Icons.cancel_outlined, size: 28.0),
              color: Colors.black87,
              onPressed: widget.initialState,
            ),
          ),
        ),
      ),
    );
  }
}
