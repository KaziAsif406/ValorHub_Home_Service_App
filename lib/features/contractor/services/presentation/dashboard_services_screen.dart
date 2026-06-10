import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';

class DashboardServicesSection extends StatefulWidget {
  const DashboardServicesSection({super.key});

  @override
  State<DashboardServicesSection> createState() =>
      _DashboardServicesSectionState();
}

class _DashboardServicesSectionState extends State<DashboardServicesSection> {
  final List<_ServiceData> services = <_ServiceData>[
    _ServiceData(
      'Bathroom Remodeling',
      'Hourly pricing',
      Icons.bathtub_outlined,
      zip: '10001',
      rate: '\$80/hr',
      active: true,
      category: 'Interior',
    ),
    _ServiceData(
      'Kitchen Plumbing',
      'Hourly pricing',
      Icons.kitchen_outlined,
      zip: '11215',
      rate: '\$95/hr',
      active: true,
      category: 'Exterior',
    ),
    _ServiceData(
      'Deck Construction',
      'Hourly pricing',
      Icons.construction_outlined,
      zip: '07302',
      rate: '\$70/hr',
      active: true,
      category: 'Lawn & Garden',
    ),
    _ServiceData(
      'Interior Painting',
      'Hourly pricing',
      Icons.format_paint_outlined,
      zip: '07030',
      rate: '\$55/hr',
      active: true,
      category: 'Other',
    ),
    _ServiceData(
      'Tile Installation',
      'Hourly pricing',
      Icons.grid_on_outlined,
      zip: '11375',
      rate: '\$65/hr',
      active: true,
      category: 'Interior',
    ),
  ];

  final Map<int, bool> _active = {};

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < services.length; i++) {
      _active[i] = services[i].active;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My services',
            style: TextFontStyle.textStyle20c0A0A0AInter700.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          UIHelper.verticalSpace(6.h),
          Text(
            'Manage the services your customers request most often.',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.c6A7181,
            ),
          ),
          UIHelper.verticalSpace(12.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,
            separatorBuilder: (_, __) => UIHelper.verticalSpace(10.h),
            itemBuilder: (context, index) {
              final s = services[index];

              return Container(
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldColor,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                      color:
                          AppColors.contractor_primary.withValues(alpha: 0.8)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 20.r,
                          backgroundColor: AppColors.contractor_primary
                              .withValues(alpha: 0.12),
                          child: Icon(s.icon,
                              color: AppColors.contractor_primary, size: 20.sp),
                        ),
                        UIHelper.horizontalSpace(12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(s.title,
                                  style:
                                      TextFontStyle.textStyle15c0A0A0AInter700),
                              UIHelper.verticalSpace(6.h),
                              Row(
                                children: [
                                  _CategoryChip(label: s.category),
                                  UIHelper.horizontalSpace(8.w),
                                  Text(s.zip,
                                      style:
                                          TextStyle(color: AppColors.c6A7181)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(s.rate,
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14.sp)),
                            UIHelper.verticalSpace(8.h),
                            CupertinoSwitch(
                              value: _active[index] ?? false,
                              activeColor: AppColors.contractor_primary,
                              onChanged: (val) {
                                setState(() {
                                  _active[index] = val;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(width: 6.w),
                        PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert, color: AppColors.c6A7181),
                          onSelected: (value) async {
                            if (value == 'edit') {
                              showModalBottomSheet(
                                context: context,
                                builder: (_) => Container(
                                  padding: EdgeInsets.all(16.w),
                                  child: Text(
                                      'Edit service - implement form here'),
                                ),
                              );
                            } else if (value == 'delete') {
                              final bool? confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Delete service'),
                                  content: const Text(
                                      'Are you sure you want to delete this service?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(true),
                                      child: const Text('Delete',
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                final List<bool> actives = List<bool>.generate(
                                  services.length,
                                  (i) => _active[i] ?? services[i].active,
                                );
                                setState(() {
                                  actives.removeAt(index);
                                  services.removeAt(index);
                                  _active.clear();
                                  for (var i = 0; i < actives.length; i++) {
                                    _active[i] = actives[i];
                                  }
                                });
                              }
                            }
                          },
                          itemBuilder: (ctx) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, size: 18),
                                  SizedBox(width: 8.w),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete_outline,
                                      size: 18, color: Colors.redAccent),
                                  SizedBox(width: 8.w),
                                  Text('Delete',
                                      style:
                                          TextStyle(color: Colors.redAccent)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    UIHelper.verticalSpace(6.h),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ServiceData {
  _ServiceData(this.title, this.subtitle, this.icon,
      {this.zip = '',
      this.rate = '',
      this.active = true,
      this.category = 'Other'});

  final String title;
  final String subtitle;
  final IconData icon;
  final String zip;
  final String rate;
  final bool active;
  final String category;
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: AppColors.cF3F4F6,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12.sp, color: AppColors.c6A7181),
      ),
    );
  }
}
