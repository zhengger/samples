// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:veggieseasons/data/model.dart';
import 'package:veggieseasons/data/veggie.dart';
import 'package:veggieseasons/styles.dart';
import 'package:veggieseasons/widgets/search_bar.dart';
import 'package:veggieseasons/widgets/veggie_headline.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class SearchService {
  AppState _model;

  SearchService() {
    _results = Observable(_searchTerms.stream).switchMap((terms) async* {
      print("Terms received: '$terms'");
      await Future.delayed(Duration(milliseconds: 2000 ~/ (terms.length + 1)));
      print("Terms fetched: '$terms'");
      yield _model?.searchVeggiesSync(terms) ?? const <Veggie>[];
      print("Terms sent: '$terms'");
    }).shareValue(seedValue: const <Veggie>[]);
  }

  ValueObservable<List<Veggie>> _results;

  final _searchTerms = PublishSubject<String>();

  Sink<String> get searchTerms => _searchTerms.sink;

  ValueObservable<List<Veggie>> get results => _results;

  void dispose() {
    _searchTerms.close();
  }

  void registerModel(AppState model, String terms) {
    _model = model;
    searchTerms.add(terms);
  }
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _search = SearchService();

  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<AppState>(context, rebuildOnChange: true);
    _search.registerModel(model, _controller.text);

    return CupertinoTabView(
      builder: (context) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: Styles.scaffoldBackground,
          ),
          child: SafeArea(
            child: Column(
              children: [
                _createSearchBox(),
                Expanded(
                  child: StreamBuilder<List<Veggie>>(
                    initialData: _search.results.value,
                    stream: _search.results,
                    builder: (context, snapshot) => ListView(
                          children: _generateVeggieRows(snapshot.data),
                        ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _search.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  Widget _createSearchBox() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SearchBar(
        controller: _controller,
        focusNode: _focusNode,
      ),
    );
  }

  List<Widget> _generateVeggieRows(List<Veggie> veggies) {
    final cards = new List<Widget>();

    for (Veggie veggie in veggies) {
      cards.add(Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24.0),
        child: VeggieHeadline(veggie),
      ));
    }

    return cards;
  }

  void _onTextChanged() {
    _search.searchTerms.add(_controller.text);
  }
}
