import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_user/bloc/fetcher_visitor_logs_cubit.dart';

class NotificationIndicatorIconWidget extends StatelessWidget {
  const NotificationIndicatorIconWidget({super.key});

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Stack(
          children: [
            Icon(
              Icons.notifications,
              color: Theme.of(context).hintColor,
            ),
            BlocBuilder<FetcherVisitorLogsCubit, FetcherVisitorLogsState>(
              buildWhen: (previous, current) => current is VisitorLogsLoaded,
              builder: (context, state) =>
                  BlocProvider.of<FetcherVisitorLogsCubit>(context)
                              .initGetVisitorLogsCount(status: "waiting") >
                          0
                      ? const Positioned(
                          top: 0,
                          right: 4,
                          child: CircleAvatar(
                            radius: 4,
                            backgroundColor: Color(0xffe73030),
                          ),
                        )
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      );
}
