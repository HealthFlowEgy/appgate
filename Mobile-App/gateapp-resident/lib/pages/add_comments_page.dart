import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_user/bloc/fetcher_cubit.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/models/comment_data.dart';
import 'package:gateapp_user/models/media_data.dart';
import 'package:gateapp_user/widgets/cached_image.dart';
import 'package:gateapp_user/widgets/error_final_widget.dart';
import 'package:gateapp_user/widgets/loader.dart';
import 'package:gateapp_user/widgets/toaster.dart';

class AddCommentsPage extends StatelessWidget {
  const AddCommentsPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => FetcherCubit(),
        child: AddCommentsStateful(
            post: ModalRoute.of(context)!.settings.arguments as MediaData),
      );
}

class AddCommentsStateful extends StatefulWidget {
  final MediaData post;
  const AddCommentsStateful({
    super.key,
    required this.post,
  });

  @override
  State<AddCommentsStateful> createState() => _AddCommentsStatefulState();
}

class _AddCommentsStatefulState extends State<AddCommentsStateful> {
  final TextEditingController _controller = TextEditingController();

  final List<CommentData> _comments = [];
  bool _isLoading = true;
  int _page = 1;
  bool _allDone = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FetcherCubit>(context)
        .initFetchPostComments(widget.post.id, 1);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocListener<FetcherCubit, FetcherState>(
      listener: (context, state) {
        if (state is PostCommentsLoaded) {
          _page = state.commentsResponse.meta.current_page ?? 1;
          _allDone = state.commentsResponse.meta.current_page ==
              state.commentsResponse.meta.last_page;
          if (state.commentsResponse.meta.current_page == 1) {
            _comments.clear();
          }
          _comments.addAll(state.commentsResponse.data);
          _isLoading = false;
          setState(() {});
        }
        if (state is PostCommentsFail) {
          _isLoading = false;
          setState(() {});
        }

        if (state is PostCommentCreateLoading) {
          Loader.showLoader(context);
        } else {
          Loader.dismissLoader(context);
        }
        if (state is PostCommentCreateLoaded) {
          Toaster.showToastCenter(
              AppLocalization.instance.getLocalizationFor("comment_created"));
          Navigator.pop(context, true);
        }
        if (state is PostCreateFail) {
          Toaster.showToastCenter(
              AppLocalization.instance.getLocalizationFor(state.messageKey),
              state.messageKey != "something_wrong");
          Navigator.pop(context);
        }
      },
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              AppLocalization.instance.getLocalizationFor("comments"),
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => BlocProvider.of<FetcherCubit>(context)
                      .initFetchPostComments(widget.post.id, 1),
                  child: _comments.isNotEmpty
                      ? ListView.separated(
                          itemCount: _comments.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 40),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 20,
                          ),
                          itemBuilder: (context, index) {
                            if (index == _comments.length - 1 &&
                                !_isLoading &&
                                !_allDone) {
                              _isLoading = true;
                              BlocProvider.of<FetcherCubit>(context)
                                  .initFetchPostComments(
                                      widget.post.id, _page + 1);
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CachedImage(
                                      imageUrl: _comments[index].user.imageUrl,
                                      imagePlaceholder:
                                          "assets/plc_profile.png",
                                      radius: 22,
                                      height: 43,
                                      width: 43,
                                    ),
                                    const SizedBox(width: 13),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _comments[index].user.name,
                                            style: theme.textTheme.titleSmall
                                                ?.copyWith(fontSize: 15),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                _comments[index]
                                                        .meta?["flat_title"] ??
                                                    "",
                                                style:
                                                    theme.textTheme.bodySmall,
                                              ),
                                              Text(
                                                _comments[index]
                                                        .created_at_formatted ??
                                                    "",
                                                style:
                                                    theme.textTheme.bodySmall,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  _comments[index].comment,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontSize: 12,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            );
                          },
                        )
                      : ListView(
                          children: [
                            _isLoading
                                ? Loader.loadingWidget(context: context)
                                : ErrorFinalWidget.errorWithRetry(
                                    context: context,
                                    message: AppLocalization.instance
                                        .getLocalizationFor("empty_comments"),
                                    imageAsset: "assets/plc_profile.png",
                                  ),
                          ],
                        ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                color: theme.hintColor.withOpacity(0.1),
                child: TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    suffixIcon: GestureDetector(
                      onTap: () => _onSubmit(),
                      child: const Icon(
                        Icons.send,
                        color: Color(0xff6333bb),
                      ),
                    ),
                    hintText: AppLocalization.instance
                        .getLocalizationFor("writeYourMessage"),
                    hintStyle: theme.textTheme.bodySmall,
                    fillColor: theme.scaffoldBackgroundColor,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }

  _onSubmit() {
    if (_controller.text.trim().isNotEmpty) {
      BlocProvider.of<FetcherCubit>(context)
          .initCreatePostComment(widget.post.id, _controller.text.trim());
    }
  }
}
