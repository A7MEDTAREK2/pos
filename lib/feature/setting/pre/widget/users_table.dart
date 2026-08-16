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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        final List<UserModel> users = context.read<UserCubit>().users;

        if (state is UserLoading && users.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (users.isEmpty) {
          return Center(
            child: Text(
              "لا يوجد مستخدمين",
              style: theme.textTheme.bodyMedium,
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: colorScheme.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 16,
              headingRowColor: WidgetStateProperty.all(
                colorScheme.background,
              ),
              headingTextStyle: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              dataTextStyle: theme.textTheme.bodyMedium,
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
                              ? colorScheme.primary.withOpacity(.15)
                              : theme.textTheme.bodyMedium?.color?.withOpacity(.15),
                        ),
                        child: Center(
                          child: Text(
                            user.name.isNotEmpty
                                ? user.name.substring(0, 1)
                                : "?",
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: isActive
                                  ? colorScheme.primary
                                  : theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// Name
                    DataCell(
                      Text(
                        user.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    /// Username
                    DataCell(
                      Text(
                        user.username,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),

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
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: _getRoleColor(user.role),
                            fontWeight: FontWeight.bold,
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
                              ? Colors.green.withOpacity(.1)
                              : Colors.red.withOpacity(.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isActive ? Iconss.success : Iconss.error,
                              size: 12,
                              color: isActive ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isActive ? "Active" : "Inactive",
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: isActive ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
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
                          /// Edit Button
                          _actionButton(
                            context,
                            icon: Iconss.edit,
                            color: colorScheme.primary,
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

                          /// Permissions Button
                          _actionButton(
                            context,
                            icon: Iconss.lock,
                            color: Colors.amber,
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

                          /// Delete Button
                          _actionButton(
                            context,
                            icon: Iconss.delete,
                            color: isAdmin ? Colors.grey : Colors.red,
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
        return Colors.red;
      case 'Manager':
        return Colors.amber;
      case 'Cashier':
        return const Color(0xFF2563EB);
      default:
        return Colors.grey;
    }
  }

  Widget _actionButton(
      BuildContext context, {
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Iconss.delete,
              color: Colors.red,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              'تأكيد الحذف',
              style: theme.textTheme.titleLarge,
            ),
          ],
        ),
        content: Text(
          'هل أنت متأكد من حذف المستخدم "${user.name}"؟',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              if (user.id != null) {
                cubit.deleteUser(user.id!);
              }
            },
            child: Text(
              'حذف',
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}