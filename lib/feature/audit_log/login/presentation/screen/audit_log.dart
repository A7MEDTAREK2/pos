import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/audit_log_cubit.dart'; // تأكد من مطابقة مسار الـ Cubit لديك

class AuditLogScreen extends StatefulWidget {
  const AuditLogScreen({super.key});

  @override
  State<AuditLogScreen> createState() => _AuditLogScreenState();
}

class _AuditLogScreenState extends State<AuditLogScreen> {
  @override
  void initState() {
    super.initState();
    // جلب السجلات بمجرد فتح الشاشة
    context.read<AuditLogCubit>().fetchAuditLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل الحركات والعمليات (Audit Logs)'),
        centerTitle: true,
      ),
      body: BlocBuilder<AuditLogCubit, AuditLogState>(
        builder: (context, state) {
          if (state is AuditLogLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AuditLogLoaded) {
            if (state.logs.isEmpty) {
              return const Center(
                child: Text(
                  'لا توجد سجلات متاحة حالياً',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }
            return ListView.builder(
              itemCount: state.logs.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final log = state.logs[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Chip(
                              label: Text(
                                log.action,
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: _getActionColor(log.action),
                            ),
                            Text(
                              log.userName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 16),
                        Text(
                          'القسم: ${log.module} | الكيان: ${log.entityType}',
                          style: const TextStyle(color: Colors.black87),
                        ),
                        if (log.description != null && log.description!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            'التفاصيل: ${log.description}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            log.createdAt.toString().substring(0, 19),
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is AuditLogDeteleOrError) {
            return Center(
              child: Text(
                'خطأ: ${state.message}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  // دالة لتلوين الـ Chip حسب نوع الحركة (إضافة، تعديل، حذف)
  Color _getActionColor(String action) {
    switch (action.toLowerCase()) {
      case 'create':
      case 'add':
        return Colors.green;
      case 'update':
      case 'edit':
        return Colors.orange;
      case 'delete':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}