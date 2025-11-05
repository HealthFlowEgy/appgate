import 'package:flutter/material.dart';
import 'package:gateapp_user/models/resident_profile.dart';
import 'package:gateapp_user/utility/locale_data_layer.dart';

import 'cached_image.dart';

class ProfileIconWidget extends StatelessWidget {
  const ProfileIconWidget({super.key});

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0,
        ),
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
      );
}
