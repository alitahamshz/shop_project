import 'package:dio/dio.dart';
import 'package:shop_project/data/common/response_validator.dart';
import 'package:shop_project/data/model/banner.dart';

abstract class IBannerDataSource {
  Future<List<BannerEntity>> getAllBanner();
}
class BannerDataSource with HttpResponseValidator implements IBannerDataSource{
  final Dio httpClient;

  BannerDataSource(this.httpClient);
  @override
  Future<List<BannerEntity>> getAllBanner() async {
    final result = await httpClient.get('banner/slider');
    validateResult(result);
    final List<BannerEntity> banners = [];
    (result.data as List).forEach((element) {
      BannerEntity.fromJson(element);
      banners.add(BannerEntity.fromJson(element));
    });
    return banners;
  }

}