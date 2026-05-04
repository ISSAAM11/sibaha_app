import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sibaha_app/core/theme/app_border_radius.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';
import 'package:sibaha_app/core/theme/app_spacing.dart';
import 'package:sibaha_app/core/theme/app_text_styles.dart';

class AcademyMapSection extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String academyName;

  const AcademyMapSection({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.academyName,
  });

  @override
  Widget build(BuildContext context) {
    final location = LatLng(latitude, longitude);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: AppBorderRadius.mdRadius,
          child: SizedBox(
            height: 200,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: location,
                initialZoom: 15.0,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.shibaha.sibaha_app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: location,
                      width: 48,
                      height: 48,
                      child: const Icon(
                        Icons.location_pin,
                        color: AppColors.primary,
                        size: 48,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            const Icon(
              Icons.place_outlined,
              size: 16,
              color: AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                academyName,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
