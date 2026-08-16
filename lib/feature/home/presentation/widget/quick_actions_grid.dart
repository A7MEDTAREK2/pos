// lib/feature/home/presentation/widget/quick_actions_grid.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ====== Core ======
import '../../../../core/service/printing/service/shift_closing_service.dart';
import '../../../../core/service/printing/service/modu_print_service.dart';
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';
import '../../../../core/data_base/pos_database.dart';

// ====== Cashier ======
import '../../../cashier/data/data_source/local_data_source.dart';
import '../../../cashier/data/repo/local_rapo.dart';
import '../../../cashier/logic/pos_cubit.dart';
import '../../../cashier/presentation/screen/cahier_screen.dart';

// ====== Category ======
import '../../../category/data/data_source/local_data_source.dart';
import '../../../category/data/repo/local_rapo.dart';
import '../../../category/logic/category_cubit.dart';
import '../../../category/presentation/screen/categories_screen.dart';

// ====== Customer ======
import '../../../cutomer/data/data_source/local_data_source.dart';
import '../../../cutomer/data/repo/local_rapo.dart';
import '../../../cutomer/logic/customer_cubit.dart';
import '../../../cutomer/presentation/screen/customer_screen.dart';

// ====== Dashboard ======
import '../../../dashbord/data/data_source/local_data_source.dart';
import '../../../dashbord/data/repo/local_rapo.dart';
import '../../../dashbord/logic/dash_cubit.dart';
import '../../../dashbord/presentation/screen/dashbord_screen.dart';

// ====== Product ======
import '../../../product/logic/product_cubit.dart';
import '../../../product/presentation/screen/product_screen.dart';

// ====== Sales ======
import '../../../sale/data/data_source/sales_history_local_data_source_impl.dart';
import '../../../sale/data/repo/local_rapo.dart';
import '../../../sale/logic/sale_cubit.dart';
import '../../../sale/presentation/screen/sale_screen.dart';
import '../../../setting/data/datasorce/local_data.dart';
import '../../../setting/data/model/users_model.dart';
import '../../../setting/data/repo/repo.dart';
import '../../../setting/logic/set_cubit.dart';
import '../../../setting/pre/screen/settings_screen.dart';

class QuickActionsGrid extends StatelessWidget {
  final UserModel user;

  const QuickActionsGrid({
    super.key,
    required this.user,
  });

  // ============================================================
  // WORKFLOW 1: End Shift Workflow
  // ============================================================
  Future<bool> _handleEndShiftWorkflow(BuildContext context) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: colorScheme.surface,
            title: Text(
              "إنهاء الشيفت",
              style: theme.textTheme.titleLarge,
            ),
            content: Text(
              "سيتم تنفيذ العمليات التالية:\n\n"
                  "• طباعة تقرير نهاية الشيفت\n"
                  "• إعادة تعيين عداد الفواتير\n"
                  "• بدء شيفت جديد",
              style: theme.textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(
                  "إلغاء",
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text(
                  "إنهاء الشيفت",
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (confirm != true) return false;

    if (!context.mounted) return false;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: colorScheme.surface,
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Text(
                "جاري إنهاء الشيفت وطباعة التقرير...",
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );

    try {
      await ShiftClosingService().printShiftReport();
      await ShiftClosingService().resetShift();

      if (context.mounted) {
        try {
          await context.read<OrderCubit>().refreshNextOrderNumber();
        } catch (_) {}
      }

      if (context.mounted) {
        Navigator.pop(context);
      }

      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (_) => Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              backgroundColor: colorScheme.surface,
              title: Text(
                "تم بنجاح",
                style: theme.textTheme.titleLarge,
              ),
              content: Text(
                "تم إنهاء الشيفت وبدء شيفت جديد.",
                style: theme.textTheme.bodyMedium,
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "موافق",
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return true;
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);

        await showDialog(
          context: context,
          builder: (_) => Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              backgroundColor: colorScheme.surface,
              title: Text(
                "خطأ في إنهاء الشيفت",
                style: theme.textTheme.titleLarge,
              ),
              content: Text(
                "فشلت عملية طباعة تقرير الشيفت. لم يتم إنهاء الشيفت أو إعادة تعيين العداد.\n\nالتفاصيل: $e",
                style: theme.textTheme.bodyMedium,
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "حسناً",
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return false;
    }
  }

  // ============================================================
  // WORKFLOW 2: Exit Application Workflow
  // ============================================================
  Future<void> _handleExitAppWorkflow(BuildContext context) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final action = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: colorScheme.surface,
            title: Text(
              "إغلاق البرنامج",
              style: theme.textTheme.titleLarge,
            ),
            content: Text(
              "هل تريد إنهاء الشيفت قبل إغلاق البرنامج؟",
              style: theme.textTheme.bodyMedium,
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, "cancel"),
                child: Text(
                  "إلغاء",
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: () => Navigator.pop(dialogContext, "exit_only"),
                child: Text(
                  "إغلاق فقط",
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
                onPressed: () => Navigator.pop(dialogContext, "end_and_exit"),
                child: Text(
                  "إنهاء الشيفت ثم إغلاق",
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (action == "exit_only") {
      await _closeDatabaseAndExit();
    } else if (action == "end_and_exit") {
      if (context.mounted) {
        final success = await _handleEndShiftWorkflow(context);
        if (success) {
          await _closeDatabaseAndExit();
        }
      }
    }
  }

  Future<void> _closeDatabaseAndExit() async {
    try {
      await AppDatabase.instance.close();
    } catch (_) {}

    try {
      await SystemNavigator.pop();
    } catch (_) {}

    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<Map<String, dynamic>> actions = [
      {"title": "الكاشير", "subtitle": "فاتورة جديدة", "icon": Iconss.pos, "isActive": true},
      {"title": "سجل المبيعات", "subtitle": "الفواتير السابقة", "icon": Iconss.order, "isActive": false},
      {"title": "المنتجات", "subtitle": "إدارة وتعديل", "icon": Iconss.product, "isActive": false},
      {"title": "الأقسام", "subtitle": "تنظيم الأصناف", "icon": Iconss.category, "isActive": false},
      {"title": "العملاء", "subtitle": "إدارة الحسابات", "icon": Iconss.customer, "isActive": false},
      {"title": "الموردين", "subtitle": "دليل البيانات", "icon": Iconss.supplier, "isActive": false},
      {"title": "المشتريات", "subtitle": "طلبات وتوريد", "icon": Iconss.purchase, "isActive": false},
      {"title": "المخزن", "subtitle": "مستوى النواقص", "icon": Iconss.warehouse, "isActive": false},
      {"title": "التقارير", "subtitle": "تحليل الأرباح", "icon": Iconss.barChart, "isActive": false},
      {"title": "الإعدادات", "subtitle": "تهيئة النظام", "icon": Iconss.settings, "isActive": false},
      {"title": "إنهاء الشيفت", "subtitle": "طباعة تقرير الشيفت", "icon": Icons.print_outlined, "isActive": false},
      {"title": "إغلاق Modu", "subtitle": "إغلاق الابلكيشن", "icon": Icons.close, "isActive": false},
    ];

    final filteredActions = actions.where((action) {
      switch (action["title"]) {
        case "المنتجات": return user.canManageProducts;
        case "الأقسام": return user.canManageCategories;
        case "العملاء": return user.canManageCustomers;
        case "الموردين": return user.canManageSuppliers;
        case "المخزن": return user.canManageInventory;
        case "التقارير": return user.canManageReports;
        case "الإعدادات": return user.canManageSettings;
        default: return true;
      }
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "الوصول السريع",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Directionality(
          textDirection: TextDirection.rtl,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.35,
            ),
            itemCount: filteredActions.length,
            itemBuilder: (context, index) {
              final item = filteredActions[index];

              return ActionCard(
                title: item["title"],
                subtitle: item["subtitle"],
                icon: item["icon"],
                isActive: item["isActive"],
                onTap: () async {
                  if (item["title"] == "الأقسام") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<CategoryCubit>(),
                          child: const CategoriesScreen(),
                        ),
                      ),
                    );
                  } else if (item["title"] == "سجل المبيعات") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (context) => SalesHistoryCubit(
                            repository: SalesHistoryRepositoryImpl(
                              dataSource: SalesHistoryLocalDataSourceImpl(),
                            ),
                          ),
                          child: const SalesHistoryScreen(),
                        ),
                      ),
                    );
                  } else if (item["title"] == "المنتجات") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<ProductCubit>(),
                          child: const ProductsScreen(),
                        ),
                      ),
                    );
                  } else if (item["title"] == "الكاشير") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (_) => OrderCubit(
                                OrderRepositoryImpl(
                                  localDataSource: OrderLocalDataSourceImpl(),
                                  printService: ModuPrintService(),
                                ),
                              ),
                            ),
                            BlocProvider.value(
                              value: context.read<ProductCubit>()
                                ..loadProducts(),
                            ),
                          ],
                          child: const PosCashierScreen(),
                        ),
                      ),
                    );
                  } else if (item["title"] == "العملاء") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => CustomerCubit(
                            CustomerRepository(CustomerLocalDataSourceImpl()),
                          )..loadCustomers(),
                          child: const CustomerScreen(),
                        ),
                      ),
                    );
                  } else if (item["title"] == "التقارير") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => DashboardCubit(
                            DashboardRepositoryImpl(
                              localDataSource: DashboardLocalDataSourceImpl(),
                            ),
                          )..loadDashboard(),
                          child: const DashboardScreen(),
                        ),
                      ),
                    );
                  } else if (item["title"] == "الإعدادات") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => SettingsCubit(
                            SettingsRepository(
                              SettingsLocalDataSourceImpl(),
                            ),
                          )..loadSettings(),
                          child: const SettingsScreen(),
                        ),
                      ),
                    );
                  } else if (item["title"] == "إنهاء الشيفت") {
                    await _handleEndShiftWorkflow(context);
                  } else if (item["title"] == "إغلاق Modu") {
                    await _handleExitAppWorkflow(context);
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// ============================================================
// Action Card
// ============================================================
class ActionCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const ActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<ActionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          transform: _isHovered
              ? (Matrix4.identity()..translate(0.0, -4.0))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: _isHovered
                ? colorScheme.primary.withOpacity(0.04)
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
            ),
            boxShadow: _isHovered
                ? [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: 28,
                color: _isHovered
                    ? colorScheme.primary
                    : theme.textTheme.bodyLarge?.color,
              ),
              const SizedBox(height: 12),
              Text(
                widget.title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: widget.isActive
                      ? Colors.green
                      : theme.textTheme.bodyLarge?.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}