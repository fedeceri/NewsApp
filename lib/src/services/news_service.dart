import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsapp/src/models/category_model.dart';
import 'package:newsapp/src/models/news_models.dart';
import 'package:http/http.dart' as http;

final _URL_NEWS = 'https://newsapi.org/v2';
final _APIKEY = '2fb2256fdd5944c0a54d0538592e0959';

class NewsService with ChangeNotifier{

  List<Article> headlines = [];
  String _selectedCategory = 'business';
  bool _isLoading = true;

  List<Category> categories = [
    Category(FontAwesomeIcons.building, 'business'),
    Category(FontAwesomeIcons.tv, 'entertainment'),
    Category(FontAwesomeIcons.addressCard, 'general'),
    Category(FontAwesomeIcons.headSideVirus, 'health'),
    Category(FontAwesomeIcons.vials, 'science'),
    Category(FontAwesomeIcons.volleyballBall, 'sports'),
    Category(FontAwesomeIcons.memory, 'technology'),
  ];

  Map<String, List<Article>> categoryArticles = {};

  NewsService() {
    this.getTopHeadlines();

    categories.forEach((element) {
      this.categoryArticles[element.name] = [];
    });
  }

  get selectedCategory => this._selectedCategory;
  set selectedCategory(String valor) {
    this._selectedCategory = valor;
    this.getArticlesByCategory(valor);

    _isLoading = true;
    notifyListeners();
  }

  List<Article> get getArticulosCategoriaSeleccionada => this.categoryArticles[this.selectedCategory];

  bool get isLoading => _isLoading;

  getTopHeadlines() async {
    print('Cargando headlines...');
    final url = Uri.parse('$_URL_NEWS/top-headlines?apiKey=$_APIKEY&country=ar');
    final resp = await http.get(url);

    final newsResponse = newsResponseFromJson(resp.body);

    this.headlines.addAll(newsResponse.articles);
    notifyListeners();
  }

  getArticlesByCategory(String category) async {
    if(this.categoryArticles[category].length > 0) {
      _isLoading =false;
      notifyListeners();
      return this.categoryArticles[category];
    }


      final url = Uri.parse('$_URL_NEWS/top-headlines?apiKey=$_APIKEY&country=ar&category=$category');
      final resp = await http.get(url);

      final newsResponse = newsResponseFromJson(resp.body);

      this.categoryArticles[category].addAll(newsResponse.articles);

      _isLoading = false;
      notifyListeners();
    }
  }

