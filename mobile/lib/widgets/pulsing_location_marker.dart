import 'package:flutter/material.dart';

import '../theme.dart';

/// "Você está aqui" no estilo neon do app — um ponto verde com um anel que
/// pulsa, em vez do pino vermelho genérico de mapa (que lembraria mais
/// Google Maps do que o visual dark/gamer do resto do app).
class PulsingLocationMarker extends StatefulWidget {
  const PulsingLocationMarker({super.key});

  @override
  State<PulsingLocationMarker> createState() => _PulsingLocationMarkerState();
}

class _PulsingLocationMarkerState extends State<PulsingLocationMarker>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        return Stack(
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: 0.4 + t * 0.6,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: kNeonGreen.withValues(alpha: 1 - t),
                    width: 2,
                  ),
                ),
              ),
            ),
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kNeonGreen,
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: kNeonGreen.withValues(alpha: 0.7),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
