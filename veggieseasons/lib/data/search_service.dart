import 'package:rxdart/rxdart.dart';
import 'package:veggieseasons/data/model.dart';
import 'package:veggieseasons/data/veggie.dart';

class SearchService {
  AppState _model;

  Observable<List<Veggie>> _results;

  final _searchTerms = BehaviorSubject<String>();

  SearchService(this._model) {
    final resultsSubject = BehaviorSubject<List<Veggie>>();
    _results = resultsSubject.shareValue(seedValue: <Veggie>[]);
    _searchTerms.stream.listen((terms) async {
      final results = await _model.searchVeggiesAsync(terms);
      resultsSubject.add(results);
    });
  }

  Observable<List<Veggie>> get results => _results;

  Sink<String> get searchTerms => _searchTerms.sink;

  void dispose() {
    _searchTerms.close();
  }
}
