import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_user/bloc/fetcher_cubit.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/config/page_routes.dart';
import 'package:gateapp_user/models/media_data.dart';
import 'package:gateapp_user/widgets/cached_image.dart';
import 'package:gateapp_user/widgets/error_final_widget.dart';
import 'package:gateapp_user/widgets/loader.dart';

class SocialTabPosts extends StatelessWidget {
  final bool mine;
  final Key? postsTabStatefulKey;
  const SocialTabPosts({
    super.key,
    required this.mine,
    this.postsTabStatefulKey,
  });

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => FetcherCubit(),
        child: PostsStateful(mine: mine, key: postsTabStatefulKey),
      );
}

class PostsStateful extends StatefulWidget {
  final bool mine;
  const PostsStateful({
    super.key,
    required this.mine,
  });

  @override
  State<PostsStateful> createState() => PostsStatefulState();
}

class PostsStatefulState extends State<PostsStateful>
    with AutomaticKeepAliveClientMixin<PostsStateful> {
  final ScrollController _scrollController = ScrollController();
  final List<MediaData> _posts = [];
  final List<int> _postIdsLikeInProgress = [];
  bool _isLoading = true;
  int _page = 1;
  bool _allDone = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FetcherCubit>(context).initFetchPosts(widget.mine, 1);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ThemeData theme = Theme.of(context);
    return BlocListener<FetcherCubit, FetcherState>(
      listener: (context, state) {
        if (state is PostsLoaded) {
          _isLoading = false;
          _page = state.postsResponse.meta.current_page ?? 1;
          _allDone = state.postsResponse.meta.current_page ==
              state.postsResponse.meta.last_page;
          if (state.postsResponse.meta.current_page == 1) {
            _posts.clear();
          }
          _posts.addAll(state.postsResponse.data);
          setState(() {});
        }
        if (state is PostsFail) {
          _isLoading = false;
          setState(() {});
        }

        if (state is PostLikeToggleLoading) {
          int eIndex = _postIdsLikeInProgress.indexOf(state.postId);
          if (eIndex == -1) {
            _postIdsLikeInProgress.add(state.postId);
            setState(() {});
          }
        }
        if (state is PostLikeToggleLoaded) {
          int ePostIndex =
              _posts.indexWhere((element) => element.id == state.postId);
          if (ePostIndex != -1) {
            _posts[ePostIndex].isLiked = !_posts[ePostIndex].isLiked;
            if (_posts[ePostIndex].isLiked) {
              _posts[ePostIndex].likesCount += 1;
            } else if (_posts[ePostIndex].likesCount > 0) {
              _posts[ePostIndex].likesCount -= 1;
            }
          }
          int eIndex = _postIdsLikeInProgress.indexOf(state.postId);
          if (eIndex != -1) {
            _postIdsLikeInProgress.removeAt(eIndex);
          }
          if (ePostIndex != -1 || eIndex != -1) {
            setState(() {});
          }
        }
        if (state is PostLikeToggleFail) {
          int eIndex = _postIdsLikeInProgress.indexOf(state.postId);
          if (eIndex != -1) {
            _postIdsLikeInProgress.removeAt(eIndex);
            setState(() {});
          }
        }
      },
      child: RefreshIndicator(
        onRefresh: () => BlocProvider.of<FetcherCubit>(context)
            .initFetchPosts(widget.mine, 1),
        child: _posts.isNotEmpty
            ? ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 20,
                ),
                separatorBuilder: (context, index) => const Divider(height: 40),
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  if (index == _posts.length - 1 && !_isLoading && !_allDone) {
                    _isLoading = true;
                    BlocProvider.of<FetcherCubit>(context)
                        .initFetchPosts(widget.mine, _page + 1);
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CachedImage(
                            imageUrl: _posts[index].user.imageUrl,
                            imagePlaceholder: "assets/plc_profile.png",
                            radius: 22,
                            height: 43,
                            width: 43,
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _posts[index].user.name,
                                  style: theme.textTheme.titleSmall
                                      ?.copyWith(fontSize: 15),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _posts[index].meta?["flat_title"] ?? "",
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ),
                                    Text(
                                      _posts[index].created_at_formatted ?? "",
                                      style: theme.textTheme.bodySmall,
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
                        _posts[index].title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_posts[index].imageUrl != null)
                        CachedImage(
                          imageUrl: _posts[index].imageUrl,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width,
                          imagePlaceholder: 'assets/empty_image.png',
                          fit: BoxFit.cover,
                        ),
                      if (_posts[index].imageUrl != null)
                        const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(
                                    context, PageRoutes.addCommentsPage,
                                    arguments: _posts[index])
                                .then((value) {
                              if (value != null && value == true && mounted) {
                                _posts[index].commentsCount += 1;
                                setState(() {});
                              }
                            }),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.message,
                                  color: theme.hintColor,
                                  size: 16,
                                ),
                                const SizedBox(width: 14),
                                Text(
                                  "${_posts[index].commentsCount} ${AppLocalization.instance.getLocalizationFor("comments")}",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.hintColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => BlocProvider.of<FetcherCubit>(context)
                                .initTogglePostLike(_posts[index].id),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (_postIdsLikeInProgress
                                    .contains(_posts[index].id))
                                  SizedBox(
                                    height: 14,
                                    width: 14,
                                    child:
                                        Loader.circularProgressIndicatorOfColor(
                                            _posts[index].isLiked
                                                ? theme.primaryColor
                                                : theme.hintColor),
                                  )
                                else
                                  Icon(
                                    Icons.thumb_up,
                                    color: _posts[index].isLiked
                                        ? theme.primaryColor
                                        : theme.hintColor,
                                    size: 16,
                                  ),
                                const SizedBox(width: 14),
                                Text(
                                  "${_posts[index].likesCount} ${AppLocalization.instance.getLocalizationFor("likes")}",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.hintColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                              .getLocalizationFor("empty_posts"),
                          imageAsset: "assets/plc_profile.png",
                        ),
                ],
              ),
      ),
    );
  }

  addInList(MediaData mediaData) {
    _posts.insert(0, mediaData);
    setState(() {});
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }
}
