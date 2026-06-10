import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/constants/text_font_style.dart';
import 'package:template_flutter/gen/colors.gen.dart';
import 'package:template_flutter/helpers/ui_helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardServicesSection extends StatefulWidget {
  const DashboardServicesSection({super.key});

  @override
  State<DashboardServicesSection> createState() =>
      _DashboardServicesSectionState();
}

class _DashboardServicesSectionState extends State<DashboardServicesSection> {
  final CollectionReference<Map<String, dynamic>> _servicesRef =
      FirebaseFirestore.instance.collection('services');

  final Map<String, bool> _activeCache = {};

  Future<void> _toggleActive(String docId, bool value) async {
    final bool previous = _activeCache[docId] ?? false;
    // Optimistically update UI
    setState(() {
      _activeCache[docId] = value;
    });

    try {
      await _servicesRef.doc(docId).update({'active': value});
    } catch (e) {
      // Revert on error and notify user
      setState(() {
        _activeCache[docId] = previous;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Could not update service status. Please try again.'),
      ));
    }
  }

  Future<void> _deleteService(String docId) async {
    await _servicesRef.doc(docId).delete();
    _activeCache.remove(docId);
  }

  Future<void> _showAddEditSheet(
      {String? docId, Map<String, dynamic>? data}) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: _ServiceForm(initialData: data),
        );
      },
    );

    if (result != null) {
      if (docId == null) {
        // Ensure the created service includes the contractorId of the signed-in user
        final String? uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid == null) return;
        result['contractorId'] = uid;
        await _servicesRef.add(result);
      } else {
        // Prevent clients from changing the contractorId during updates
        result.remove('contractorId');
        await _servicesRef.doc(docId).update(result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.contractor_primary,
        onPressed: () => _showAddEditSheet(),
        child: const Icon(Icons.add),
      ),
      body: Padding(
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
            UIHelper.verticalSpace(12.h),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _servicesRef.orderBy('title').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error loading services'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;

                  return ListView.separated(
                    itemCount: docs.length,
                    separatorBuilder: (_, __) => UIHelper.verticalSpace(10.h),
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = doc.data();
                      final String title = data['title'] ?? '';
                      final String category = data['category'] ?? 'Other';
                      final String zip = data['zip'] ?? '';
                      final String rate = data['rate'] ?? '';
                      final bool active = data['active'] ?? true;

                      _activeCache[doc.id] = _activeCache[doc.id] ?? active;

                      return Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 12.h, horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: AppColors.scaffoldColor,
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                              color: AppColors.contractor_primary
                                  .withValues(alpha: 0.6)),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20.r,
                              backgroundColor: AppColors.contractor_primary
                                  .withValues(alpha: 0.12),
                              child: Icon(Icons.build,
                                  color: AppColors.contractor_primary,
                                  size: 20.sp),
                            ),
                            UIHelper.horizontalSpace(12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(title,
                                      style: TextFontStyle
                                          .textStyle15c0A0A0AInter700),
                                  UIHelper.verticalSpace(6.h),
                                  Row(children: [
                                    _CategoryChip(label: category),
                                    UIHelper.horizontalSpace(8.w),
                                    Text(zip,
                                        style: TextStyle(
                                            color: AppColors.c6A7181)),
                                  ]),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(rate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 14.sp)),
                                    Icon(Icons.attach_money,
                                        color: AppColors.c000000, size: 18.sp),
                                  ],
                                ),
                                UIHelper.verticalSpace(8.h),
                                CupertinoSwitch(
                                  value: _activeCache[doc.id] ?? active,
                                  activeTrackColor:
                                      AppColors.contractor_primary,
                                  onChanged: (val) =>
                                      _toggleActive(doc.id, val),
                                ),
                              ],
                            ),
                            SizedBox(width: 6.w),
                            PopupMenuButton<String>(
                              icon: Icon(Icons.more_vert,
                                  color: AppColors.c6A7181),
                              onSelected: (value) async {
                                if (value == 'edit') {
                                  await _showAddEditSheet(
                                      docId: doc.id, data: data);
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
                                            child: const Text('Cancel')),
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.of(ctx).pop(true),
                                            child: const Text('Delete',
                                                style: TextStyle(
                                                    color: Colors.red))),
                                      ],
                                    ),
                                  );

                                  if (confirm == true) {
                                    await _deleteService(doc.id);
                                  }
                                }
                              },
                              itemBuilder: (ctx) => [
                                PopupMenuItem(
                                    value: 'edit',
                                    child: Row(children: [
                                      Icon(Icons.edit, size: 18),
                                      SizedBox(width: 8.w),
                                      Text('Edit')
                                    ])),
                                PopupMenuItem(
                                    value: 'delete',
                                    child: Row(children: [
                                      Icon(Icons.delete_outline,
                                          size: 18, color: Colors.redAccent),
                                      SizedBox(width: 8.w),
                                      Text('Delete',
                                          style: TextStyle(
                                              color: Colors.redAccent))
                                    ])),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceForm extends StatefulWidget {
  const _ServiceForm({this.initialData});
  final Map<String, dynamic>? initialData;

  @override
  State<_ServiceForm> createState() => _ServiceFormState();
}

class _ServiceFormState extends State<_ServiceForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _category = TextEditingController();
  final TextEditingController _zip = TextEditingController();
  final TextEditingController _rate = TextEditingController();
  bool _active = true;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _title.text = widget.initialData!['title'] ?? '';
      _category.text = widget.initialData!['category'] ?? '';
      _zip.text = widget.initialData!['zip'] ?? '';
      _rate.text = widget.initialData!['rate'] ?? '';
      _active = widget.initialData!['active'] ?? true;
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _category.dispose();
    _zip.dispose();
    _rate.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pop({
        'title': _title.text.trim(),
        'category': _category.text.trim(),
        'zip': _zip.text.trim(),
        'rate': _rate.text.trim(),
        'active': _active,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.initialData == null ? 'Add service' : 'Edit service',
              style: TextFontStyle.textStyle18c0A0A0AInter700),
          UIHelper.verticalSpace(12.h),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _title,
                  decoration: const InputDecoration(labelText: 'Service title'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                TextFormField(
                    controller: _category,
                    decoration: const InputDecoration(labelText: 'Category')),
                TextFormField(
                    controller: _zip,
                    decoration: const InputDecoration(labelText: 'ZIP Code')),
                TextFormField(
                    controller: _rate,
                    decoration: const InputDecoration(labelText: 'Rate')),
                UIHelper.verticalSpace(12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Active'),
                    CupertinoSwitch(
                        value: _active,
                        onChanged: (v) => setState(() => _active = v)),
                  ],
                ),
                UIHelper.verticalSpace(12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel')),
                    ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.contractor_primary),
                        child: const Text('Save')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
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
