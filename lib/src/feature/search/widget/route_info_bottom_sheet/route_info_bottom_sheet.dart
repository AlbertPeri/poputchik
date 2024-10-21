import 'package:companion/src/feature/search/bloc/route_info/route_info_bloc.dart';
import 'package:companion/src/feature/search/model/route/route.dart';
import 'package:companion/src/feature/search/widget/route_info_bottom_sheet/error_info/error_info.dart';
import 'package:companion/src/feature/search/widget/route_info_bottom_sheet/loaded_info/loaded_info.dart';
import 'package:companion/src/feature/search/widget/route_info_bottom_sheet/loading_info/loading_container.dart';
import 'package:flutter/cupertino.dart' hide Route;
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_bloc/flutter_bloc.dart';

class RouteInfoBottomSheet extends StatelessWidget {
  const RouteInfoBottomSheet({
    required this.route,
    super.key,
  });

  final Route route;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30).copyWith(
        top: 20,
        // bottom: 93,
        // bottom: AuthScope.isAuthOf(context, listen: true) ? 93 : 70,
      ),
      child: BlocBuilder<RouteInfoBloc, RouteInfoState>(
        builder: (context, state) {
          return state.when(
            loading: LoadingInfo.new,
            error: (message) => ErrorInfo(message: message),
            loaded: (user) => LoadedInfo(user: user, route: route),
          );
        },
      ),
    );
  }
}
