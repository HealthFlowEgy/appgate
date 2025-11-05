import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_user/bloc/app_cubit.dart';
import 'package:gateapp_user/bloc/fetcher_cubit.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/models/resident_building.dart';
import 'package:gateapp_user/models/resident_flat.dart';
import 'package:gateapp_user/models/resident_profile.dart';
import 'package:gateapp_user/models/resident_profile_update_request.dart';
import 'package:gateapp_user/models/resident_project.dart';
import 'package:gateapp_user/widgets/custom_button.dart';
import 'package:gateapp_user/widgets/loader.dart';
import 'package:gateapp_user/widgets/toaster.dart';

class MyResidencyPage extends StatelessWidget {
  final bool fromRoot;
  const MyResidencyPage({
    super.key,
    this.fromRoot = false,
  });

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => FetcherCubit(),
        child: SelectResidenceStateful(
          fromRoot: fromRoot,
        ),
      );
}

class SelectResidenceStateful extends StatefulWidget {
  final bool fromRoot;
  const SelectResidenceStateful({
    super.key,
    this.fromRoot = false,
  });

  @override
  State<SelectResidenceStateful> createState() =>
      _SelectResidenceStatefulState();
}

class _SelectResidenceStatefulState extends State<SelectResidenceStateful> {
  ResidentProfile? _residentProfile;
  List<ResidentProject> residentProjects = [];
  List<ResidentBuilding> residentBuildings = [];
  List<ResidentFlat> residentFlats = [];
  ResidentProject? _residentProjectSelected;
  ResidentBuilding? _residentBuildingSelected;
  ResidentFlat? _residentFlatSelected;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FetcherCubit>(context).initFetchProfileMe();
    BlocProvider.of<FetcherCubit>(context).initFetchResidentProjects();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocListener<FetcherCubit, FetcherState>(
      listener: (context, state) {
        if (state is ResidentProfileLoaded) {
          _residentProfile = state.profile;
          setState(() {});
        }
        if (state is ResidentProfileFail) {
          Toaster.showToastCenter(
              AppLocalization.instance.getLocalizationFor(state.messageKey),
              state.messageKey != "something_wrong");
        }
        if (state is ResidentProjectsLoaded) {
          residentProjects = state.projects;
          if (_residentProfile != null &&
              _residentProfile!.project_id != null) {
            for (ResidentProject residentProject in residentProjects) {
              if (residentProject.id == _residentProfile!.project_id) {
                _residentProjectSelected = residentProject;
                BlocProvider.of<FetcherCubit>(context)
                    .initFetchResidentBuildings(_residentProjectSelected!.id);
                break;
              }
            }
          }
          setState(() {});
        }
        if (state is ResidentBuildingsLoaded) {
          residentBuildings = state.buildings;
          if (_residentProfile != null &&
              _residentProfile!.building_id != null) {
            for (ResidentBuilding residentBuilding in residentBuildings) {
              if (residentBuilding.id == _residentProfile!.building_id) {
                _residentBuildingSelected = residentBuilding;
                BlocProvider.of<FetcherCubit>(context)
                    .initFetchResidentFlats(_residentBuildingSelected!.id);
                break;
              }
            }
          }
          setState(() {});
        }
        if (state is ResidentFlatsLoaded) {
          residentFlats = state.flats;
          if (_residentProfile != null && _residentProfile!.flat_id != null) {
            for (ResidentFlat residentFlat in residentFlats) {
              if (residentFlat.id == _residentProfile!.flat_id) {
                _residentFlatSelected = residentFlat;
                break;
              }
            }
          }
          setState(() {});
        }
        if (state is ResidentProfileUpdateLoading) {
          Loader.showLoader(context);
        } else {
          Loader.dismissLoader(context);
        }
        if (state is ResidentProfileUpdateLoaded) {
          _residentProfile = state.profile;
          setState(() {});
          if (widget.fromRoot) {
            BlocProvider.of<AppCubit>(context).initAuthenticated();
          } else {
            Navigator.pop(context, state.profile);
          }
        }
        if (state is ResidentProfileUpdateFail) {
          Toaster.showToastCenter(
              AppLocalization.instance.getLocalizationFor(state.messageKey),
              state.messageKey != "something_wrong");
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            if (widget.fromRoot)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: IconButton(
                  onPressed: () => BlocProvider.of<AppCubit>(context).logOut(),
                  icon: const Icon(Icons.exit_to_app),
                ),
              )
          ],
        ),
        body: FadedSlideAnimation(
          beginOffset: const Offset(0, 0.3),
          endOffset: const Offset(0, 0),
          slideDuration: const Duration(milliseconds: 300),
          slideCurve: Curves.linearToEaseOut,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        AppLocalization.instance
                            .getLocalizationFor("selectSociety"),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalization.instance
                            .getLocalizationFor("searchAndSelectYour"),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).hintColor,
                              fontSize: 15,
                            ),
                      ),
                      if (_residentProfile != null &&
                          _residentProfile!.isComplete &&
                          !_residentProfile!.isApproved)
                        const SizedBox(height: 4),
                      if (_residentProfile != null &&
                          _residentProfile!.isComplete &&
                          !_residentProfile!.isApproved)
                        Text(
                          AppLocalization.instance.getLocalizationFor(
                              "profile_verification_pending"),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: const Color(0xffc93c3c),
                                    fontSize: 15,
                                  ),
                        ),
                      const SizedBox(height: 50),
                      Text(
                        AppLocalization.instance
                            .getLocalizationFor("selectYourSociety"),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            //color: Theme.of(context).hintColor,
                            //fontSize: 15,
                            ),
                      ),
                      DropdownButton<ResidentProject>(
                        value: _residentProjectSelected,
                        dropdownColor: theme.scaffoldBackgroundColor,
                        isExpanded: true,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: residentProjects.isEmpty
                              ? theme.hintColor
                              : theme.primaryColor,
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
                        onChanged: residentProjects.isEmpty
                            ? null
                            : (ResidentProject? newValue) {
                                bool newCatSelected =
                                    _residentProjectSelected == null ||
                                        _residentProjectSelected != newValue;
                                _residentProjectSelected = newValue;
                                if (newCatSelected) {
                                  _residentBuildingSelected = null;
                                  residentBuildings = [];
                                  BlocProvider.of<FetcherCubit>(context)
                                      .initFetchResidentBuildings(
                                          _residentProjectSelected!.id);
                                }
                                setState(() {});
                              },
                        items: [
                          for (ResidentProject cat in residentProjects)
                            DropdownMenuItem<ResidentProject>(
                              value: cat,
                              child: Text(cat.title ?? ""),
                            )
                        ],
                        hint: Text(AppLocalization.instance
                            .getLocalizationFor("select_society")),
                        disabledHint: Text(AppLocalization.instance
                            .getLocalizationFor("select_society")),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        AppLocalization.instance
                            .getLocalizationFor("select_building"),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            //color: Theme.of(context).hintColor,
                            //fontSize: 15,
                            ),
                      ),
                      DropdownButton<ResidentBuilding>(
                        value: _residentBuildingSelected,
                        dropdownColor: theme.scaffoldBackgroundColor,
                        isExpanded: true,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: _residentProjectSelected == null
                              ? theme.hintColor
                              : theme.primaryColor,
                        ),
                        iconSize: 24,
                        elevation: 16,
                        style: theme.textTheme.titleSmall!.copyWith(
                            //color: theme.secondaryHeaderColor,
                            ),
                        underline: Container(
                          height: 0.5,
                          color: theme.hintColor,
                        ),
                        onChanged: _residentProjectSelected == null
                            ? null
                            : (ResidentBuilding? newValue) {
                                bool newCatSelected =
                                    _residentBuildingSelected == null ||
                                        _residentBuildingSelected != newValue;
                                _residentBuildingSelected = newValue;

                                if (newCatSelected) {
                                  _residentFlatSelected = null;
                                  residentFlats = [];
                                  BlocProvider.of<FetcherCubit>(context)
                                      .initFetchResidentFlats(
                                          _residentBuildingSelected!.id);
                                }
                                setState(() {});
                              },
                        items: [
                          for (ResidentBuilding cat in residentBuildings)
                            DropdownMenuItem<ResidentBuilding>(
                              value: cat,
                              child: Text(cat.title ?? ""),
                            )
                        ],
                        hint: Text(AppLocalization.instance
                            .getLocalizationFor("select_your_building")),
                        disabledHint: Text(AppLocalization.instance
                            .getLocalizationFor("select_society_first")),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        AppLocalization.instance
                            .getLocalizationFor("select_flat"),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            //color: Theme.of(context).hintColor,
                            //fontSize: 15,
                            ),
                      ),
                      DropdownButton<ResidentFlat>(
                        value: _residentFlatSelected,
                        dropdownColor: theme.scaffoldBackgroundColor,
                        isExpanded: true,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: _residentBuildingSelected == null
                              ? theme.hintColor
                              : theme.primaryColor,
                        ),
                        iconSize: 24,
                        elevation: 16,
                        style: theme.textTheme.titleSmall!.copyWith(
                            //color: theme.secondaryHeaderColor,
                            ),
                        underline: Container(
                          height: 0.5,
                          color: theme.hintColor,
                        ),
                        onChanged: _residentBuildingSelected == null
                            ? null
                            : (ResidentFlat? newValue) {
                                // bool newCatSelected = _residentFlatSelected == null ||
                                //     _residentFlatSelected != newValue;
                                _residentFlatSelected = newValue;
                                setState(() {});
                                //if (newCatSelected) {}
                              },
                        items: [
                          for (ResidentFlat cat in residentFlats)
                            DropdownMenuItem<ResidentFlat>(
                              value: cat,
                              child: Text(cat.title ?? ""),
                            )
                        ],
                        hint: Text(AppLocalization.instance
                            .getLocalizationFor("select_your_flat")),
                        disabledHint: Text(AppLocalization.instance
                            .getLocalizationFor("select_building_first")),
                      ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 24,
                right: 24,
                bottom: 24,
                child: CustomButton(
                  title:
                      AppLocalization.instance.getLocalizationFor("continuee"),
                  onTap: () {
                    if (_residentProjectSelected == null) {
                      Toaster.showToastCenter(AppLocalization.instance
                          .getLocalizationFor("select_society"));
                    } else if (_residentBuildingSelected == null) {
                      Toaster.showToastCenter(AppLocalization.instance
                          .getLocalizationFor("select_building"));
                    } else if (_residentFlatSelected == null) {
                      Toaster.showToastCenter(AppLocalization.instance
                          .getLocalizationFor("select_flat"));
                    } else {
                      BlocProvider.of<FetcherCubit>(context)
                          .initUpdateResidentProfile(
                              ResidentProfileUpdateRequest(
                        project_id: _residentProjectSelected!.id,
                        building_id: _residentBuildingSelected!.id,
                        flat_id: _residentFlatSelected!.id,
                      ));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
