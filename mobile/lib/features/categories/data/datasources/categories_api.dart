import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/category_model.dart';

part 'categories_api.g.dart';

@RestApi()
abstract class CategoriesApi {
  factory CategoriesApi(Dio dio) = _CategoriesApi;

  @GET('/categories')
  Future<List<CategoryModel>> getCategories();
}
