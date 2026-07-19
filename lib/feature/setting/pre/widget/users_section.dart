// lib/feature/settings/presentation/widgets/users_section.dart

import 'package:flutter/material.dart';

// ====== Core ======
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

// ====== Settings ======
import 'settings_section.dart';
import 'settings_card.dart';
import 'settings_action_button.dart';
import 'users_table.dart';
import 'add_user_dialog.dart';
import 'permissions_dialog.dart';

class UsersSection extends StatelessWidget {
  const UsersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'المستخدمون والصلاحيات',
      icon: Iconss.users,
      child: SettingsCard(
        children: [
          // ====== Add User Button ======
          SettingsActionButton(
            label: 'إضافة مستخدم',
            icon: Iconss.personAdd,
            color: Colorsmanegments.primary,
            isFullWidth: true,
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => const AddUserDialog(),
              );
            },
          ),

          const SizedBox(height: 20),

          // ====== Users Table ======
          const UsersTable(),
        ],
      ),
    );
  }
}