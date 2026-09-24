// lib/main.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// ====== Core ======
import 'core/data_base/pos_database.dart';
import 'core/data_mange/data_mange/cubit_mange.dart';
import 'core/data_mange/data_mange/local_mange.dart';
import 'core/data_mange/data_mange/repo.dart';
import 'core/notification/notification_cubit.dart';
import 'core/service/printing/printing_manager.dart';
import 'core/service/printing/service/modu_print_service.dart';
import 'core/service/server_service.dart';
import 'core/theming/app_theme.dart';
import 'core/theming/colors manegments.dart';
import 'core/theming/theme_cubit.dart';

// ====== Splash & System ======
import 'feature/audit_log/login/data/data_source/local_data_source.dart';
import 'feature/audit_log/login/data/repo/local_rapo.dart';
import 'feature/audit_log/login/logic/audit_log_cubit.dart';
import 'feature/driver/data/localdata.dart';
import 'feature/driver/data/repo.dart';
import 'feature/driver/logic/drive_cubit.dart';
import 'feature/inventory/data/datasource/inventory_local_data_source.dart';
import 'feature/inventory/logic/inventory_cubit.dart';
import 'feature/purchase/data/datasource/local_data_source.dart';
import 'feature/purchase/data/repo/local_repo.dart';
import 'feature/purchase/logic/purchase_cubit.dart';
import 'feature/reports/data/data_source/driver_report_local_data_source.dart';
import 'feature/reports/logic/SaleDetailsCubit .dart';
import 'feature/setting/data/datasorce/UserLocalDataSource.dart';
import 'feature/setting/data/datasorce/local_data.dart';
import 'feature/setting/data/repo/repo.dart' hide UserRepository;
import 'feature/setting/data/repo/repo_user.dart';
import 'feature/setting/logic/set_cubit.dart';
import 'feature/setting/logic/user_cubit.dart';
import 'feature/splash/splash_screen.dart';

// ====== Cashier ======
import 'feature/cashier/data/data_source/local_data_source.dart';
import 'feature/cashier/data/repo/local_rapo.dart';
import 'feature/cashier/logic/pos_cubit.dart';

// ====== Category ======
import 'feature/category/data/data_source/local_data_source.dart';
import 'feature/category/data/repo/local_rapo.dart';
import 'feature/category/logic/category_cubit.dart';

// ====== Customer ======
import 'feature/cutomer/data/data_source/address_local_data_source.dart';
import 'feature/cutomer/data/data_source/local_data_source.dart';
import 'feature/cutomer/data/repo/address_local_rapo.dart';
import 'feature/cutomer/data/repo/local_rapo.dart' hide CustomerAddressRepository;
import 'feature/cutomer/logic/customer_cubit.dart';

// ====== Dashboard ======
import 'feature/dashbord/data/data_source/local_data_source.dart';
import 'feature/dashbord/data/repo/local_rapo.dart';
import 'feature/dashbord/logic/dash_cubit.dart';

// ====== Home ======
import 'feature/home/data/data_source/local_data_source.dart';
import 'feature/home/data/repo/local_rapo.dart';
import 'feature/home/logic/home_cubit.dart';

// ====== Product ======
import 'feature/product/data/data_source/local_data_source.dart';
import 'feature/product/data/repo/local_rapo.dart';
import 'feature/product/logic/product_cubit.dart';

// ====== Inventory ======
import 'feature/inventory/data/repo/inventory_repository.dart';

// ====== Reports ======
import 'feature/reports/data/data_source/customer_local_data_source.dart';
import 'feature/reports/data/data_source/local_data_source.dart';
import 'feature/reports/data/data_source/order_type_local_data_source.dart';
import 'feature/reports/data/data_source/payment_local_data_source.dart';
import 'feature/reports/data/data_source/prudct_local_data_source.dart';
import 'feature/reports/data/data_source/stock_local_data_source.dart';
import 'feature/reports/data/repo/customer_report_repository.dart';
import 'feature/reports/data/repo/local_rapo.dart';
import 'feature/reports/data/repo/order_type_report_repository.dart';
import 'feature/reports/data/repo/payment_report_repository.dart';
import 'feature/reports/data/repo/stock_report_repository.dart';
import 'feature/reports/logic/product_report_cubit.dart';
import 'feature/reports/logic/report/customer_report_cubit.dart';
import 'feature/reports/logic/report/order_type_report_cubit.dart';
import 'feature/reports/logic/report/payment_report_cubit.dart';
import 'feature/reports/logic/report/stock_report_cubit.dart';
import 'feature/reports/presentation/product_report/screen/product_report_screen.dart';

// ====== Driver Report (تعديل: استيراد مستودع وكيوبت تقرير المناديب) ======
import 'feature/reports/data/repo/driver_report_repository.dart';
import 'feature/reports/logic/report/driver_report_cubit.dart';

// ====== Sales & Supplier ======
import 'feature/sale/data/data_source/sales_history_local_data_source_impl.dart';
import 'feature/sale/data/repo/local_rapo.dart';
import 'feature/sale/logic/sale_cubit.dart';
import 'feature/supplier/data/datasource/local_data_source.dart';
import 'feature/supplier/data/repo/local_repo.dart';
import 'feature/supplier/logic/supplier_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  try {
    await ServerService.start();
    print("✅ Print Service Running");
  } catch (e) {
    print("❌ Print Service Error: $e");
  }

  PrintingManager.instance.startQueueWorker();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // ====== Theme Cubit ======
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(),
        ),

        // ====== Home ======
        BlocProvider<HomeCubit>(
          create: (_) => HomeCubit(
            HomeRepository(
              HomeLocalDataSource(),
            ),
          )..loadDashboardData(),
        ),

        // ====== Product ======
        BlocProvider<ProductCubit>(
          create: (context) => ProductCubit(
            ProductRepository(
              ProductLocalDataSource(
                AppDatabase.instance.database,
              ),
            ),
            CategoryRepository(
              CategoryLocalDataSource(
                AppDatabase.instance.database,
              ),
            ),
            context.read<HomeCubit>(),
          )..loadProducts(),
        ),

        // ====== Inventory ======
        BlocProvider<InventoryCubit>(
          create: (_) => InventoryCubit(
            inventoryRepository: InventoryRepositoryImpl(
              localDataSource: InventoryLocalDataSourceImpl(),
            ),
          )..fetchStockItems(),
        ),

        // ====== Order ======
        BlocProvider<OrderCubit>(
          create: (_) => OrderCubit(
              OrderRepositoryImpl(
                localDataSource: OrderLocalDataSourceImpl(),
                printService: ModuPrintService(),
              )
          ),
        ),

        // ====== Category ======
        BlocProvider<CategoryCubit>(
          create: (_) => CategoryCubit(
            CategoryRepository(
              CategoryLocalDataSource(
                AppDatabase.instance.database,
              ),
            ),
          )..loadCategories(),
        ),

        // ====== Customer ======
        BlocProvider<CustomerCubit>(
          create: (_) => CustomerCubit(
            CustomerRepository(
              CustomerLocalDataSourceImpl(),
            ),
          )..loadCustomers(),
        ),

        // ====== Customer Address ======
        BlocProvider<CustomerAddressCubit>(
          create: (_) => CustomerAddressCubit(
            CustomerAddressRepository(
              CustomerAddressLocalDataSourceImpl(),
            ),
          ),
        ),

        // ====== Sales History ======
        BlocProvider<SalesHistoryCubit>(
          create: (_) => SalesHistoryCubit(
            repository: SalesHistoryRepositoryImpl(
              dataSource: SalesHistoryLocalDataSourceImpl(),
            ),
          ),
        ),

        // ====== Dashboard ======
        BlocProvider<DashboardCubit>(
          create: (_) => DashboardCubit(
            DashboardRepositoryImpl(
              localDataSource: DashboardLocalDataSourceImpl(),
            ),
          )..loadDashboard(),
        ),

        // ====== Sale Details ======
        BlocProvider<SaleDetailssCubit>(
          create: (_) => SaleDetailssCubit(
            ReportsRepositoryImpl(
              localDataSource: ReportsLocalDataSourceImpl(),
            ),
          ),
        ),

        // ====== Product Report ======
        BlocProvider<ProductReportCubit>(
          create: (_) => ProductReportCubit(
            ProductReportRepositoryImpl(
              localDataSource: ProductReportLocalDataSourceImpl(),
            ),
          )..loadReport(),
        ),

        // ====== Customer Report ======
        BlocProvider<CustomerReportCubit>(
          create: (_) => CustomerReportCubit(
            CustomerReportRepositoryImpl(
              localDataSource: CustomerReportLocalDataSourceImpl(),
            ),
          )..loadReport(),
        ),

        // ====== Stock Report ======
        BlocProvider<StockReportCubit>(
          create: (_) => StockReportCubit(
            StockReportRepositoryImpl(
              localDataSource: StockReportLocalDataSourceImpl(),
            ),
          )..loadReport(),
        ),

        // ====== Payment Report ======
        BlocProvider<PaymentReportCubit>(
          create: (_) => PaymentReportCubit(
            PaymentReportRepositoryImpl(
              localDataSource: PaymentReportLocalDataSourceImpl(),
            ),
          )..loadReport(),
        ),

        // ====== Order Type Report ======
        BlocProvider<OrderTypeReportCubit>(
          create: (_) => OrderTypeReportCubit(
            OrderTypeReportRepositoryImpl(
              localDataSource: OrderTypeReportLocalDataSourceImpl(),
            ),
          )..loadReport(),
        ),

        // ====== Driver Report (تعديل: إضافة كيوبت تقرير المناديب هنا) ======
        // ====== Driver Report ======
        BlocProvider<DriverReportCubit>(
          create: (_) => DriverReportCubit(
            repository: DriverReportRepository(
              localDataSource: DriverReportLocalDataSource(), // أو الـ LocalDataSource الخاص بتقرير المناديب
            ),
          )..loadReport(),
        ),

        BlocProvider<SettingsCubit>(
          create: (_) => SettingsCubit(
            SettingsRepository(
              SettingsLocalDataSourceImpl(),
            ),
          )..loadSettings(),
        ),

        // ====== Purchase ======
        BlocProvider<PurchaseCubit>(
          create: (_) => PurchaseCubit(
            PurchaseRepositoryImpl(
              localDataSource:
              PurchaseLocalDataSourceImpl(),
            ),
          )..loadData(),
        ),

        // ===== Users =====
        BlocProvider<UserCubit>(
          create: (_) => UserCubit(
            UserRepository(
              UserLocalDataSource(),
            ),
          )..loadUsers(),
        ),
        BlocProvider<DriverCubit>(
          create: (_) => DriverCubit(
            DriverRepository(
              DriverLocalDataSource(),
            ),
          )..loadDrivers(),
        ),
        BlocProvider<MaintenanceCubit>(
          create: (_) => MaintenanceCubit(
            MaintenanceRepository(
              MaintenanceLocalDataSource(
                AppDatabase.instance,
              ),
            ),
          ),
        ),

        BlocProvider(
          create: (context) => NotificationCubit()..checkLowStockProducts(),
        ),
        // ====== Audit Logs ======
        BlocProvider<AuditLogCubit>(
          create: (_) => AuditLogCubit(
            AuditLogRepositoryImpl(
              localDataSource: AuditLogLocalDataSourceImpl(AppDatabase.instance),
            ),
          )..fetchAuditLogs(),
        ),
        // ===== Supplier =====
        BlocProvider<SupplierCubit>(
          create: (_) => SupplierCubit(
            SupplierRepository(
              SupplierLocalDataSource(),
            ),
          )..loadSuppliers(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Modu POS',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}