import 'package:shop_project/data/common/http_client.dart';
import 'package:shop_project/data/model/banner.dart';
import 'package:shop_project/data/source/banner_source.dart';

final bannerRepository = BannerRepository(BannerDataSource(httpClient));

abstract class IBannerRepository {
  Future<List<BannerEntity>> getAllBanner();
}

class BannerRepository implements IBannerRepository {
  final IBannerDataSource dataSource;

  BannerRepository(this.dataSource);

  @override
  Future<List<BannerEntity>> getAllBanner() {
    return dataSource.getAllBanner();
  }
}
