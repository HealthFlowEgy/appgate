import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_user/bloc/fetcher_cubit.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/models/complaint_request.dart';
import 'package:gateapp_user/utility/helper.dart';
import 'package:gateapp_user/utility/locale_data_layer.dart';
import 'package:gateapp_user/widgets/custom_button.dart';
import 'package:gateapp_user/widgets/entry_field.dart';
import 'package:gateapp_user/widgets/loader.dart';
import 'package:gateapp_user/widgets/toaster.dart';

class AddComplaintAdminPage extends StatelessWidget {
  const AddComplaintAdminPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => FetcherCubit(),
        child: AddComplaintAdminStateful(
            complaintType:
                ModalRoute.of(context)!.settings.arguments as String),
      );
}

class AddComplaintAdminStateful extends StatefulWidget {
  final String complaintType;
  const AddComplaintAdminStateful({super.key, required this.complaintType});

  @override
  State<AddComplaintAdminStateful> createState() =>
      _AddComplaintAdminStatefulState();
}

class _AddComplaintAdminStatefulState extends State<AddComplaintAdminStateful> {
  TextEditingController complaintMessageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocListener<FetcherCubit, FetcherState>(
      listener: (context, state) {
        if (state is CreateUpdateComplaintLoading) {
          Loader.showLoader(context);
        } else {
          Loader.dismissLoader(context);
        }
        if (state is CreateUpdateComplaintLoaded) {
          Toaster.showToastCenter(
              AppLocalization.instance.getLocalizationFor("msg_sent"));
          Navigator.pop(context);
        }
        if (state is CreateUpdateComplaintFail) {
          Toaster.showToastCenter(
              AppLocalization.instance.getLocalizationFor(state.messageKey),
              state.messageKey != "something_wrong");
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(30),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalization.instance
                            .getLocalizationFor(widget.complaintType),
                        style: theme.textTheme.titleLarge,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          children: [
            EntryField(
              label: '',
              hintText: AppLocalization.instance
                  .getLocalizationFor("enterYourMessage"),
              maxLines: 3,
              controller: complaintMessageController,
            ),
            const SizedBox(height: 30),
            CustomButton(
              title: AppLocalization.instance.getLocalizationFor("sendMessage"),
              onTap: () {
                if (complaintMessageController.text.trim().length < 10) {
                  Toaster.showToastCenter(AppLocalization.instance
                      .getLocalizationFor("describe_complaint_brief"));
                } else {
                  Helper.closeKeyboard(context);
                  LocalDataLayer().getResidentProfileMe().then((value) {
                    if (value != null) {
                      ComplaintRequest complaintRequest = ComplaintRequest(
                        type: widget.complaintType,
                        message: complaintMessageController.text.trim(),
                        flat_id: value.flat_id!,
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
