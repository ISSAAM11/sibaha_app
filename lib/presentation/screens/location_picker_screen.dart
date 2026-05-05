import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:sibaha_app/core/theme/app_border_radius.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';
import 'package:sibaha_app/core/theme/app_spacing.dart';
import 'package:sibaha_app/core/theme/app_text_styles.dart';

class LocationPickerScreen extends StatefulWidget {
  final LatLng? initialLocation;

  const LocationPickerScreen({super.key, this.initialLocation});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  static const _tunisiaCenter = LatLng(33.8869, 9.5375);

  final MapController _mapController = MapController();
  LatLng? _selected;
  bool _locating = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialLocation;
  }

  Future<void> _useMyLocation() async {
    setState(() => _locating = true);
    try {
      final loc = await _acquireLocation();
      if (loc != null && mounted) {
        setState(() => _selected = loc);
        _mapController.move(loc, 14);
      }
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<LatLng?> _acquireLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnack('Location services are disabled.');
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnack('Location permission denied.');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnack('Location permission is permanently denied. Enable it in settings.');
      return null;
    }

    final pos = await Geolocator.getCurrentPosition();
    return LatLng(pos.latitude, pos.longitude);
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            margin: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: AppBorderRadius.smRadius,
            ),
            child: const Icon(Icons.arrow_back, color: AppColors.onSurface, size: 20),
          ),
        ),
        title: Text(
          'Select Location',
          style: AppTextStyles.subtitle.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: AppColors.outlineVariant.withOpacity(0.4),
          ),
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: widget.initialLocation ?? _tunisiaCenter,
              initialZoom: widget.initialLocation != null ? 13.0 : 6.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              ),
              onTap: (_, point) => setState(() => _selected = point),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.shibaha.sibaha_app',
              ),
              if (_selected != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selected!,
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

          // "Use my location" FAB
          Positioned(
            top: AppSpacing.lg,
            right: AppSpacing.lg,
            child: FloatingActionButton.small(
              heroTag: 'locateMe',
              onPressed: _locating ? null : _useMyLocation,
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              elevation: 4,
              child: _locating
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location, size: 20),
            ),
          ),

          // Tap hint
          if (_selected == null)
            Positioned(
              top: AppSpacing.lg,
              left: AppSpacing.lg,
              right: 56,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.onSurface.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
                child: Text(
                  'Tap on the map to place a pin',
                  style: AppTextStyles.caption.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          // Bottom confirm bar
          if (_selected != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.lg,
                  AppSpacing.xl,
                  AppSpacing.xl,
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_pin,
                              size: 16, color: AppColors.primary),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            'Lat: ${_selected!.latitude.toStringAsFixed(5)}   '
                            'Lng: ${_selected!.longitude.toStringAsFixed(5)}',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => context.pop(_selected),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppBorderRadius.pillRadius,
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Confirm Location',
                            style: AppTextStyles.buttonLabel
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
