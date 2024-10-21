import 'package:companion/gen/assets.gen.dart';
import 'package:companion/src/assets/assets.dart';
import 'package:companion/src/core/widget/dashed_line_painter.dart';
import 'package:companion/src/feature/search/model/route/route.dart';
import 'package:flutter/cupertino.dart' hide Route;
import 'package:flutter/material.dart' hide Route;

import 'package:map_launcher/map_launcher.dart';

class PlacesBlock extends StatefulWidget {
  const PlacesBlock({required this.route, super.key});

  final Route route;

  @override
  State<PlacesBlock> createState() => _PlacesBlockState();
}

class _PlacesBlockState extends State<PlacesBlock> {
  bool _isYandexMapsInstalled = false;
  bool _is2GISInstalled = false;
  bool _isGoogleMapsInstalled = false;
  bool _isAppleMapsInstalled = false;

  Future<void> _checkInstalledMaps() async {
    _isYandexMapsInstalled =
        await MapLauncher.isMapAvailable(MapType.yandexMaps) ?? false;
    _is2GISInstalled =
        await MapLauncher.isMapAvailable(MapType.doubleGis) ?? false;
    _isGoogleMapsInstalled =
        await MapLauncher.isMapAvailable(MapType.googleGo) ?? false;
    _isAppleMapsInstalled =
        await MapLauncher.isMapAvailable(MapType.apple) ?? false;
  }

  Future<void> _launchYandexMaps() async {
    await MapLauncher.showDirections(
      originTitle: widget.route.startPlace,
      destinationTitle: widget.route.endPlace,
      mapType: MapType.yandexMaps,
      destination: Coords(
        widget.route.latitudeB,
        widget.route.longitudeB,
      ),
      origin: Coords(
        widget.route.latitudeA,
        widget.route.longitudeA,
      ),
    );
    // final uri = Uri.parse(
    //   'yandexmaps://maps.yandex.ru/?rtext=${widget.route.latitudeA},${widget.route.longitudeA}~${widget.route.latitudeB},${widget.route.longitudeB}&rtt=auto',
    // );
    // if (await canLaunchUrl(uri)) {
    //   await launchUrl(uri);
    // }
  }

  Future<void> _launch2GIS() async {
    await MapLauncher.showDirections(
      originTitle: widget.route.startPlace,
      destinationTitle: widget.route.endPlace,
      mapType: MapType.doubleGis,
      destination: Coords(
        widget.route.latitudeB,
        widget.route.longitudeB,
      ),
      origin: Coords(
        widget.route.latitudeA,
        widget.route.longitudeA,
      ),
    );
  }

  Future<void> _launchGoogleMaps() async {
    await MapLauncher.showDirections(
      originTitle: widget.route.startPlace,
      destinationTitle: widget.route.endPlace,
      mapType: MapType.google,
      destination: Coords(
        widget.route.latitudeB,
        widget.route.longitudeB,
      ),
      origin: Coords(
        widget.route.latitudeA,
        widget.route.longitudeA,
      ),
    );
    // final uri = Uri.parse(
    //   'google.navigation:q=${widget.route.latitudeA},${widget.route.longitudeA},+${widget.route.latitudeB},${widget.route.longitudeB}',
    // );
    // if (await canLaunchUrl(uri)) {
    //   await launchUrl(uri);
    // }
  }

  Future<void> _launchAppleMaps() async {
    await MapLauncher.showDirections(
      originTitle: widget.route.startPlace,
      destinationTitle: widget.route.endPlace,
      mapType: MapType.apple,
      destination: Coords(
        widget.route.latitudeB,
        widget.route.longitudeB,
      ),
      origin: Coords(
        widget.route.latitudeA,
        widget.route.longitudeA,
      ),
    );
  }

  Future<void> _openMap({
    required BuildContext context,
  }) async {
    await _checkInstalledMaps();
    final listMaps = <CupertinoActionSheetAction>[
      if (_isYandexMapsInstalled)
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            _launchYandexMaps();
          },
          child: const Text('Yandex Maps'),
        ),
      if (_is2GISInstalled)
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            _launch2GIS();
          },
          child: const Text('2GIS'),
        ),
      if (_isGoogleMapsInstalled)
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            _launchGoogleMaps();
          },
          child: const Text('Google Maps'),
        ),
      if (_isAppleMapsInstalled)
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            _launchAppleMaps();
          },
          child: const Text('Apple Maps'),
        ),
    ];

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: listMaps.isEmpty
              ? [
                  CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Нет доступных карт'),
                  ),
                ]
              : listMaps,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = AppTypography.nunito14Medium.copyWith(
      color: AppColors.darkPurple.withOpacity(0.5),
    );

    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Assets.icons.icLocationPoint.svg(),
                    Expanded(
                      child: CustomPaint(
                        size: const Size(1, 27),
                        painter: DashedLinePainter(),
                      ),
                    ),
                    Assets.icons.icLocationPoint.svg(
                      colorFilter: const ColorFilter.mode(
                        Color.fromRGBO(255, 0, 4, 0.67),
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(widget.route.startPlace, style: style),
                      ),
                      Flexible(
                        child: Text(widget.route.endPlace, style: style),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () async {
              await _openMap(
                context: context,
              );
            },
            icon: const Icon(
              Icons.map_outlined,
            ),
            style: IconButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(24, 24),
            ),
          ),
        ],
      ),
    );
  }
}
