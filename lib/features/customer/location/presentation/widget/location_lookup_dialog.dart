import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class LocationLookupDialog extends StatefulWidget {
  const LocationLookupDialog({required this.onConfirmZip});

  final ValueChanged<String> onConfirmZip;

  @override
  State<LocationLookupDialog> createState() => _LocationLookupDialogState();
}

class _LocationLookupDialogState extends State<LocationLookupDialog> {
  bool _isLoading = true;
  String? _address;
  String? _zipCode;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCurrentLocation();
    });
  }

  Future<void> _loadCurrentLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        if (!mounted) {
          return;
        }
        setState(() {
          _isLoading = false;
          _errorText = 'Location services are disabled.';
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) {
        if (!mounted) {
          return;
        }
        setState(() {
          _isLoading = false;
          _errorText = 'Unable to find an address for your location.';
        });
        return;
      }

      final placemark = placemarks.first;
      final zipCode = placemark.postalCode?.trim() ?? '';

      if (zipCode.isEmpty) {
        if (!mounted) {
          return;
        }
        setState(() {
          _isLoading = false;
          _errorText = 'Zip code is unavailable for this location.';
        });
        return;
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _address = _formatPlacemarkAddress(placemark);
        _zipCode = zipCode;
        _errorText = null;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _errorText = 'Unable to detect your current zip code.';
      });
    }
  }

  String _formatPlacemarkAddress(Placemark placemark) {
    final parts = <String?>[
      placemark.locality,
      placemark.administrativeArea,
      placemark.country,
    ]
        .where((part) => part != null && part.trim().isNotEmpty)
        .map((part) => part!.trim())
        .toList();

    return parts.isEmpty ? 'Current location' : parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final bool hasResult = !_isLoading && _errorText == null;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 22.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _errorText != null ? 'Location unavailable' : 'Find current location',
              style: TextFontStyle.textStyle18c14181FInter600,
              textAlign: TextAlign.center,
            ),
            UIHelper.verticalSpace(16.h),
            if (_isLoading) ...[
              const Center(child: CircularProgressIndicator()),
              UIHelper.verticalSpace(16.h),
              Text(
                'Detecting your current location...',
                style: TextFontStyle.textStyle12c6A7181Inter400,
                textAlign: TextAlign.center,
              ),
              UIHelper.verticalSpace(16.h),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ),
            ] else if (_errorText != null) ...[
              Icon(
                Icons.info_outline,
                size: 36.sp,
                color: AppColors.c14181F,
              ),
              UIHelper.verticalSpace(12.h),
              Text(
                _errorText!,
                style: TextFontStyle.textStyle12c6A7181Inter400,
                textAlign: TextAlign.center,
              ),
              UIHelper.verticalSpace(12.h),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ),
            ] else if (hasResult) ...[
              Icon(
                Icons.location_on_outlined,
                size: 36.sp,
                color: AppColors.allPrimaryColor,
              ),
              UIHelper.verticalSpace(12.h),
              Text(
                _address ?? 'Current location',
                style: TextFontStyle.textStyle14c14181FInter600,
                textAlign: TextAlign.center,
              ),
              UIHelper.verticalSpace(8.h),
              Text(
                'Zip code: ${_zipCode ?? ''}',
                style: TextFontStyle.textStyle12c6A7181Inter400,
                textAlign: TextAlign.center,
              ),
              UIHelper.verticalSpace(20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      final zipCode = _zipCode?.trim() ?? '';
                      if (zipCode.isNotEmpty) {
                        widget.onConfirmZip(zipCode);
                      }
                      Navigator.of(context).pop();
                    },
                    child: const Text('Confirm'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
