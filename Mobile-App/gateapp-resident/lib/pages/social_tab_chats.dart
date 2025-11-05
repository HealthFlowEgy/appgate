import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_user/bloc/chat_cubit.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/config/page_routes.dart';
import 'package:gateapp_user/models/chat.dart';
import 'package:gateapp_user/utility/locale_data_layer.dart';
import 'package:gateapp_user/widgets/cached_image.dart';
import 'package:gateapp_user/widgets/error_final_widget.dart';
import 'package:gateapp_user/widgets/loader.dart';

class SocialTabChats extends StatefulWidget {
  const SocialTabChats({super.key});

  @override
  State<SocialTabChats> createState() => _SocialTabChatsState();
}

class _SocialTabChatsState extends State<SocialTabChats>
    with AutomaticKeepAliveClientMixin<SocialTabChats> {
  late ChatCubit _chatCubit;
  List<Chat> _chats = [];
  bool _isLoading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _chatCubit = BlocProvider.of<ChatCubit>(context);
    _chatCubit.initFetchChats();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _chatCubit.state is ChatsLoading) {
        _isLoading = false;
        _chats = [];
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ThemeData theme = Theme.of(context);
    return BlocListener<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is ChatsLoaded) {
          //widget.bottomNavigationInteractor.refreshChatsPendingCount();
          _isLoading = false;
          _chats = state.chats;
          setState(() {});
        }
        if (state is ChatsFail) {
          _isLoading = false;
          setState(() {});
        }
      },
      child: _chats.isNotEmpty
          ? ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: _chats.length,
              separatorBuilder: (context, index) => const SizedBox(height: 28),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  PageRoutes.chatPage,
                  arguments: _chats[index],
                ).then((value) {
                  if (mounted) {
                    _chats[index].isRead = true;
                    setState(() {});
                    LocalDataLayer().setChatRead(_chats[index]).then((value) {
                      // widget.bottomNavigationInteractor
                      //     .refreshChatsPendingCount();
                    });
                  }
                }),
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          CachedImage(
                            imageUrl: _chats[index].chatImage,
                            imagePlaceholder: "assets/plc_profile.png",
                            radius: 18,
                            height: 36,
                            width: 36,
                          ),
                          (_chats[index].isRead ?? false)
                              ? const SizedBox.shrink()
                              : const Positioned(
                                  top: 0,
                                  right: 4,
                                  child: CircleAvatar(
                                    radius: 4,
                                    backgroundColor: Color(0xffe73030),
                                  ),
                                ),
                        ],
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _chats[index].chatName ?? "",
                                    style: theme.textTheme.titleSmall,
                                  ),
                                ),
                                Text(
                                  _chats[index].timeDiff ?? "",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.hintColor.withOpacity(0.7)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _chats[index].lastMessage != null &&
                                      _chats[index]
                                          .lastMessage!
                                          .startsWith("attachment_type_")
                                  ? getLocalizationFor(
                                      _chats[index].lastMessage!)
                                  : (_chats[index].lastMessage ?? ""),
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 14,
                                color: theme.hintColor.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : _isLoading
              ? Loader.loadingWidget(context: context)
              : ErrorFinalWidget.errorWithRetry(
                  context: context,
                  message: AppLocalization.instance
                      .getLocalizationFor("empty_chats"),
                  imageAsset: "assets/plc_profile.png",
                ),
    );
  }
}
