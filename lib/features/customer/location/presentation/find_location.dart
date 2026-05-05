import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/common_widgets/custom_button.dart';
import 'package:template_flutter/common_widgets/custom_textform_field.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/all_routes.dart';
import 'package:template_flutter/helpers/navigation_service.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';



class FindLocationScreen extends StatefulWidget {
  const FindLocationScreen({super.key, this.categoryName});

  final String? categoryName;

  String get headingText {
    final category = categoryName?.trim();
    if (category == null || category.isEmpty) {
      return 'Compare quotes from top-rated Addition & Remodeling Contractors';
    }

    return 'Compare quotes from top-rated ${_resolveCategoryTitle(category)} Contractors.';
  }

  static String _resolveCategoryTitle(String category) {
    switch (category.toLowerCase()) {
      case 'plumbing':
        return 'Plumbing';
      case 'hvac':
        return 'HVAC';
      case 'roofing':
        return 'Roofing';
      case 'electrical':
        return 'Electrical';
      case 'cleaning':
        return 'Cleaning';
      default:
        return category;
    }
  }

  @override
  State<FindLocationScreen> createState() => _FindLocationScreenState();
}



class _FindLocationScreenState extends State<FindLocationScreen> {
  final TextEditingController _zipCodeController = TextEditingController();

  Future<bool> _ensureLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      _showZipMessage('Location permission was denied.');
      return false;
    }

    if (permission == LocationPermission.deniedForever) {
      _showZipMessage('Location permission is permanently denied.');
      return false;
    }

    return true;
  }

  Future<void> _handleLocatorTap() async {
    try {
      final hasPermission = await _ensureLocationPermission();
      if (!hasPermission) {
        return;
      }

      if (!mounted) {
        return;
      }

      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return _LocationLookupDialog(
            onConfirmZip: (zipCode) {
              setState(() {
                _zipCodeController.text = zipCode;
                _zipCodeController.selection = TextSelection.collapsed(
                  offset: zipCode.length,
                );
              });
            },
          );
        },
      );
    } catch (_) {
      _showZipMessage('Unable to detect your current zip code.');
    }
  }

  String _formatPlacemarkAddress(Placemark placemark) {
    final parts = <String?>[
      placemark.street,
      placemark.locality,
      placemark.administrativeArea,
      placemark.country,
    ]
        .where((part) => part != null && part.trim().isNotEmpty)
        .map((part) => part!.trim())
        .toList();

    return parts.isEmpty ? 'Current location' : parts.join(', ');
  }

  void _showZipMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  

  @override
  void dispose() {
    _zipCodeController.dispose();
    super.dispose();
  }

  void _handleFindContractor() {
    NavigationService.navigateToWithArgs(
      Routes.locationSurveyScreen,
      {
        'category': widget.categoryName ?? '',
        'zipCode': _zipCodeController.text.trim(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, color: AppColors.c14181F),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 20.h, right: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.headingText,
                    style: TextFontStyle.textStyle18c14181FInter600,
                    textAlign: TextAlign.center,
                  ),
                  UIHelper.verticalSpace(16.h),
                  Text(
                    'Enter the location of your project',
                    style: TextFontStyle.textStyle12c6A7181Inter400,
                  ),
                  UIHelper.verticalSpace(24.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.c6A7181.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: CustomTextFormField(
                                height: 42.h,
                                hintText: 'Zip code',
                                controller: _zipCodeController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            UIHelper.horizontalSpace(12.w),
                            GestureDetector(
                              onTap: _handleLocatorTap,
                              child: Container(
                                width: 43.w,
                                height: 42.h,
                                decoration: BoxDecoration(
                                  color: AppColors.scaffoldColor,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/icons/locator.png',
                                    width: 20.w,
                                    height: 20.h,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        UIHelper.verticalSpace(8.h),
                        CustomButton(
                          width: double.infinity,
                          label: 'Find Contractor',
                          onPressed: _handleFindContractor,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LocationLookupDialog extends StatefulWidget {
  const _LocationLookupDialog({required this.onConfirmZip});

  final ValueChanged<String> onConfirmZip;

  @override
  State<_LocationLookupDialog> createState() => _LocationLookupDialogState();
}

class _LocationLookupDialogState extends State<_LocationLookupDialog> {
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
      // placemark.street,
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