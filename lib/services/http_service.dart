import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../models/app_config.dart';

class HTTPService {
  final Dio dio = Dio();
  AppConfig? _appConfig;
  String? _base_url;

  HTTPService() {
    _appConfig = GetIt.instance.get<AppConfig>();
    _base_url = _appConfig!.COIN_API_BASE_URL;
  }

  Future<Response?> get(String _path) async {
    try {
      String url = "$_base_url$_path";
      Response response = await dio.get(url);
      return response;
    } catch (e) {
      print('HTTPService: Unable to perform get request.');
      print(e);
    }
  }
}
