import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

const kOsmTileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

// There's no free, no-signup dark tile server (CartoDB's free basemaps now
// require an API key), so instead we invert the standard OSM tiles'
// colors client-side to get a dark map without any external dependency.
const _kInvertColors = ColorFilter.matrix(<double>[
  -1, 0, 0, 0, 255,
  0, -1, 0, 0, 255,
  0, 0, -1, 0, 255,
  0, 0, 0, 1, 0,
]);

Widget buildDarkTileLayer() => ColorFiltered(
      colorFilter: _kInvertColors,
      child: TileLayer(
        urlTemplate: kOsmTileUrl,
        userAgentPackageName: 'com.patrickcaloriocarvalho.strideclash',
      ),
    );

Widget buildMapAttribution() => const RichAttributionWidget(
      attributions: [
        TextSourceAttribution('OpenStreetMap contributors'),
      ],
    );
