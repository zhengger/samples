import 'package:rxdart/rxdart.dart';
import 'package:veggieseasons/data/model.dart';
import 'package:veggieseasons/data/veggie.dart';

class SearchService {
  AppState _model;

  ValueObservable<List<Veggie>> _results;

  final _searchTerms = PublishSubject<String>();

  SearchService(this._model) {
    final results =
        Observable.concat([Observable.just(''), _searchTerms.stream])
            .debounce(const Duration(milliseconds: 500))
            .switchMap((terms) async* {
      yield await _model.searchVeggiesAsync(terms);
    });

    _results = Observable.combineLatest2(results, _model.outOfStockVeggies,
        (List<Veggie> result, Set<int> outOfStock) {
      return result.where((r) => !outOfStock.contains(r.id)).toList();
    }).shareValue(seedValue: const <Veggie>[]);
  }

  ValueObservable<List<Veggie>> get results => _results;

  Sink<String> get searchTerms => _searchTerms.sink;

  void dispose() {
    _searchTerms.close();
  }
}
