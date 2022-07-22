import 'package:dio/dio.dart';
import 'package:shop_project/data/common/response_validator.dart';
import 'package:shop_project/data/model/comment.dart';

abstract class ICommentDataSource{
  Future<List<CommentEntity>> getAllComments(int productId);
}

class CommentDataSource with HttpResponseValidator implements ICommentDataSource{
  final Dio httpClient;

  CommentDataSource(this.httpClient);
  @override
  Future<List<CommentEntity>> getAllComments(int productId) async{
    final result =await httpClient.get('comment/list?product_id=$productId');
    validateResult(result);
    final List<CommentEntity> comments=[];
    (result.data as List).forEach((element) {
      comments.add(CommentEntity.fromJson(element));
    });
    return comments;
  }

}