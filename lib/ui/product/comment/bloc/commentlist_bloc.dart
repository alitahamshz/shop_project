import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shop_project/common/exeption.dart';
import 'package:shop_project/data/model/comment.dart';
import 'package:shop_project/data/repo/comment_repository.dart';

part 'commentlist_event.dart';
part 'commentlist_state.dart';

class CommentListBloc extends Bloc<CommentListEvent, CommentListState> {
  final ICommentRepository repository;
  final int productId;
  CommentListBloc({required this.repository, required this.productId})
      : super(CommentListLoading()) {
    on<CommentListEvent>((event, emit) async {
      if (event is CommentListStarted) {
        emit(CommentListLoading());

        try {
          final comments = await repository.getAllComments(productId);
          
          emit(CommentListSuccess(comments));
        } catch (e) {
          emit(CommentListError(AppExeption()));
        }
      }
    });
  }
}
