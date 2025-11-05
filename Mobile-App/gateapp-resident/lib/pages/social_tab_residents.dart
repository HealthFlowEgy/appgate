import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_user/bloc/fetcher_cubit.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/config/page_routes.dart';
import 'package:gateapp_user/models/chat.dart';
import 'package:gateapp_user/models/flat_residents.dart';
import 'package:gateapp_user/utility/constants.dart';
import 'package:gateapp_user/utility/locale_data_layer.dart';
import 'package:gateapp_user/widgets/cached_image.dart';
import 'package:gateapp_user/widgets/error_final_widget.dart';
import 'package:gateapp_user/widgets/loader.dart';

class SocialTabResidents extends StatelessWidget {
  const SocialTabResidents({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => FetcherCubit(),
        child: const ResidentsStateful(),
      );
}

class ResidentsStateful extends StatefulWidget {
  const ResidentsStateful({super.key});

  @override
  State<ResidentsStateful> createState() => _ResidentsStatefulState();
}

class _ResidentsStatefulState extends State<ResidentsStateful>
    with AutomaticKeepAliveClientMixin<ResidentsStateful> {
  final List<FlatResidents> _residents = [];
  bool _isLoading = true;
  int _page = 1;
  bool _allDone = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FetcherCubit>(context).initFetchResidents(1);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ThemeData theme = Theme.of(context);
    return BlocListener<FetcherCubit, FetcherState>(
      listener: (context, state) {
        if (state is ResidentsLoaded) {
          _isLoading = false;
          _page = state.flatsResponse.meta.current_page ?? 1;
          _allDone = state.flatsResponse.meta.current_page ==
              state.flatsResponse.meta.last_page;
          if (state.flatsResponse.meta.current_page == 1) {
            _residents.clear();
          }
          _residents.addAll(state.flatsResponse.data);
          setState(() {});
        }
        if (state is ResidentsFail) {
          _isLoading = false;
          setState(() {});
        }
      },
      child: RefreshIndicator(
        onRefresh: () =>
            BlocProvider.of<FetcherCubit>(context).initFetchResidents(1),
        child: _residents.isNotEmpty
            ? ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 20),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemCount: _residents.length,
                itemBuilder: (context, oIndex) {
                  if (oIndex == _residents.length - 1 &&
                      !_isLoading &&
                      !_allDone) {
                    _isLoading = true;
                    BlocProvider.of<FetcherCubit>(context)
                        .initFetchResidents(_page + 1);
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Text(
                              _residents[oIndex].title,
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.hintColor.withOpacity(0.7)),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Divider(
                                  color: theme.hintColor.withOpacity(0.3)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        itemCount: _residents[oIndex].residents!.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 28),
                        itemBuilder: (context, iIndex) => Row(
                          children: [
                            CachedImage(
                              imageUrl: _residents[oIndex]
                                  .residents![iIndex]
                                  .user
                                  ?.imageUrl,
                              imagePlaceholder: "assets/plc_profile.png",
                              radius: 18,
                              height: 36,
                              width: 36,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _residents[oIndex]
                                            .residents![iIndex]
                                            .user
                                            ?.name ??
                                        "",
                                    style: theme.textTheme.titleSmall,
                                  ),
                                  // const SizedBox(height: 4),
                                  // Text(
                                  //   _allResidents[outerIndex][index].text,
                                  //   style:
                                  //       theme.textTheme.bodySmall?.copyWith(
                                  //             fontSize: 14,
                                  //             color: theme
                                  //                 .hintColor
                                  //                 .withOpacity(0.7),
                                  //           ),
                                  // ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => LocalDataLayer()
                                  .getResidentProfileMe()
                                  .then((value) => Navigator.pushNamed(
                                        context,
                                        PageRoutes.chatPage,
                                        arguments: Chat(
                                          myId:
                                              "${value!.user!.id}${Constants.roleUser}",
                                          chatId:
                                              "${_residents[oIndex].residents![iIndex].user_id}${Constants.roleUser}",
                                          chatImage: _residents[oIndex]
                                              .residents![iIndex]
                                              .user
                                              ?.imageUrl,
                                          chatName: _residents[oIndex]
                                              .residents![iIndex]
                                              .user
                                              ?.name,
                                          chatStatus: _residents[oIndex].title,
                                        ),
                                      )),
                              child: Icon(
                                Icons.message,
                                size: 20,
                                color: theme.hintColor.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
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
                              .getLocalizationFor("empty_residents"),
                          imageAsset: "assets/plc_profile.png",
                        ),
                ],
              ),
      ),
    );
  }
}
