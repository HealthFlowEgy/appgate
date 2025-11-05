import 'package:flutter/material.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/widgets/custom_button.dart';

class ComplaintDetailPage extends StatelessWidget {
  const ComplaintDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListView(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 80,
            ),
            children: [
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 0.5,
                    color: theme.hintColor.withOpacity(0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        color: theme.colorScheme.background,
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.only(
                              start: 20,
                              top: 20,
                              bottom: 14,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      AppLocalization.instance
                                          .getLocalizationFor("plumbing"),
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(width: 15),
                                    CircleAvatar(
                                      radius: 2,
                                      backgroundColor:
                                          theme.hintColor.withOpacity(0.7),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      AppLocalization.instance
                                          .getLocalizationFor("community"),
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: theme.hintColor.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  AppLocalization.instance.getLocalizationFor(
                                      "valveIsNotWorkingProperly"),
                                  style: theme.textTheme.bodySmall
                                      ?.copyWith(color: theme.primaryColor),
                                ),
                              ],
                            ),
                          ),
                          PositionedDirectional(
                            top: 8,
                            end: 0,
                            child: Container(
                              alignment: Alignment.center,
                              height: 28,
                              width: 90,
                              decoration: const BoxDecoration(
                                color: Color(0xff57a523),
                                borderRadius: BorderRadiusDirectional.only(
                                  topStart: Radius.circular(12),
                                  bottomStart: Radius.circular(12),
                                ),
                              ),
                              child: Text(
                                AppLocalization.instance
                                    .getLocalizationFor("neww")
                                    .toUpperCase(),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.scaffoldBackgroundColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: theme.hintColor,
                                ),
                                children: [
                                  TextSpan(
                                      text: AppLocalization.instance
                                          .getLocalizationFor("raisedBy")),
                                  TextSpan(
                                    text: ' Jessica Taylor',
                                    style: TextStyle(color: theme.primaryColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Text(
                            '22 Aug, 03:30pm',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.hintColor.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              CustomButton(
                title: AppLocalization.instance
                    .getLocalizationFor("markAsResolved"),
                prefixIcon: Icon(
                  Icons.thumb_up,
                  size: 16,
                  color: theme.scaffoldBackgroundColor,
                ),
                onTap: () {},
              ),
              const SizedBox(height: 30),
              Text(
                AppLocalization.instance.getLocalizationFor("complaintPhotos"),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontSize: 15,
                  color: theme.hintColor.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Image.asset(
                    'assets/empty_image.png',
                    width: 108,
                  ),
                  const SizedBox(width: 14),
                  Image.asset(
                    'assets/empty_image.png',
                    width: 108,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                AppLocalization.instance.getLocalizationFor("recentComments"),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontSize: 15,
                  color: theme.hintColor.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 30),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: ((context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/plc_profile.png',
                            height: 34,
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Emili Williamson',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'A-232',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.hintColor.withOpacity(0.7),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  CircleAvatar(
                                    radius: 2,
                                    backgroundColor: theme.hintColor,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    '20 m ago',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.hintColor.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  );
                }),
                separatorBuilder: ((context, index) {
                  return const Divider(height: 40);
                }),
                itemCount: 2,
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 12,
            ),
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: theme.hintColor.withOpacity(0.5),
                width: 0.5,
              ),
              color: const Color(0xffe1e1e1),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/plc_profile.png',
                  height: 34,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none,
                      hintText: AppLocalization.instance
                          .getLocalizationFor("writeYourComment"),
                      hintStyle: theme.textTheme.labelLarge?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ),
                ),
                Text(
                  AppLocalization.instance
                      .getLocalizationFor("post")
                      .toUpperCase(),
                  style: theme.textTheme.labelLarge?.copyWith(fontSize: 15),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
