import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_user/bloc/fetcher_cubit.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/models/post_request.dart';
import 'package:gateapp_user/models/resident_profile.dart';
import 'package:gateapp_user/utility/firebase_uploader.dart';
import 'package:gateapp_user/utility/helper.dart';
import 'package:gateapp_user/utility/locale_data_layer.dart';
import 'package:gateapp_user/utility/picker.dart';
import 'package:gateapp_user/widgets/cached_image.dart';
import 'package:gateapp_user/widgets/confirm_dialog.dart';
import 'package:gateapp_user/widgets/custom_button.dart';
import 'package:gateapp_user/widgets/loader.dart';
import 'package:gateapp_user/widgets/toaster.dart';
import 'package:photo_view/photo_view.dart';

class AddPostPage extends StatelessWidget {
  const AddPostPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => FetcherCubit(),
        child: const AddPostStateful(),
      );
}

class AddPostStateful extends StatefulWidget {
  const AddPostStateful({super.key});

  @override
  State<AddPostStateful> createState() => _AddPostStatefulState();
}

class _AddPostStatefulState extends State<AddPostStateful> {
  final TextEditingController _controller = TextEditingController();
  String? _imageUrl;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocListener<FetcherCubit, FetcherState>(
      listener: (context, state) {
        if (state is PostCreateLoading) {
          Loader.showLoader(context);
        } else {
          Loader.dismissLoader(context);
        }
        if (state is PostCreateLoaded) {
          Toaster.showToastCenter(
              AppLocalization.instance.getLocalizationFor("post_created"));
          Navigator.pop(context, state.post);
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
            AppLocalization.instance.getLocalizationFor("createPost"),
            style: theme.textTheme.titleLarge,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FutureBuilder<ResidentProfile?>(
                      future: LocalDataLayer().getResidentProfileMe(),
                      builder: (BuildContext context,
                              AsyncSnapshot<ResidentProfile?> snapshot) =>
                          CachedImage(
                        imageUrl: snapshot.data?.user?.imageUrl,
                        imagePlaceholder: "assets/plc_profile.png",
                        radius: 23,
                        height: 46,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _controller,
                    maxLines: 6,
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: AppLocalization.instance
                          .getLocalizationFor("whatsHappening"),
                      hintStyle: theme.textTheme.titleLarge
                          ?.copyWith(color: theme.hintColor),
                    ),
                  ),
                  if (_imageUrl != null) const SizedBox(height: 20),
                  if (_imageUrl != null)
                    SizedBox(
                      height: MediaQuery.of(context).size.width,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PhotoView(
                                  imageProvider:
                                      CachedImageProvider(_imageUrl!),
                                ),
                              ),
                            ),
                            child: CachedImage(
                              imageUrl: _imageUrl,
                              height: MediaQuery.of(context).size.width,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () => ConfirmDialog.showConfirmation(
                                      context,
                                      Text(AppLocalization.instance
                                          .getLocalizationFor("delete_image")),
                                      Text(AppLocalization.instance
                                          .getLocalizationFor(
                                              "delete_image_msg")),
                                      AppLocalization.instance
                                          .getLocalizationFor("no"),
                                      AppLocalization.instance
                                          .getLocalizationFor("yes"))
                                  .then((value) {
                                if (value != null && value == true) {
                                  _imageUrl = null;
                                  setState(() {});
                                }
                              }),
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  shape: BoxShape
                                      .rectangle, // BoxShape.circle or BoxShape.retangle
                                  //color: const Color(0xFF66BB6A),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black45,
                                      blurRadius: 0.5,
                                    ),
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white70,
                                  size: 16,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      buildOption(
                          theme,
                          Icons.camera_alt,
                          AppLocalization.instance.getLocalizationFor("camera"),
                          () => Picker()
                              .pickImageFile(
                                context: context,
                                pickerSource: PickerSource.camera,
                                restrictSquare: true,
                              )
                              .then((value) => _handlePickedFile(value))),
                      const SizedBox(width: 14),
                      buildOption(
                          theme,
                          Icons.photo_library,
                          AppLocalization.instance
                              .getLocalizationFor("gallery"),
                          () => Picker()
                              .pickImageFile(
                                context: context,
                                pickerSource: PickerSource.gallery,
                                restrictSquare: true,
                              )
                              .then((value) => _handlePickedFile(value))),
                    ],
                  ),
                  const SizedBox(height: 15),
                  CustomButton(
                    title:
                        AppLocalization.instance.getLocalizationFor("postNow"),
                    onTap: () {
                      Helper.closeKeyboard(context);
                      if (_controller.text.trim().isEmpty) {
                        Toaster.showToastCenter(AppLocalization.instance
                            .getLocalizationFor("add_caption"));
                      } else {
                        LocalDataLayer().getResidentProfileMe().then((value) =>
                            BlocProvider.of<FetcherCubit>(context)
                                .initCreatePost(PostRequest(
                              title: _controller.text.trim(),
                              image_urls: _imageUrl == null ? [] : [_imageUrl!],
                              meta: jsonEncode({
                                "project_id": value?.project_id,
                                "flat_id": value?.flat_id,
                                "flat_title": value?.flat?.title,
                                "type": "post",
                              }),
                            )));
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _handlePickedFile(File? filePicked) {
    if (filePicked != null && mounted) {
      // _imageUrl =
      //     "https://fastly.picsum.photos/id/874/200/200.jpg?hmac=mRU152zixoFMGIUREkgG83bUK2b5pIF0fhfIEnZKp6M";
      // setState(() {});
      String dpRef = "post_image_new_${DateTime.now().millisecondsSinceEpoch}";
      FirebaseUploader.uploadFile(
        context,
        filePicked,
        AppLocalization.instance.getLocalizationFor("uploading"),
        AppLocalization.instance.getLocalizationFor("just_moment"),
        dpRef,
      ).then((String? imageUrl) {
        if (imageUrl != null && mounted) {
          _imageUrl = imageUrl;
          setState(() {});
        }
      });
    }
  }
}

Expanded buildOption(
        ThemeData theme, IconData icon, String title, Function onTap) =>
    Expanded(
      child: GestureDetector(
        onTap: () => onTap.call(),
        child: Container(
          alignment: Alignment.center,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.hintColor.withOpacity(0.2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: theme.primaryColor,
              ),
              const SizedBox(width: 20),
              Text(
                title,
                style: theme.textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ),
    );
