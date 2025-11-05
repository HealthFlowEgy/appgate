// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_user/utility/firebase_uploader.dart';
import 'package:gateapp_user/utility/helper.dart';
import 'package:gateapp_user/utility/picker.dart';
import 'package:gateapp_user/widgets/loader.dart';
import 'package:photo_view/photo_view.dart';

import 'package:gateapp_user/bloc/fetcher_cubit.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/models/category.dart' as my_cat;
import 'package:gateapp_user/models/complaint_request.dart';
import 'package:gateapp_user/utility/constants.dart';
import 'package:gateapp_user/utility/locale_data_layer.dart';
import 'package:gateapp_user/widgets/cached_image.dart';
import 'package:gateapp_user/widgets/confirm_dialog.dart';
import 'package:gateapp_user/widgets/custom_button.dart';
import 'package:gateapp_user/widgets/entry_field.dart';
import 'package:gateapp_user/widgets/toaster.dart';

class AddComplaintPage extends StatelessWidget {
  const AddComplaintPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => FetcherCubit(),
        child: const AddComplaintStateful(),
      );
}

class AddComplaintStateful extends StatefulWidget {
  const AddComplaintStateful({super.key});

  @override
  State<AddComplaintStateful> createState() => _AddComplaintStatefulState();
}

class _AddComplaintStatefulState extends State<AddComplaintStateful> {
  List<my_cat.Category> categories = [];
  my_cat.Category? _categorySelected;
  String complaintType = Constants.complaintTypePersonal;
  TextEditingController complaintMessageController = TextEditingController();
  List<String> complaintPhotos = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FetcherCubit>(context)
        .initFetchCategoriesWithScope(Constants.scopeComplaintType);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocListener<FetcherCubit, FetcherState>(
      listener: (context, state) {
        if (state is CategoriesLoaded) {
          categories = state.categories;
          setState(() {});
        }
        if (state is CreateUpdateComplaintLoading) {
          Loader.showLoader(context);
        } else {
          Loader.dismissLoader(context);
        }
        if (state is CreateUpdateComplaintLoaded) {
          Toaster.showToastCenter(
              AppLocalization.instance.getLocalizationFor("complaint_created"));
          Navigator.pop(context, state.complaint);
        }
        if (state is CreateUpdateComplaintFail) {
          Toaster.showToastCenter(
              AppLocalization.instance.getLocalizationFor(state.messageKey),
              state.messageKey != "something_wrong");
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: CustomButton(
            title:
                AppLocalization.instance.getLocalizationFor("submitComplaint"),
            onTap: () => _onSubmit(),
          ),
        ),
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(30),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Text(
                    AppLocalization.instance
                        .getLocalizationFor("raiseComplaint"),
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          children: [
            const SizedBox(height: 60),
            Text(
              AppLocalization.instance
                  .getLocalizationFor("selectComplaintType"),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  //color: Theme.of(context).hintColor,
                  //fontSize: 15,
                  ),
            ),
            DropdownButton<my_cat.Category>(
              value: _categorySelected,
              dropdownColor: theme.scaffoldBackgroundColor,
              isExpanded: true,
              icon: Icon(
                Icons.arrow_drop_down,
                color: theme.primaryColor,
              ),
              iconSize: 24,
              elevation: 16,
              style: theme.textTheme.titleSmall!.copyWith(
                //color: theme.secondaryHeaderColor,
                fontSize: 16,
              ),
              underline: Container(
                height: 0.5,
                color: theme.hintColor,
              ),
              onChanged: (my_cat.Category? newValue) =>
                  setState(() => _categorySelected = newValue),
              items: [
                for (my_cat.Category cat in categories)
                  DropdownMenuItem<my_cat.Category>(
                    value: cat,
                    child: Text(cat.title),
                  )
              ],
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: complaintType == Constants.complaintTypePersonal
                        ? BoxDecoration(
                            color: theme.primaryColor,
                            borderRadius: BorderRadius.circular(16),
                          )
                        : BoxDecoration(
                            border: Border.all(
                              color: theme.hintColor.withOpacity(0.5),
                              width: 0.8,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                    child: GestureDetector(
                      onTap: () => setState(() =>
                          complaintType = Constants.complaintTypePersonal),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_circle,
                            size: 20,
                            color:
                                complaintType == Constants.complaintTypePersonal
                                    ? theme.scaffoldBackgroundColor
                                    : null,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            AppLocalization.instance
                                .getLocalizationFor("personal"),
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontSize: 15,
                              color: complaintType ==
                                      Constants.complaintTypePersonal
                                  ? theme.scaffoldBackgroundColor
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: complaintType == Constants.complaintTypePersonal
                        ? BoxDecoration(
                            border: Border.all(
                              color: theme.hintColor.withOpacity(0.5),
                              width: 0.8,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          )
                        : BoxDecoration(
                            color: theme.primaryColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                    child: GestureDetector(
                      onTap: () => setState(() =>
                          complaintType = Constants.complaintTypeCommunity),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.business_outlined,
                            size: 20,
                            color:
                                complaintType == Constants.complaintTypePersonal
                                    ? null
                                    : theme.scaffoldBackgroundColor,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            AppLocalization.instance
                                .getLocalizationFor("community"),
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontSize: 15,
                              color: complaintType ==
                                      Constants.complaintTypePersonal
                                  ? null
                                  : theme.scaffoldBackgroundColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            EntryField(
              label: '',
              hintText: AppLocalization.instance
                  .getLocalizationFor("briefYourComplaint"),
              maxLines: 4,
              controller: complaintMessageController,
            ),
            const SizedBox(height: 40),
            Text(
              AppLocalization.instance.getLocalizationFor("attachPhoto"),
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.hintColor.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                for (int i = 0; i < complaintPhotos.length; i++)
                  SizedBox(
                    height: 108,
                    width: 108,
                    child: Stack(
                      children: [
                        GestureDetector(
                          // onTap: () =>
                          //     Helper.viewImage(context, _porfolios[index]),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PhotoView(
                                imageProvider:
                                    CachedImageProvider(complaintPhotos[i]),
                              ),
                            ),
                          ),
                          child: CachedImage(
                            imageUrl: complaintPhotos[i],
                            height: 108,
                            width: 108,
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
                                complaintPhotos.removeAt(i);
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
                GestureDetector(
                  onTap: () async {
                    File? filePicked = await Picker().pickImageFile(
                      context: context,
                      pickerSource: PickerSource.ask,
                      restrictSquare: true,
                    );
                    if (filePicked != null && mounted) {
                      String dpRef =
                          "complaint_image_new_${DateTime.now().millisecondsSinceEpoch}";
                      String? imageUrl = await FirebaseUploader.uploadFile(
                        context,
                        filePicked,
                        AppLocalization.instance
                            .getLocalizationFor("uploading"),
                        AppLocalization.instance
                            .getLocalizationFor("just_moment"),
                        dpRef,
                      );
                      if (imageUrl != null) {
                        complaintPhotos.add(imageUrl);
                        setState(() {});
                      }
                    }
                  },
                  child: Container(
                    height: 108,
                    width: 108,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.hintColor.withOpacity(0.3),
                      ),
                    ),
                    child: const Icon(Icons.camera_alt),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _onSubmit() {
    Helper.closeKeyboard(context);
    if (_categorySelected == null) {
      Toaster.showToastCenter(
          AppLocalization.instance.getLocalizationFor("select_complaint_type"));
    } else if (complaintMessageController.text.trim().length < 10) {
      Toaster.showToastCenter(AppLocalization.instance
          .getLocalizationFor("describe_complaint_brief"));
    } else {
      Helper.closeKeyboard(context);
      LocalDataLayer().getResidentProfileMe().then((value) {
        if (value != null) {
          ComplaintRequest complaintRequest = ComplaintRequest(
            type: complaintType,
            message: complaintMessageController.text.trim(),
            flat_id: value.flat_id!,
            category_id: _categorySelected!.id,
            meta: complaintPhotos.isNotEmpty
                ? jsonEncode({"photos": complaintPhotos})
                : null,
          );
          BlocProvider.of<FetcherCubit>(context)
              .initCreateComplaint(complaintRequest);
        } else {
          if (kDebugMode) {
            print("getResidentProfileMe: null");
          }
        }
      });
    }
  }
}
