import 'package:flutter/material.dart';
import 'package:quotes_app/controller/sharedpref_controller.dart';
import 'package:quotes_app/models/quote.dart';

class QuoteEditView extends StatefulWidget {
  final Quote quote;
  const QuoteEditView({
    Key? key,
    required this.quote,
  }) : super(key: key);

  @override
  State<QuoteEditView> createState() => _QuoteEditViewState();
}

class _QuoteEditViewState extends State<QuoteEditView> {
  SharedPrefController sharedPrefController = SharedPrefController();
  @override
  Widget build(BuildContext context) {
    TextEditingController quoteController =
        TextEditingController(text: widget.quote.content);
    TextEditingController authorController =
        TextEditingController(text: widget.quote.author);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update/Edit'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow, width: 5.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 5.0),
                ),
              ),
              controller: quoteController,
              maxLines: 5,
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow, width: 5.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 5.0),
                ),
              ),
              controller: authorController,
              maxLines: 1,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.yellow),
              ),
              child: const Text(
                'Update',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () async {
                sharedPrefController.remove(widget.quote.id!);
                widget.quote.author = authorController.text.trim();
                widget.quote.content = quoteController.text.trim();
                sharedPrefController.save(
                  widget.quote.id!,
                  widget.quote.toJsonForSP(),
                );
                setState(() {
                  
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
