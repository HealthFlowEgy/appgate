import 'dart:io';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_user/bloc/chat_cubit.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/models/chat.dart';
import 'package:gateapp_user/models/message.dart';
import 'package:gateapp_user/models/message_attachment.dart';
import 'package:gateapp_user/utility/firebase_uploader.dart';
import 'package:gateapp_user/utility/helper.dart';
import 'package:gateapp_user/utility/picker.dart';
import 'package:gateapp_user/widgets/cached_image.dart';
import 'package:gateapp_user/widgets/toaster.dart';
import 'package:photo_view/photo_view.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      ChatStateful(ModalRoute.of(context)!.settings.arguments as Chat);
}

class ChatStateful extends StatefulWidget {
  final Chat chat;
  const ChatStateful(this.chat, {Key? key}) : super(key: key);
  @override
  ChatStatefulState createState() => ChatStatefulState();
}

class ChatStatefulState extends State<ChatStateful> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _newMessageController = TextEditingController();

  late ChatCubit _chatCubit;

  List<Message> _messages = [];
  // ignore: unused_field
  bool _isLoading = true;

  @override
  void initState() {
    _chatCubit = BlocProvider.of<ChatCubit>(context);
    _chatCubit.initFetchChatMessages(widget.chat);
    super.initState();
  }

  @override
  void dispose() {
    _chatCubit.unRegisterChatMessages();
    _scrollController.dispose();
    _newMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocListener<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is MessagesLoaded) {
          _isLoading = false;
          _messages = state.messages.reversed.toList();
          setState(() {});
          _scrollController.animateTo(
            0.0,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
        }
        if (state is ChatsFail) {
          _isLoading = false;
          setState(() {});
        }
        // if (state is MessageSent) {
        //   _newMessageController.clear();
        //   setState(() {});
        // }
        if (state is MessageSendingFail) {
          Toaster.showToastCenter(
              AppLocalization.instance.getLocalizationFor(state.messageKey));
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                constraints: const BoxConstraints.expand(),
                padding: const EdgeInsets.only(top: 60.0, bottom: 76),
                child: FadedScaleAnimation(
                  scaleDuration: const Duration(milliseconds: 400),
                  fadeDuration: const Duration(milliseconds: 400),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    controller: _scrollController,
                    reverse: true,
                    itemCount: _messages.length,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 20.0),
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        if (_messages[index].attachment != null &&
                            _messages[index].attachment!.url != null) {
                          if (_messages[index].attachment!.type ==
                              MessageAttachment.attachmentTypeImage) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PhotoView(
                                  imageProvider: CachedImageProvider(
                                      _messages[index].attachment!.url ??
                                          "assets/empty_image.png"),
                                ),
                              ),
                            );
                          } else {
                            Helper.launchURL(_messages[index].attachment!.url!);
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment:
                              widget.chat.myId == _messages[index].senderId
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                          children: <Widget>[
                            Material(
                              elevation: 4.0,
                              color:
                                  widget.chat.myId == _messages[index].senderId
                                      ? theme.primaryColor
                                      : theme.scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(16.0),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 12.0),
                                child: Column(
                                  crossAxisAlignment: widget.chat.myId ==
                                          _messages[index].senderId
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: <Widget>[
                                    if (_messages[index].attachment != null &&
                                        _messages[index].attachment!.type ==
                                            MessageAttachment
                                                .attachmentTypeImage)
                                      CachedImage(
                                        imageUrl:
                                            _messages[index].attachment!.url,
                                        imagePlaceholder:
                                            "assets/empty_image.png",
                                        height: 180,
                                      ),
                                    if (_messages[index].attachment != null &&
                                        _messages[index].attachment!.type ==
                                            MessageAttachment
                                                .attachmentTypeImage)
                                      const SizedBox(height: 12),
                                    Text(
                                      _messages[index].body ?? "",
                                      textAlign: widget.chat.myId ==
                                              _messages[index].senderId
                                          ? TextAlign.left
                                          : TextAlign.right,
                                      style: widget.chat.myId ==
                                              _messages[index].senderId
                                          ? theme.textTheme.bodyMedium!
                                              .copyWith(
                                                  fontSize: 13.5,
                                                  height: 1.6,
                                                  color: theme
                                                      .scaffoldBackgroundColor)
                                          : theme.textTheme.bodyMedium!
                                              .copyWith(
                                              fontSize: 13.5,
                                              height: 1.6,
                                            ),
                                    ),
                                    const SizedBox(height: 7),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          _messages[index].timeDiff ?? "",
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: widget.chat.myId ==
                                                    _messages[index].senderId
                                                ? const Color(0x99b8f7ee)
                                                : const Color(0x474d4d4d),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        // widget.chat.myId ==
                                        //         _messages[index].senderId
                                        //     ? Icon(
                                        //         Icons.check_circle,
                                        //         color: isDelivered!
                                        //             ? Colors.blue
                                        //             : Colors.grey[300],
                                        //         size: 12.0,
                                        //       )
                                        //     : const SizedBox.shrink(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 16),
                      onPressed: () => Navigator.pop(context),
                    ),
                    FadedScaleAnimation(
                      scaleDuration: const Duration(milliseconds: 400),
                      fadeDuration: const Duration(milliseconds: 400),
                      child: CachedImage(
                        imageUrl: widget.chat.chatImage,
                        imagePlaceholder: "assets/plc_profile.png",
                        radius: 20,
                        height: 40,
                        width: 40,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.chat.chatName ?? "",
                          style: theme.textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.chat.chatStatus ?? "",
                          style: theme.textTheme.bodyLarge!.copyWith(
                            fontSize: 11,
                            color: const Color(0xff999999),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: TextFormField(
                    controller: _newMessageController,
                    decoration: InputDecoration(
                      fillColor: theme.scaffoldBackgroundColor,
                      filled: true,
                      hintText: AppLocalization.instance
                          .getLocalizationFor("writeYourMessage"),
                      hintStyle: theme.textTheme.bodyLarge!.copyWith(
                        fontSize: 13.5,
                        color: const Color(0xffa2a2a2),
                      ),
                      prefixIcon: GestureDetector(
                        onTap: () => _onAttach(),
                        child: Icon(
                          Icons.camera_alt,
                          color: theme.hintColor,
                        ),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () => _onSend(),
                        child: Icon(
                          Icons.send,
                          color: theme.primaryColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: theme.hintColor.withOpacity(0.2)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onAttach() => Picker()
          .pickImageFile(
        context: context,
        pickerSource: PickerSource.ask,
        restrictSquare: false,
      )
          .then((File? filePicked) {
        if (filePicked != null && mounted) {
          FirebaseUploader.uploadFile(
            context,
            filePicked,
            AppLocalization.instance.getLocalizationFor("uploading"),
            AppLocalization.instance.getLocalizationFor("just_moment"),
            "chat_doc_${widget.chat.myId}_${DateTime.now().millisecondsSinceEpoch}",
          ).then((String? fileUrl) {
            if (fileUrl != null && mounted) {
              _chatCubit.initSendChatMessageAttachment(
                widget.chat,
                MessageAttachment(
                  url: fileUrl,
                  type: MessageAttachment.attachmentTypeImage,
                ),
              );
            }
          });
        }
      });

  _onSend() {
    if (_newMessageController.text.trim().isEmpty) {
      Toaster.showToastCenter(getLocalizationFor("write_your_message"));
    } else {
      _chatCubit.initSendChatMessageText(
          widget.chat, _newMessageController.text.trim());
      _newMessageController.clear();
    }
  }
}
