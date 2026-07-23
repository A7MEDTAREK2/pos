import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ====== Core ======
import '../../../../core/data_mange/data_mange/app_restart.dart';
import '../../../../core/data_mange/data_mange/cubit_mange.dart';
import '../../../../core/data_mange/data_mange/state_mange.dart';
import '../../../../core/service/printing/service/modu_print_service.dart';
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';

// ====== Settings ======
import '../../../driver/data/localdata.dart';
import '../../../driver/data/repo.dart';
import '../../../driver/logic/drive_cubit.dart';
import '../../../driver/pre/driver_Screen.dart';
import '../../data/model/settings_model.dart';
import '../../logic/set_cubit.dart';
import '../../logic/set_state.dart';
import '../widget/data reste_dailog.dart';
import '../widget/settings_action_button.dart';
import '../widget/settings_card.dart';
import '../widget/settings_dropdown.dart';
import '../widget/settings_footer.dart';
import '../widget/settings_section.dart';
import '../widget/settings_switch.dart';
import '../widget/settings_text_field.dart';
import '../widget/users_section.dart';

// ====== Printer Settings Screen ======
import 'printer_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ====== Controllers ======
  final storeController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final taxNumberController = TextEditingController();
  final taxController = TextEditingController();
  final footerController = TextEditingController();

  // ====== Variables ======
  String currency = "EGP";
  String language = "ar";

  // ====== Printers ======
  String cashierPrinter = "";
  String kitchenPrinter = "";
  String barcodePrinter = "";
  String reportsPrinter = "";
  int paperWidth = 80;

  // ====== Switches ======
  bool taxEnabled = true;
  bool autoPrintReceipt = false;
  bool autoPrintKitchen = true;
  bool autoOpenDrawer = true;

  bool showLogo = true;
  bool showAddress = true;
  bool showPhone = true;
  bool showTaxNumber = false;
  bool showQr = true;

  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    context.read<SettingsCubit>().loadSettings();
  }

  void _updateControllers(SettingsModel settings) {
    storeController.text = settings.storeName;
    phoneController.text = settings.phone;
    addressController.text = settings.address;
    taxNumberController.text = settings.taxNumber;
    taxController.text = settings.taxPercentage.toString();
    footerController.text = settings.footerMessage;

    currency = settings.currency;
    language = settings.language;

    if (settings.cashierPrinter.isNotEmpty) {
      cashierPrinter = settings.cashierPrinter;
    }
    if (settings.kitchenPrinter.isNotEmpty) {
      kitchenPrinter = settings.kitchenPrinter;
    }
    if (settings.barcodePrinter.isNotEmpty) {
      barcodePrinter = settings.barcodePrinter;
    }
    if (settings.reportsPrinter.isNotEmpty) {
      reportsPrinter = settings.reportsPrinter;
    }

    paperWidth = settings.paperWidth;

    taxEnabled = settings.taxEnabled;
    autoPrintReceipt = settings.autoPrintReceipt;
    autoPrintKitchen = settings.autoPrintKitchen;
    autoOpenDrawer = settings.autoOpenDrawer;

    showLogo = settings.showLogo;
    showAddress = settings.showAddress;
    showPhone = settings.showPhone;
    showTaxNumber = settings.showTaxNumber;
    showQr = settings.showQr;
  }

  @override
  void dispose() {
    storeController.dispose();
    phoneController.dispose();
    addressController.dispose();
    taxNumberController.dispose();
    taxController.dispose();
    footerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MaintenanceCubit, MaintenanceState>(
      listener: (context, state) {
        if (state is MaintenanceSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          if (state.message.contains("سيتم إعادة تشغيل البرنامج")) {
            Future.delayed(const Duration(seconds: 1), () async {
              await AppRestart.restart();
            });
          }
        }

        if (state is MaintenanceError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: BlocConsumer<SettingsCubit, SettingsState>(
        listener: (context, state) {
          if (state is SettingsLoaded && !_loaded) {
            _updateControllers(state.settings);
            _loaded = true;
            setState(() {});
          }

          if (state is SettingsSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("تم حفظ الإعدادات بنجاح"),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }

          if (state is SettingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: Colorsmanegments.background,
              appBar: AppBar(
                title: Text(
                  'الإعدادات',
                  style: TxtStyle.headerMedium,
                ),
                centerTitle: true,
                backgroundColor: Colorsmanegments.card,
                foregroundColor: Colorsmanegments.textPrimary,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(
                    Iconss.arrowBack,
                    color: Colorsmanegments.textPrimary,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // ====== 1. General ======
                    SettingsSection(
                      title: 'عام',
                      icon: Iconss.settings,
                      child: SettingsCard(
                        children: [
                          SettingsTextField(
                            label: 'اسم المتجر',
                            hint: 'Modu POS',
                            icon: Iconss.store,
                            controller: storeController,
                          ),
                          const SizedBox(height: 16),
                          SettingsTextField(
                            label: 'رقم الهاتف',
                            hint: '010xxxxxxxx',
                            icon: Iconss.phone,
                            controller: phoneController,
                          ),
                          const SizedBox(height: 16),
                          SettingsTextField(
                            label: 'العنوان',
                            hint: 'العنوان بالكامل',
                            icon: Iconss.location,
                            controller: addressController,
                          ),
                          const SizedBox(height: 16),
                          SettingsTextField(
                            label: 'الرقم الضريبي',
                            hint: 'الرقم الضريبي',
                            icon: Iconss.receipt,
                            controller: taxNumberController,
                          ),
                          const SizedBox(height: 16),
                          SettingsDropdown(
                            label: 'العملة',
                            value: currency,
                            items: const ["EGP", "USD", "SAR"],
                            icon: Iconss.sales,
                            onChanged: (value) {
                              if (value != null) setState(() => currency = value);
                            },
                          ),
                          const SizedBox(height: 16),
                          SettingsDropdown(
                            label: 'اللغة',
                            value: language,
                            items: const ["ar", "en"],
                            icon: Iconss.language,
                            onChanged: (value) {
                              if (value != null) setState(() => language = value);
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ====== 2. Printing (Navigates to PrinterSettingsScreen) ======
                    SettingsCard(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Iconss.print,
                            color: Colorsmanegments.primary,
                            size: 28,
                          ),
                          title: Text(
                            'إعدادات الطابعات والطباعة',
                            style: TxtStyle.titleMedium,
                          ),
                          subtitle: Text(
                            'التحكم في طابعة الكاشير، المطبخ، الباركود، التقارير ومقاس الورق',
                            style: TxtStyle.bodySmall,
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colorsmanegments.grey,
                          ),
                          onTap: () async {
                            // عند العودة من شاشة الطابعات يمكننا إعادة تحميل الإعدادات المحدثة
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PrinterSettingsScreen(),
                              ),
                            );
                            if (context.mounted) {
                              context.read<SettingsCubit>().loadSettings();
                            }
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ====== 3. Sales ======
                    SettingsSection(
                      title: 'المبيعات',
                      icon: Iconss.sales,
                      child: SettingsCard(
                        children: [
                          SettingsTextField(
                            label: 'نسبة الضريبة',
                            hint: '0.00',
                            icon: Iconss.percent,
                            controller: taxController,
                          ),
                          const SizedBox(height: 16),
                          SettingsSwitch(
                            label: 'تفعيل الضريبة',
                            value: taxEnabled,
                            onChanged: (value) => setState(() => taxEnabled = value),
                          ),
                          const SizedBox(height: 12),
                          SettingsSwitch(
                            label: 'طباعة الفاتورة تلقائياً',
                            value: autoPrintReceipt,
                            onChanged: (value) => setState(() => autoPrintReceipt = value),
                          ),
                          const SizedBox(height: 12),
                          SettingsSwitch(
                            label: 'طباعة المطبخ تلقائياً',
                            value: autoPrintKitchen,
                            onChanged: (value) => setState(() => autoPrintKitchen = value),
                          ),
                          const SizedBox(height: 12),
                          SettingsSwitch(
                            label: 'فتح الدرج بعد الدفع',
                            value: autoOpenDrawer,
                            onChanged: (value) => setState(() => autoOpenDrawer = value),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ====== 4. Receipt ======
                    SettingsSection(
                      title: 'الفاتورة',
                      icon: Iconss.receipt,
                      child: SettingsCard(
                        children: [
                          SettingsSwitch(
                            label: 'عرض الشعار',
                            value: showLogo,
                            onChanged: (value) => setState(() => showLogo = value),
                          ),
                          const SizedBox(height: 12),
                          SettingsSwitch(
                            label: 'عرض عنوان المتجر',
                            value: showAddress,
                            onChanged: (value) => setState(() => showAddress = value),
                          ),
                          const SizedBox(height: 12),
                          SettingsSwitch(
                            label: 'عرض رقم الهاتف',
                            value: showPhone,
                            onChanged: (value) => setState(() => showPhone = value),
                          ),
                          const SizedBox(height: 12),
                          SettingsSwitch(
                            label: 'عرض الرقم الضريبي',
                            value: showTaxNumber,
                            onChanged: (value) => setState(() => showTaxNumber = value),
                          ),
                          const SizedBox(height: 12),
                          SettingsSwitch(
                            label: 'طباعة QR Code',
                            value: showQr,
                            onChanged: (value) => setState(() => showQr = value),
                          ),
                          const SizedBox(height: 16),
                          SettingsTextField(
                            label: 'رسالة التذييل',
                            hint: 'شكراً لزيارتكم',
                            icon: Iconss.note,
                            controller: footerController,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ====== 5. Backup ======
                    SettingsSection(
                      title: 'النسخ الاحتياطي',
                      icon: Iconss.backup,
                      child: SettingsCard(
                        children: [
                          SettingsActionButton(
                            label: 'إنشاء نسخة احتياطية',
                            icon: Iconss.backup,
                            color: Colorsmanegments.success,
                            onTap: () {
                              context.read<MaintenanceCubit>().backupDatabase();
                            },
                          ),
                          const SizedBox(height: 12),
                          SettingsActionButton(
                            label: 'استعادة نسخة احتياطية',
                            icon: Iconss.restore,
                            color: Colorsmanegments.danger,
                            onTap: () {
                              context.read<MaintenanceCubit>().restoreDatabase();
                            },
                          ),
                          const SizedBox(height: 12),
                          SettingsActionButton(
                            label: 'إعادة تهيئة البيانات',
                            icon: Iconss.deleteForever,
                            color: Colorsmanegments.danger,
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => const ResetDataDialog(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ====== 6. Users ======
                    const UsersSection(),

                    const SizedBox(height: 24),

                    ListTile(
                      leading: Icon(
                        Iconss.driver,
                        color: Colorsmanegments.primary,
                        size: 28,
                      ),
                      title: Text(
                        'المندوبين',
                        style: TxtStyle.titleMedium,
                      ),
                      subtitle: Text(
                        'إدارة المندوبين وإضافة وتعديل وحذف',
                        style: TxtStyle.bodySmall,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colorsmanegments.grey,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (context) => DriverCubit(
                                DriverRepository(
                                  DriverLocalDataSource(),
                                ),
                              )..loadDrivers(),
                              child: const DriverScreen(),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // ====== 7. About ======
                    SettingsSection(
                      title: 'عن التطبيق',
                      icon: Iconss.info,
                      child: SettingsCard(
                        children: [
                          _buildAboutItem('اسم التطبيق', 'Modu POS'),
                          _buildAboutItem('الإصدار', '1.0.0'),
                          _buildAboutItem('المطور','Ahmed Tarek'),
                          _buildAboutItem('التواصل','01092400184'),
                          _buildAboutItem('Email','modytareq225@gmail.com'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ====== Save Button ======
                    SettingsFooter(
                      onPressed: () {
                        final settings = SettingsModel(
                          storeName: storeController.text,
                          phone: phoneController.text,
                          address: addressController.text,
                          taxNumber: taxNumberController.text,
                          taxPercentage: double.tryParse(taxController.text) ?? 0,
                          currency: currency,
                          language: language,
                          cashierPrinter: cashierPrinter,
                          kitchenPrinter: kitchenPrinter,
                          barcodePrinter: barcodePrinter,
                          reportsPrinter: reportsPrinter,
                          paperWidth: paperWidth,
                          taxEnabled: taxEnabled,
                          autoPrintReceipt: autoPrintReceipt,
                          autoPrintKitchen: autoPrintKitchen,
                          autoOpenDrawer: autoOpenDrawer,
                          showLogo: showLogo,
                          showAddress: showAddress,
                          showPhone: showPhone,
                          showTaxNumber: showTaxNumber,
                          showQr: showQr,
                          footerMessage: footerController.text,
                          logo: '',
                        );

                        // 🎯 1. الحفظ في الـ Cubit
                        context.read<SettingsCubit>().saveSettings(settings);

                        // 🎯 2. إرسال الإعدادات لسيرفر الطباعة
                        ModuPrintService().saveSettings(settings.toMap()).catchError((e) {
                          debugPrint("خطأ في إرسال الإعدادات لسيرفر الطباعة: $e");
                        });
                      },
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAboutItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            '$label:',
            style: TxtStyle.labelBold,
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: TxtStyle.bodyMedium,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}