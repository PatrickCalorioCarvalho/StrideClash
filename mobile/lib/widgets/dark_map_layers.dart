import 'package:cached_network_image/cached_network_image.dart';
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

// Caches tiles to disk (via cached_network_image's default cache manager) as
// they're viewed, so a route walked once with a signal still renders when
// reopened offline later — nothing needs pre-downloading ahead of time,
// tiles just accumulate in the cache as you go.
class _CachedTileProvider extends TileProvider {
  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) =>
      CachedNetworkImageProvider(
        getTileUrl(coordinates, options),
        // Sem isso, o pedido sai sem o header 'User-Agent' que o TileLayer
        // preenche aqui (via userAgentPackageName) — o OpenStreetMap
        // bloqueia com 403 requisições sem User-Agent identificável.
        headers: headers,
      );
}

Widget buildDarkTileLayer() => ColorFiltered(
      colorFilter: _kInvertColors,
      child: TileLayer(
        urlTemplate: kOsmTileUrl,
        userAgentPackageName: 'com.patrickcaloriocarvalho.strideclash',
        tileProvider: _CachedTileProvider(),
      ),
    );

Widget buildMapAttribution() => const RichAttributionWidget(
      attributions: [
        TextSourceAttribution('OpenStreetMap contributors'),
      ],
    );
