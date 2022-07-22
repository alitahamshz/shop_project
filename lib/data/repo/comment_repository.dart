import 'package:shop_project/data/common/http_client.dart';
import 'package:shop_project/data/model/comment.dart';
import 'package:shop_project/data/source/comment_source.dart';

final CommentRepository commentRepository = CommentRepository(CommentDataSource(httpClient));

abstract class ICommentRepository {
  Future<List<CommentEntity>> getAllComments(int productId);
}

class CommentRepository implements ICommentRepository{
  final ICommentDataSource dataSource;

  CommentRepository(this.dataSource);
  @override
  Future<List<CommentEntity>> getAllComments(int productId) {
    return  dataSource.getAllComments(productId);
  }

}