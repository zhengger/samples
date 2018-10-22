// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import 'package:veggieseasons/data/local_veggie_provider.dart';
import 'package:veggieseasons/data/search_service.dart';
import 'package:veggieseasons/data/veggie.dart';

class AppState extends Model {
  List<Veggie> _veggies;

  AppState() : _veggies = LocalVeggieProvider.veggies {
    _searchService = SearchService(this);
  }

  List<Veggie> get allVeggies => List<Veggie>.from(_veggies);

  Veggie getVeggie(int id) => _veggies.singleWhere((v) => v.id == id);

  List<Veggie> get availableVeggies {
    Season currentSeason = _getSeasonForDate(DateTime.now());
    return _veggies.where((v) => v.seasons.contains(currentSeason)).toList();
  }

  List<Veggie> get unavailableVeggies {
    Season currentSeason = _getSeasonForDate(DateTime.now());
    return _veggies.where((v) => !v.seasons.contains(currentSeason)).toList();
  }

  List<Veggie> get favoriteVeggies =>
      _veggies.where((v) => v.isFavorite).toList();

  SearchService get searchService => _searchService;

  SearchService _searchService;

  List<Veggie> searchVeggiesSync(String terms) => _veggies
      .where((v) => v.name.toLowerCase().contains(terms.toLowerCase()))
      .toList();

  Future<List<Veggie>> searchVeggiesAsync(String terms) async {
    // Constant delay.
    await Future.delayed(const Duration(milliseconds: 200));

    if (terms == 'p') {
      // Additional delay to make a point.
      print('Uh oh, waiting longer for "p".');
      await Future.delayed(const Duration(milliseconds: 1500));
    }

    return searchVeggiesSync(terms);
  }

  void toggleFavorite(int id) {
    Veggie veggie = getVeggie(id);
    veggie.isFavorite = !veggie.isFavorite;
    notifyListeners();
  }

  static Season _getSeasonForDate(DateTime date) {
    // Technically the start and end dates of seasons can vary by a day or so,
    // but this is close enough for produce.
    switch (date.month) {
      case 1:
        return Season.winter;
      case 2:
        return Season.winter;
      case 3:
        return date.day < 21 ? Season.winter : Season.spring;
      case 4:
        return Season.spring;
      case 5:
        return Season.spring;
      case 6:
        return date.day < 21 ? Season.spring : Season.summer;
      case 7:
        return Season.summer;
      case 8:
        return Season.summer;
      case 9:
        return date.day < 22 ? Season.autumn : Season.winter;
      case 10:
        return Season.autumn;
      case 11:
        return Season.autumn;
      case 12:
        return date.day < 22 ? Season.autumn : Season.winter;
      default:
        throw ArgumentError('Can\'t return a season for month #${date.month}.');
    }
  }
}
