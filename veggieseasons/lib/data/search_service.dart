import 'package:rxdart/rxdart.dart';
import 'package:veggieseasons/data/model.dart';
import 'package:veggieseasons/data/veggie.dart';

class SearchService {
  AppState _model;

  ValueObservable<List<Veggie>> _results;

  final _searchTerms = PublishSubject<String>();

  SearchService(this._model) {
    _results = Observable.concat([Observable.just(''), _searchTerms.stream])
        .debounce(const Duration(milliseconds: 500))
        .switchMap((terms) async* {
      yield await _model.searchVeggiesAsync(terms);
    }).shareValue(seedValue: const <Veggie>[]);
  }

  ValueObservable<List<Veggie>> get results => _results;

  Sink<String> get searchTerms => _searchTerms.sink;

  void dispose() {
    _searchTerms.close();
  }
}
