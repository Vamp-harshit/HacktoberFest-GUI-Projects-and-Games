import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quotes_app/models/quote.dart';

final StateProvider authorQuoteProvider = StateProvider<Quote?>((ref) => null);

final StateProvider searchQuoteProvider = StateProvider<List<Quote>?>((ref) => null);

final StateProvider pageIndexProv = StateProvider<int>((ref) => 0);
