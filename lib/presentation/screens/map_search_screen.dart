import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:sibaha_app/core/theme/app_border_radius.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';
import 'package:sibaha_app/core/theme/app_spacing.dart';
import 'package:sibaha_app/core/theme/app_text_styles.dart';
import 'package:sibaha_app/data/models/academy.dart';
import 'package:sibaha_app/presentation/blocs/academy_bloc/academy_bloc.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';

class MapSearchScreen extends StatefulWidget {
  const MapSearchScreen({super.key});

  @override
  State<MapSearchScreen> createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {
  static const _tunisiaCenter = LatLng(33.8869, 9.5375);

  final MapController _mapController = MapController();
  LatLng? _userPosition;
  bool _locating = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final academyBloc = context.read<AcademyBloc>();
    if (academyBloc.state is AcademyInitial) {
      final tokenState = context.read<TokenBloc>().state;
      final token = tokenState is TokenRetrieved ? tokenState.token : null;
      academyBloc.add(FetchAcademies(token));
    }
  }

  Future<void> _locateMe() async {
    setState(() => _locating = true);
    try {
      final loc = await _acquireLocation();
      if (loc != null && mounted) {
        setState(() => _userPosition = loc);
        _mapController.move(loc, 13);
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

  void _showAcademySheet(Academy academy) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _AcademyMarkerSheet(academy: academy),
    );
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
          'Explore Academies',
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
      body: BlocBuilder<AcademyBloc, AcademyState>(
        builder: (context, state) {
          final academies = state is AcademyLoaded
              ? state.academies
                  .where((a) => a.latitude != null && a.longitude != null)
                  .toList()
              : <Academy>[];

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: const MapOptions(
                  initialCenter: _tunisiaCenter,
                  initialZoom: 6.0,
                  interactionOptions: InteractionOptions(
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
                      // Academy markers
                      ...academies.map(
                        (academy) => Marker(
                          point: LatLng(academy.latitude!, academy.longitude!),
                          width: 48,
                          height: 48,
                          child: GestureDetector(
                            onTap: () => _showAcademySheet(academy),
                            child: const Icon(
                              Icons.pool,
                              color: AppColors.primary,
                              size: 36,
                            ),
                          ),
                        ),
                      ),
                      // User position marker
                      if (_userPosition != null)
                        Marker(
                          point: _userPosition!,
                          width: 24,
                          height: 24,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.4),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),

              // Loading overlay
              if (state is AcademyLoading)
                const Positioned(
                  top: AppSpacing.lg,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.sm,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: AppSpacing.sm),
                            Text('Loading academies…'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              // Academy count badge
              if (academies.isNotEmpty)
                Positioned(
                  top: AppSpacing.lg,
                  left: AppSpacing.lg,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppBorderRadius.pill),
                    ),
                    child: Text(
                      '${academies.length} academies',
                      style: AppTextStyles.caption.copyWith(color: Colors.white),
                    ),
                  ),
                ),

              // Locate me FAB
              Positioned(
                bottom: AppSpacing.xxl,
                right: AppSpacing.lg,
                child: FloatingActionButton(
                  heroTag: 'locateMe',
                  onPressed: _locating ? null : _locateMe,
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  elevation: 4,
                  child: _locating
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.my_location),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AcademyMarkerSheet extends StatelessWidget {
  final Academy academy;

  const _AcademyMarkerSheet({required this.academy});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppBorderRadius.lgRadius,
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: AppSpacing.sm),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(AppBorderRadius.pill),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Image thumbnail + info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  child: SizedBox(
                    width: 72,
                    height: 72,
                    child: academy.image != null && academy.image!.isNotEmpty
                        ? Image.network(
                            academy.image!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _imagePlaceholder(),
                          )
                        : _imagePlaceholder(),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        academy.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.onSurface,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 14, color: AppColors.onSurfaceVariant),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Text(
                              academy.city,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (academy.averageRating != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                size: 14, color: AppColors.secondaryFixedDim),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              academy.averageRating!.toStringAsFixed(1),
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              ' (${academy.reviewCount})',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.push('/AcademyDetails/${academy.id}');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppBorderRadius.pillRadius,
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'View Details',
                  style: AppTextStyles.buttonLabel.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: AppColors.surfaceContainerLow,
      child: const Center(
        child: Icon(Icons.pool, size: 28, color: AppColors.outlineVariant),
      ),
    );
  }
}
