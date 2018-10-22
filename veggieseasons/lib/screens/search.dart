// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:veggieseasons/data/model.dart';
import 'package:veggieseasons/data/search_service.dart';
import 'package:veggieseasons/data/veggie.dart';
import 'package:veggieseasons/styles.dart';
import 'package:veggieseasons/widgets/search_bar.dart';
import 'package:veggieseasons/widgets/veggie_headline.dart';

class SearchScreen extends StatefulWidget {
  final AppState appState;

  SearchScreen(this.appState);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  SearchService get search => widget.appState.searchService;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(
      builder: (context) {
        return Container(
          color: Styles.scaffoldBackground,
          child: SafeArea(
            child: Column(
              children: [
                _createSearchBox(),
                Expanded(child: _createResultsArea()),
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
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    _onTextChanged();
  }

  Widget _createResultsArea() {
    return StreamBuilder<List<Veggie>>(
      initialData: search.results.value,
      stream: search.results,
      builder: (context, snapshot) => ListView(
            padding: const EdgeInsets.only(bottom: 200.0),
            children: _generateVeggieRows(snapshot.data),
          ),
    );
  }

  Widget _createSearchBox() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SearchBar(
        controller: _controller,
        focusNode: _focusNode,
      ),
    );
  }

  List<Widget> _generateVeggieRows(List<Veggie> veggies) => veggies
      .map((veggie) => Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24.0),
            child: VeggieHeadline(veggie),
          ))
      .toList(growable: false);

  void _onTextChanged() {
    search.searchTerms.add(_controller.text);
  }
}
