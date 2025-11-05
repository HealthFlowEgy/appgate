import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/models/category.dart';
import 'package:gateapp_user/widgets/cached_image.dart';
import 'package:gateapp_user/widgets/custom_search_bar.dart';
import 'package:gateapp_user/widgets/error_final_widget.dart';

class ServiceSearchPage extends StatelessWidget {
  const ServiceSearchPage({super.key});

  @override
  Widget build(BuildContext context) => ServiceSearchStateful(
      ModalRoute.of(context)!.settings.arguments as List<Category>);
}

class ServiceSearchStateful extends StatefulWidget {
  final List<Category> list;
  const ServiceSearchStateful(this.list, {super.key});

  @override
  State<ServiceSearchStateful> createState() => _ServiceSearchStatefulState();
}

class _ServiceSearchStatefulState extends State<ServiceSearchStateful> {
  final TextEditingController _searchBarController = TextEditingController();
  String? _query;
  Timer? _debounce;
  final List<Category> _results = [];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                Text(
                  AppLocalization.instance.getLocalizationFor("search_service"),
                  style: theme.textTheme.titleLarge,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          CustomSearchBar(
            margin: const EdgeInsets.all(12),
            editingController: _searchBarController,
            colorCard: theme.dividerColor,
            hint: AppLocalization.instance.getLocalizationFor("search_message"),
            onSubmittedAuto: (s) => _onSubmitted(s?.trim(), false),
            onSubmittedForce: (s) => _onSubmitted(s?.trim(), true),
            autofocus: true,
          ),
          Expanded(
            child: _results.isNotEmpty
                ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shrinkWrap: true,
                    itemCount: _results.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => Navigator.pop(context, _results[index]),
                      child: Stack(
                        //fit: StackFit.expand,
                        children: [
                          Container(
                            width: size.width,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 48,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.background,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              margin: const EdgeInsetsDirectional.only(end: 64),
                              child: Text(
                                _results[index].title,
                                style: theme.textTheme.labelLarge!
                                    .copyWith(fontSize: 16),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          PositionedDirectional(
                            top: 10,
                            end: 10,
                            bottom: -48,
                            child: CachedImage(
                              imageUrl: _results[index].image_url,
                              imagePlaceholder: "assets/empty_image.png",
                              width: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox(
                    height: 250,
                    width: size.width,
                    child: ErrorFinalWidget.errorWithRetry(
                      context: context,
                      message: AppLocalization.instance.getLocalizationFor(
                          _query == null ? "search_message" : "search_empty"),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchBarController.dispose();
    super.dispose();
  }

  _onSubmitted(String? query, bool forced) {
    if (query == null) {
      //Navigator.pop(context);
      return;
    }
    if (forced) {
      _onSubmittedAction(query);
    } else {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(
          const Duration(milliseconds: 1500), () => _onSubmittedAction(query));
    }
  }

  _onSubmittedAction(String query) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    currentFocus.unfocus();
    if (_query == null || _query != query) {
      _query = query;
      _results.clear();
      _results.addAll(widget.list.where((element) => element.title
          .trim()
          .toLowerCase()
          .contains(_query!.trim().toLowerCase())));
      setState(() {});
    }
  }
}
