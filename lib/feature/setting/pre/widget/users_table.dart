import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

// ====== Settings ======
import '../../data/model/users_model.dart';
import '../../logic/user_cubit.dart';
import '../../logic/user_state.dart';
import 'edit_user.dart';
import 'permissions_dialog.dart';

class UsersTable extends StatelessWidget {
  const UsersTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        final List<UserModel> users = context.read<UserCubit>().users;

        if (state is UserLoading && users.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (users.isEmpty) {
          return const Center(child: Text("لا يوجد مستخدمين"));
        }

        return Container(
          decoration: BoxDecoration(
            color: Colorsmanegments.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colorsmanegments.border),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 16,
              headingRowColor: WidgetStateProperty.all(
                Colorsmanegments.background,
              ),
              headingTextStyle: TxtStyle.tableHeader,
              dataTextStyle: TxtStyle.tableRow,
              columns: const [
                DataColumn(label: Text("")),
                DataColumn(label: Text("الاسم")),
                DataColumn(label: Text("اسم المستخدم")),
                DataColumn(label: Text("الدور")),
                DataColumn(label: Text("الحالة")),
                DataColumn(label: Text("آخر تسجيل")),
                DataColumn(label: Text("العمليات")),
              ],
              rows: users.map((user) {
                final isActive = user.isActive;
                final isAdmin = user.username.toLowerCase() == 'admin';

                return DataRow(
                  cells: [
                    /// Avatar
                    DataCell(
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive
                              ? Colorsmanegments.primary.withOpacity(.15)
                              : Colorsmanegments.textSecondary.withOpacity(.15),
                        ),
                        child: Center(
                          child: Text(
                            user.name.isNotEmpty
                                ? user.name.substring(0, 1)
                                : "?",
                            style: TxtStyle.badge.copyWith(
                              color: isActive
                                  ? Colorsmanegments.primary
                                  : Colorsmanegments.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// Name
                    DataCell(Text(user.name, style: TxtStyle.tableRowBold)),

                    /// Username
                    DataCell(Text(user.username)),

                    /// Role
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getRoleColor(user.role).withOpacity(.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: _getRoleColor(user.role).withOpacity(.2),
                          ),
                        ),
                        child: Text(
                          user.role ?? 'cashier',
                          style: TxtStyle.badgeSmall.copyWith(
                            color: _getRoleColor(user.role),
                          ),
                        ),
                      ),
                    ),

                    /// Status
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? Colorsmanegments.success.withOpacity(.1)
                              : Colorsmanegments.danger.withOpacity(.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isActive ? Iconss.success : Iconss.error,
                              size: 12,
                              color: isActive
                                  ? Colorsmanegments.success
                                  : Colorsmanegments.danger,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isActive ? "Active" : "Inactive",
                              style: TxtStyle.badgeSmall.copyWith(
                                color: isActive
                                    ? Colorsmanegments.success
                                    : Colorsmanegments.danger,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// Last Login
                    const DataCell(Text("-")),

                    /// Actions
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// Edit Button - (8) تعديل المستخدم
                          _actionButton(
                            icon: Iconss.edit,
                            color: Colorsmanegments.primary,
                            tooltip: "تعديل",
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => EditUserDialog(
                                  user: user,
                                ),
                              );
                            },
                          ),

                          /// Permissions Button - (6) صلاحيات المستخدم
                          _actionButton(
                            icon: Iconss.lock,
                            color: Colorsmanegments.warning,
                            tooltip: "الصلاحيات",
                            onTap: user.id == 1
                                ? null
                                : () {
                              showDialog(
                                context: context,
                                builder: (_) => PermissionsDialog(
                                  user: user,
                                ),
                              );
                            },
                          ),

                          /// Delete Button - (9) منع حذف الأدمن
                          _actionButton(
                            icon: Iconss.delete,
                            color: isAdmin ? Colors.grey : Colorsmanegments.danger,
                            tooltip: isAdmin
                                ? "لا يمكن حذف المستخدم الأساسي"
                                : "حذف",
                            onTap: isAdmin
                                ? null
                                : () {
                              _showDeleteConfirmation(
                                context,
                                user,
                                context.read<UserCubit>(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Color _getRoleColor(String? role) {
    switch (role) {
      case 'Admin':
        return Colorsmanegments.danger;
      case 'Manager':
        return Colorsmanegments.warning;
      case 'Cashier':
        return Colorsmanegments.primary;
      default:
        return Colorsmanegments.grey;
    }
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    VoidCallback? onTap,
  }) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
      icon: Icon(icon, size: 18, color: color),
      tooltip: tooltip,
      onPressed: onTap,
    );
  }

  void _showDeleteConfirmation(
      BuildContext context,
      UserModel user,
      UserCubit cubit,
      ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Iconss.delete,
              color: Colorsmanegments.danger,
              size: 28,
            ),
            const SizedBox(width: 12),
            const Text('تأكيد الحذف'),
          ],
        ),
        content: Text(
          'هل أنت متأكد من حذف المستخدم "${user.name}"؟',
          style: TxtStyle.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TxtStyle.buttonPrimary,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colorsmanegments.danger,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              if (user.id != null) {
                cubit.deleteUser(user.id!);
                _showSnackBar(context, 'تم حذف المستخدم بنجاح', Colors.green);
              }
            },
            child: Text(
              'حذف',
              style: TxtStyle.buttonMedium.copyWith(
                color: Colorsmanegments.textWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}