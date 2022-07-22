import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_project/data/model/comment.dart';
import 'package:shop_project/data/repo/comment_repository.dart';
import 'package:shop_project/ui/home/widgets/error.dart';
import 'package:shop_project/ui/product/comment/bloc/commentlist_bloc.dart';

class CommentList extends StatelessWidget {
  final int productId;
  const CommentList({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final CommentListBloc bloc = CommentListBloc(
            repository: commentRepository, productId: productId);
        bloc.add(CommentListStarted());
        return bloc;
      },
      child: BlocBuilder<CommentListBloc, CommentListState>(
          builder: (context, state) {
        if (state is CommentListSuccess) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return CommentItem(comment: state.comments[index]);
              },
              childCount: state.comments.length,
            ),
          );
        } else if (state is CommentListLoading) {
          return const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()));
        } else if (state is CommentListError) {
          return SliverToBoxAdapter(
            child: AppErrorWidget(
                exeption: state.exeption,
                onPressed: () {
                  BlocProvider.of<CommentListBloc>(context)
                      .add(CommentListStarted());
                }),
          );
        } else {
          throw Exception('state not supported');
        }
      }),
    );
  }
}

class CommentItem extends StatelessWidget {
  final CommentEntity comment;
  const CommentItem({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        
        decoration: BoxDecoration(
            color: Colors.white,
            // border:
                // Border.all(width: 1, color: Color.fromARGB(255, 204, 203, 203)),
                boxShadow: [BoxShadow(blurRadius: 8,color: Colors.grey)],
            borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(comment.title),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      comment.email,
                      style: Theme.of(context).textTheme.caption,
                    )
                  ],
                ),
                Text(
                  comment.date,
                  style: Theme.of(context).textTheme.caption,
                )
              ],
            ),
            Text(comment.content),
            SizedBox(
              height: 30,
            )
          ],
        ));
  }
}
