import 'package:flutter/material.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';

class QuickSupportDialog extends StatelessWidget {
  const QuickSupportDialog({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Dialog(
      alignment: AlignmentDirectional.bottomEnd,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      insetPadding: EdgeInsets.only(
        top: 90,
        bottom: 90,
        left: MediaQuery.of(context).size.width - 276,
        right: 20,
      ),
      backgroundColor: const Color(0xffE3E3E4),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalization.instance.getLocalizationFor("sendMessage"),
              style: theme.textTheme.titleSmall?.copyWith(
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildSendMessageOption(
                  context,
                  AppLocalization.instance.getLocalizationFor("admin"),
                  'assets/security/security_admin.png',
                  onTap: () => Navigator.pop(context, "support_admin"),
                ),
                const SizedBox(width: 14),
                buildSendMessageOption(
                  context,
                  AppLocalization.instance.getLocalizationFor("security"),
                  'assets/security/security_message.png',
                  onTap: () => Navigator.pop(context, "support_security"),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              AppLocalization.instance.getLocalizationFor("securityAlert"),
              style: theme.textTheme.titleSmall?.copyWith(
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                buildSendMessageOption(
                  context,
                  AppLocalization.instance.getLocalizationFor("fireAlert"),
                  'assets/security/security_fire.png',
                  onTap: () => Navigator.pop(context, "support_fire"),
                ),
                const SizedBox(width: 14),
                buildSendMessageOption(
                  context,
                  AppLocalization.instance.getLocalizationFor("stuckInLift"),
                  'assets/security/security_lift.png',
                  onTap: () => Navigator.pop(context, "support_lift"),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                buildSendMessageOption(
                  context,
                  AppLocalization.instance.getLocalizationFor("animalThreat"),
                  'assets/security/security_snake.png',
                  onTap: () => Navigator.pop(context, "support_animal"),
                ),
                const SizedBox(width: 14),
                buildSendMessageOption(
                  context,
                  AppLocalization.instance.getLocalizationFor("visitorThreat"),
                  'assets/security/security_guestattack.png',
                  onTap: () => Navigator.pop(context, "support_visitor"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSendMessageOption(
          BuildContext context, String title, String image,
          {Function()? onTap}) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          height: 105,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).scaffoldBackgroundColor,
            image: DecorationImage(
              image: AssetImage(image),
              scale: 3,
              alignment: AlignmentDirectional.bottomEnd,
            ),
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Theme.of(context).primaryColor,
                ),
          ),
        ),
      );
}
