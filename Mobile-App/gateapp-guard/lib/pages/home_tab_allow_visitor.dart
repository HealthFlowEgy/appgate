import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_guard/bloc/fetcher_cubit.dart';
import 'package:gateapp_guard/config/localization/app_localization.dart';
import 'package:gateapp_guard/config/page_routes.dart';
import 'package:gateapp_guard/utility/constants.dart';
import 'package:gateapp_guard/utility/locale_data_layer.dart';
import 'package:gateapp_guard/widgets/loader.dart';
import 'package:gateapp_guard/widgets/number_button.dart';
import 'package:gateapp_guard/widgets/toaster.dart';

class HomeTabAllowVisitor extends StatelessWidget {
  const HomeTabAllowVisitor({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => FetcherCubit(),
        child: const AllowVisitorStateful(),
      );
}

class AllowVisitorStateful extends StatefulWidget {
  const AllowVisitorStateful({super.key});

  @override
  State<AllowVisitorStateful> createState() => _AllowVisitorStatefulState();
}

class _AllowVisitorStatefulState extends State<AllowVisitorStateful>
    with AutomaticKeepAliveClientMixin {
  final List<TextEditingController> _controllerList = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  final List<FocusNode> _focusNodeList = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  List<HomeItem> visitors = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _focusNodeList.first.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    for (var element in _controllerList) {
      element.dispose();
    }
    for (var element in _focusNodeList) {
      element.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ThemeData theme = Theme.of(context);
    visitors = [
      HomeItem(
        title: AppLocalization.instance.getLocalizationFor("guest"),
        image: 'assets/visitor_types/allow_guest.png',
        onTap: () => Navigator.pushNamed(context, PageRoutes.addVisitorLogPage,
            arguments: Constants.visitorTypeGuest),
      ),
      HomeItem(
        title: AppLocalization.instance.getLocalizationFor("delivery"),
        image: 'assets/visitor_types/allow_deliveryman.png',
        onTap: () => Navigator.pushNamed(context, PageRoutes.addVisitorLogPage,
            arguments: Constants.visitorTypeDelivery),
      ),
      HomeItem(
        title: AppLocalization.instance.getLocalizationFor("service"),
        image: 'assets/visitor_types/allow_serviceman.png',
        onTap: () => Navigator.pushNamed(context, PageRoutes.addVisitorLogPage,
            arguments: Constants.visitorTypeService),
      ),
      HomeItem(
        title: AppLocalization.instance.getLocalizationFor("cab"),
        image: 'assets/visitor_types/allow_cab.png',
        onTap: () => Navigator.pushNamed(context, PageRoutes.addVisitorLogPage,
            arguments: Constants.visitorTypeCab),
      ),
    ];
    return BlocListener<FetcherCubit, FetcherState>(
      listener: (context, state) {
        if (state is VisitorLogsLoading) {
          Loader.showLoader(context);
        } else {
          Loader.dismissLoader(context);
        }

        if (state is VisitorLogsLoaded) {
          if (state.visitorLogs.data.isEmpty) {
            Toaster.showToastCenter(
                AppLocalization.instance.getLocalizationFor("empty_results"),
                true);
          } else {
            Navigator.pushNamed(context, PageRoutes.visitorLogPage,
                arguments: state.visitorLogs.data.first);
          }
        }

        if (state is VisitorLogsFail) {
          Toaster.showToastCenter(
              AppLocalization.instance.getLocalizationFor(state.messageKey),
              state.messageKey != "something_wrong");
        }
      },
      child: Scaffold(
        body: ListView(
          children: [
            Stack(
              children: [
                Container(
                  color: theme.primaryColor,
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: theme.colorScheme.background,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 34,
                      vertical: 18,
                    ),
                    child: Row(
                      children: List.generate(
                        6,
                        (index) => Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            child: TextFormField(
                              showCursor: false,
                              focusNode: _focusNodeList[index],
                              controller: _controllerList[index],
                              decoration: const InputDecoration(
                                counter: SizedBox(),
                              ),
                              keyboardType: TextInputType.none,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              onChanged: (val) {
                                _controllerList[index].text = val;
                                _focusNodeList[index].unfocus();
                                if (index < _focusNodeList.length - 1) {
                                  _focusNodeList[index + 1].requestFocus();
                                } else {
                                  _onCodeComplete();
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemCount: 3,
              itemBuilder: (context, outerIndex) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  3,
                  (index) => NumberButton(
                    string: ((outerIndex * 3) + (index + 1)).toString(),
                    onTap: (val) {
                      for (int i = 0; i < _focusNodeList.length; i++) {
                        if (_focusNodeList[i].hasFocus) {
                          _controllerList[i].text = val;
                          if (i < _focusNodeList.length - 1) {
                            _focusNodeList[i + 1].requestFocus();
                          } else {
                            _onCodeComplete();
                          }
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, PageRoutes.qrScanPage)
                          .then((value) {
                    if (value != null && value is String) {
                      _onCodeSubmit(value);
                    }
                  }),
                  child: CircleAvatar(
                    radius: 26,
                    backgroundColor: const Color(0xff6333bb),
                    child: Icon(
                      Icons.qr_code,
                      color: theme.scaffoldBackgroundColor,
                      size: 28,
                    ),
                  ),
                ),
                NumberButton(
                  string: "0",
                  onTap: (val) {
                    for (int i = 0; i < _focusNodeList.length; i++) {
                      if (_focusNodeList[i].hasFocus) {
                        _controllerList[i].text = val;
                        if (i < _focusNodeList.length - 1) {
                          _focusNodeList[i + 1].requestFocus();
                        } else {
                          _onCodeComplete();
                        }
                      }
                    }
                  },
                ),
                NumberButton(
                  string: "",
                  child: Icon(
                    Icons.backspace_rounded,
                    color: theme.primaryColor,
                  ),
                  onTap: (val) {
                    for (int i = _focusNodeList.length - 1; i >= 0; i--) {
                      if (_controllerList[i].text.isNotEmpty) {
                        _controllerList[i].clear();
                        break;
                      }
                    }
                    for (int i = 0; i < _focusNodeList.length; i++) {
                      if (_controllerList[i].text.isEmpty) {
                        _focusNodeList[i].requestFocus();
                        break;
                      }
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 40),
            Container(
              color: theme.scaffoldBackgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalization.instance
                        .getLocalizationFor("addNewVisitor")
                        .toUpperCase(),
                    style: theme.textTheme.labelLarge?.copyWith(
                      letterSpacing: 1.4,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 104,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 10),
                      itemCount: visitors.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: visitors[index].onTap,
                        child: Container(
                          padding: const EdgeInsetsDirectional.only(
                            start: 12.0,
                            end: 12.0,
                          ),
                          width: 94,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: theme.colorScheme.background,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 12),
                              Text(
                                visitors[index].title,
                                style: theme.textTheme.labelLarge,
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                  child: Image.asset(visitors[index].image)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onCodeComplete() {
    String code = "";
    for (TextEditingController textEditingController in _controllerList) {
      code += textEditingController.text;
    }
    _onCodeSubmit(code);
  }

  _onCodeSubmit(String code) {
    for (TextEditingController textEditingController in _controllerList) {
      textEditingController.clear();
    }
    _focusNodeList[0].requestFocus();
    LocalDataLayer().getGuardProfileMe().then((value) {
      if (value != null) {
        BlocProvider.of<FetcherCubit>(context).initFetchVisitorLogs(
          projectId: value.project_id!,
          code: code,
        );
      }
    });
  }
}

class HomeItem {
  String title;
  String? subTitle;
  String image;
  Function()? onTap;

  HomeItem(
      {required this.title, this.subTitle, required this.image, this.onTap});
}
