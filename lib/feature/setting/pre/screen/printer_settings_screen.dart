import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/service/printing/service/modu_print_service.dart';
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';
import '../widget/settings_action_button.dart';
import '../widget/settings_card.dart';
import '../widget/settings_dropdown.dart';
import '../widget/settings_radio_group.dart';
import '../widget/settings_section.dart';
import '../widget/settings_switch.dart';

class PrinterSettingsScreen extends StatefulWidget {
  const PrinterSettingsScreen({super.key});

  @override
  State<PrinterSettingsScreen> createState() => _PrinterSettingsScreenState();
}

class _PrinterSettingsScreenState extends State<PrinterSettingsScreen> {
  // ====== الطابعات ======
  String cashierPrinter = "";
  String kitchenPrinter = "";
  String barcodePrinter = "";
  String reportsPrinter = "";
  List<String> installedPrinters = [];
  int paperWidth = 80;

  // ====== مقاس الباركود / الورق المخصص ======
  String barcodeSize = "رول 38 * 25";
  final List<String> barcodeSizes = [
    "رول 38 * 150",
    "رول 38 * 25",
    "رول 50 * 25",
    "3 * 11",
    "6 * 12",
    "ميزان 38 * 25",
    "ميزان 50 * 25",
  ];

  // ====== تنسيق العناصر (عنوان الباركود وصنف البوون) ======
  String barcodeTitleFont = "Arial (Arabic)";
  int barcodeTitleSize = 12;
  bool barcodeTitleBold = true;
  bool barcodeTitleItalic = false;
  bool barcodeTitleUnderline = false;

  String itemTitleFont = "Arial (Arabic)";
  int itemTitleSize = 14;
  bool itemTitleBold = true;
  bool itemTitleItalic = false;
  bool itemTitleUnderline = false;

  // ====== خصائص العرض في الباركود ======
  bool showBarcodeValue = true;
  bool showBarcodeTitle = true;
  bool showPrice = true;
  bool showItemName = true;

  // ====== طباعة النسخ التلقائية ======
  bool printCustomerCopy = true;
  bool printKitchenCopy = false;
  bool printDeliveryCopy = false;
  bool printTinnekeCopy = false;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllSettings();
  }

  Future<void> _loadAllSettings() async {
    setState(() => isLoading = true);
    await _fetchPrinters();
    await _fetchSavedSettingsFromServer();
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchPrinters() async {
    try {
      final list = await ModuPrintService().getPrinters();
      setState(() {
        installedPrinters = list.map((e) {
          if (e is Map) {
            return (e['name'] ?? e['printerName'] ?? e.toString()).toString();
          } else if (e is String) {
            return e;
          }
          return e.toString();
        }).toList();

        if (installedPrinters.isNotEmpty && cashierPrinter.isEmpty) {
          cashierPrinter = installedPrinters.first;
          kitchenPrinter = installedPrinters.first;
          barcodePrinter = installedPrinters.first;
          reportsPrinter = installedPrinters.first;
        }
      });
    } catch (_) {
      setState(() {
        installedPrinters = ['Microsoft XPS Document Writer', 'XP-80C', 'طابعة 1'];
        if (cashierPrinter.isEmpty) {
          cashierPrinter = installedPrinters.first;
          kitchenPrinter = installedPrinters.first;
          barcodePrinter = installedPrinters.first;
          reportsPrinter = installedPrinters.first;
        }
      });
    }
  }

  Future<void> _fetchSavedSettingsFromServer() async {
    try {
      final response = await ModuPrintService().getSettings();

      if (response != null) {
        setState(() {
          // الطابعات
          cashierPrinter = response['cashierPrinter']?.toString() ?? cashierPrinter;
          kitchenPrinter = response['kitchenPrinter']?.toString() ?? kitchenPrinter;
          barcodePrinter = response['barcodePrinter']?.toString() ?? barcodePrinter;
          reportsPrinter = response['reportsPrinter']?.toString() ?? reportsPrinter;

          // الأحجام والمقاسات
          paperWidth = response['paperWidth'] ?? paperWidth;
          barcodeSize = response['barcodeSize']?.toString() ?? barcodeSize;

          // تنسيقات خط عنوان الباركود
          if (response['barcodeTitleStyle'] is Map) {
            final bStyle = response['barcodeTitleStyle'];
            barcodeTitleFont = bStyle['font'] ?? barcodeTitleFont;
            barcodeTitleSize = bStyle['size'] ?? barcodeTitleSize;
            barcodeTitleBold = bStyle['bold'] ?? barcodeTitleBold;
            barcodeTitleItalic = bStyle['italic'] ?? barcodeTitleItalic;
            barcodeTitleUnderline = bStyle['underline'] ?? barcodeTitleUnderline;
          }

          // تنسيقات خط عنوان الصنف
          if (response['itemTitleStyle'] is Map) {
            final iStyle = response['itemTitleStyle'];
            itemTitleFont = iStyle['font'] ?? itemTitleFont;
            itemTitleSize = iStyle['size'] ?? itemTitleSize;
            itemTitleBold = iStyle['bold'] ?? itemTitleBold;
            itemTitleItalic = iStyle['italic'] ?? itemTitleItalic;
            itemTitleUnderline = iStyle['underline'] ?? itemTitleUnderline;
          }

          // خيارات عرض الباركود
          if (response['barcodeDisplayOptions'] is Map) {
            final opts = response['barcodeDisplayOptions'];
            showBarcodeValue = opts['showBarcodeValue'] ?? showBarcodeValue;
            showBarcodeTitle = opts['showBarcodeTitle'] ?? showBarcodeTitle;
            showPrice = opts['showPrice'] ?? showPrice;
            showItemName = opts['showItemName'] ?? showItemName;
          } else {
            showBarcodeValue = response['showBarcodeValue'] ?? showBarcodeValue;
            showBarcodeTitle = response['showBarcodeTitle'] ?? showBarcodeTitle;
            showPrice = response['showPrice'] ?? showPrice;
            showItemName = response['showItemName'] ?? showItemName;
          }

          // خيارات طباعة النسخ التلقائية
          if (response['autoPrintCopies'] is Map) {
            final copies = response['autoPrintCopies'];
            printCustomerCopy = copies['customer'] ?? printCustomerCopy;
            printKitchenCopy = copies['kitchen'] ?? printKitchenCopy;
            printDeliveryCopy = copies['delivery'] ?? printDeliveryCopy;
            printTinnekeCopy = copies['tinneke'] ?? printTinnekeCopy;
          } else {
            printCustomerCopy = response['printCustomerCopy'] ?? printCustomerCopy;
            printKitchenCopy = response['printKitchenCopy'] ?? printKitchenCopy;
            printDeliveryCopy = response['printDeliveryCopy'] ?? printDeliveryCopy;
            printTinnekeCopy = response['printTinnekeCopy'] ?? printTinnekeCopy;
          }
        });
      }
    } catch (e) {
      debugPrint("Could not load saved settings: $e");
    }
  }

  Future<void> _savePrinterSettings() async {
    final settingsMap = {
      "cashierPrinter": cashierPrinter,
      "kitchenPrinter": kitchenPrinter,
      "barcodePrinter": barcodePrinter,
      "reportsPrinter": reportsPrinter,
      "paperWidth": paperWidth,
      "barcodeSize": barcodeSize,
      "barcodeTitleStyle": {
        "font": barcodeTitleFont,
        "size": barcodeTitleSize,
        "bold": barcodeTitleBold,
        "italic": barcodeTitleItalic,
        "underline": barcodeTitleUnderline,
      },
      "itemTitleStyle": {
        "font": itemTitleFont,
        "size": itemTitleSize,
        "bold": itemTitleBold,
        "italic": itemTitleItalic,
        "underline": itemTitleUnderline,
      },
      "barcodeDisplayOptions": {
        "showBarcodeValue": showBarcodeValue,
        "showBarcodeTitle": showBarcodeTitle,
        "showPrice": showPrice,
        "showItemName": showItemName,
      },
      "autoPrintCopies": {
        "customer": printCustomerCopy,
        "kitchen": printKitchenCopy,
        "delivery": printDeliveryCopy,
        "tinneke": printTinnekeCopy,
      },
      "showBarcodeValue": showBarcodeValue,
      "showBarcodeTitle": showBarcodeTitle,
      "showPrice": showPrice,
      "showItemName": showItemName,
      "printCustomerCopy": printCustomerCopy,
      "printKitchenCopy": printKitchenCopy,
      "printDeliveryCopy": printDeliveryCopy,
      "printTinnekeCopy": printTinnekeCopy,
    };

    try {
      // 1. حفظ الإعدادات محلياً على الجهاز
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('printCustomerCopy', printCustomerCopy);
      await prefs.setBool('printKitchenCopy', printKitchenCopy);
      await prefs.setBool('printDeliveryCopy', printDeliveryCopy);
      await prefs.setBool('printTinnekeCopy', printTinnekeCopy);
      await prefs.setString('cashierPrinter', cashierPrinter);
      await prefs.setString('kitchenPrinter', kitchenPrinter);
      await prefs.setInt('paperWidth', paperWidth);

      // 2. إرسال الإعدادات للسيرفر
      await ModuPrintService().saveSettings(settingsMap);

      if (!mounted) return;
      // تم إزالة SnackBar
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      // تم إزالة SnackBar
    }
  }

  @override
  Widget build(BuildContext context) {
    final printerOptions = installedPrinters.isNotEmpty
        ? installedPrinters
        : ['Microsoft XPS Document Writer'];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colorsmanegments.background,
        appBar: AppBar(
          title: Text(
            'تحكم وتنسيق الطابعات والباركود',
            style: TxtStyle.headerMedium,
          ),
          centerTitle: true,
          backgroundColor: Colorsmanegments.card,
          foregroundColor: Colorsmanegments.textPrimary,
          elevation: 0,
          leading: Tooltip(
            message: "Esc - رجوع",
            waitDuration: const Duration(milliseconds: 300),
            child: IconButton(
              icon: Icon(
                Iconss.arrowBack,
                color: Colorsmanegments.textPrimary,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // ====== 1. تخصيص الطابعات والأجهزة ======
              SettingsSection(
                title: 'تخصيص الطابعات',
                icon: Iconss.print,
                child: SettingsCard(
                  children: [
                    SettingsDropdown(
                      label: 'اختار طابعة للتقارير',
                      value: printerOptions.contains(reportsPrinter)
                          ? reportsPrinter
                          : printerOptions.first,
                      items: printerOptions,
                      icon: Iconss.print,
                      onChanged: (val) =>
                          setState(() => reportsPrinter = val ?? ''),
                    ),
                    const SizedBox(height: 12),
                    SettingsDropdown(
                      label: 'اختار طابعة للباركود',
                      value: printerOptions.contains(barcodePrinter)
                          ? barcodePrinter
                          : printerOptions.first,
                      items: printerOptions,
                      icon: Iconss.print,
                      onChanged: (val) =>
                          setState(() => barcodePrinter = val ?? ''),
                    ),
                    const SizedBox(height: 12),
                    SettingsDropdown(
                      label: 'اختار طابعة البوون (كاشير)',
                      value: printerOptions.contains(cashierPrinter)
                          ? cashierPrinter
                          : printerOptions.first,
                      items: printerOptions,
                      icon: Iconss.print,
                      onChanged: (val) =>
                          setState(() => cashierPrinter = val ?? ''),
                    ),
                    const SizedBox(height: 12),
                    SettingsDropdown(
                      label: 'اختار طابعة لتجهيز المطبخ',
                      value: printerOptions.contains(kitchenPrinter)
                          ? kitchenPrinter
                          : printerOptions.first,
                      items: printerOptions,
                      icon: Iconss.print,
                      onChanged: (val) =>
                          setState(() => kitchenPrinter = val ?? ''),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ====== 2. مقاسات الباركود والورق ======
              SettingsSection(
                title: 'مقاسات الرول والباركود',
                icon: Iconss.size,
                child: SettingsCard(
                  children: [
                    SettingsDropdown(
                      label: 'مقاس الباركود',
                      value: barcodeSizes.contains(barcodeSize)
                          ? barcodeSize
                          : barcodeSizes.first,
                      items: barcodeSizes,
                      icon: Iconss.size,
                      onChanged: (val) =>
                          setState(() => barcodeSize = val ?? barcodeSize),
                    ),
                    const SizedBox(height: 16),
                    SettingsRadioGroup(
                      label: 'عرض رول الكاشير',
                      value: "$paperWidth مم",
                      items: const ['58 مم', '80 مم'],
                      icon: Iconss.size,
                      onChanged: (val) {
                        setState(() {
                          paperWidth = val == '58 مم' ? 58 : 80;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ====== 3. تنسيق الخطوط ======
              SettingsSection(
                title: 'تنسيق الخطوط (عنوان الباركود والصنف)',
                icon: Iconss.settings,
                child: SettingsCard(
                  children: [
                    _buildStyleControlRow(
                      title: 'تنسيق عنوان الباركود',
                      font: barcodeTitleFont,
                      size: barcodeTitleSize,
                      isBold: barcodeTitleBold,
                      isItalic: barcodeTitleItalic,
                      isUnderline: barcodeTitleUnderline,
                      onFontChanged: (f) =>
                          setState(() => barcodeTitleFont = f),
                      onSizeChanged: (s) =>
                          setState(() => barcodeTitleSize = s),
                      onBoldChanged: (b) =>
                          setState(() => barcodeTitleBold = b),
                      onItalicChanged: (i) =>
                          setState(() => barcodeTitleItalic = i),
                      onUnderlineChanged: (u) =>
                          setState(() => barcodeTitleUnderline = u),
                    ),
                    const Divider(height: 32),
                    _buildStyleControlRow(
                      title: 'تنسيق عنوان الصنف',
                      font: itemTitleFont,
                      size: itemTitleSize,
                      isBold: itemTitleBold,
                      isItalic: itemTitleItalic,
                      isUnderline: itemTitleUnderline,
                      onFontChanged: (f) =>
                          setState(() => itemTitleFont = f),
                      onSizeChanged: (s) =>
                          setState(() => itemTitleSize = s),
                      onBoldChanged: (b) =>
                          setState(() => itemTitleBold = b),
                      onItalicChanged: (i) =>
                          setState(() => itemTitleItalic = i),
                      onUnderlineChanged: (u) =>
                          setState(() => itemTitleUnderline = u),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ====== 4. خيارات طباعة بيانات الباركود ======
              SettingsSection(
                title: 'خيارات طباعة بيانات الباركود',
                icon: Iconss.receipt,
                child: SettingsCard(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SettingsSwitch(
                            label: 'عرض عنوان الباركود',
                            value: showBarcodeTitle,
                            onChanged: (val) =>
                                setState(() => showBarcodeTitle = val),
                          ),
                        ),
                        Expanded(
                          child: SettingsSwitch(
                            label: 'عرض قيمة الباركود',
                            value: showBarcodeValue,
                            onChanged: (val) =>
                                setState(() => showBarcodeValue = val),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: SettingsSwitch(
                            label: 'عرض اسم الصنف',
                            value: showItemName,
                            onChanged: (val) =>
                                setState(() => showItemName = val),
                          ),
                        ),
                        Expanded(
                          child: SettingsSwitch(
                            label: 'عرض السعر',
                            value: showPrice,
                            onChanged: (val) =>
                                setState(() => showPrice = val),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ====== 5. خيارات طباعة النسخ التلقائية ======
              SettingsSection(
                title: 'خيارات طباعة النسخ التلقائية',
                icon: Iconss.print,
                child: SettingsCard(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SettingsSwitch(
                            label: 'نسخة العميل',
                            value: printCustomerCopy,
                            onChanged: (val) =>
                                setState(() => printCustomerCopy = val),
                          ),
                        ),
                        Expanded(
                          child: SettingsSwitch(
                            label: 'نسخة المطعم',
                            value: printKitchenCopy,
                            onChanged: (val) =>
                                setState(() => printKitchenCopy = val),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: SettingsSwitch(
                            label: 'فاتورة دليفري',
                            value: printDeliveryCopy,
                            onChanged: (val) =>
                                setState(() => printDeliveryCopy = val),
                          ),
                        ),
                        Expanded(
                          child: SettingsSwitch(
                            label: 'فاتورة تينيك',
                            value: printTinnekeCopy,
                            onChanged: (val) =>
                                setState(() => printTinnekeCopy = val),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ====== أزرار التجربة ======
              SettingsCard(
                children: [
                  Tooltip(
                    message: "Ctrl + T - تجربة الطباعة",
                    waitDuration: const Duration(milliseconds: 300),
                    child: SettingsActionButton(
                      label: 'تجربة طباعة الباركود / الفاتورة',
                      icon: Iconss.print,
                      color: Colorsmanegments.primary,
                      onTap: () async {
                        try {
                          await ModuPrintService().testPrint(
                            printerName: cashierPrinter,
                            paperWidth: paperWidth,
                          );
                          if (!mounted) return;
                          // تم إزالة SnackBar
                        } catch (e) {
                          if (!mounted) return;
                          // تم إزالة SnackBar
                        }
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // ====== زر الحفظ والربط بالسيرفر ======
              Tooltip(
                message: "Ctrl + S - حفظ الإعدادات",
                waitDuration: const Duration(milliseconds: 300),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colorsmanegments.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: _savePrinterSettings,
                    child: Text(
                      'حفظ الإعدادات وإرسالها للسيرفر',
                      style: TxtStyle.headerLarge,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStyleControlRow({
    required String title,
    required String font,
    required int size,
    required bool isBold,
    required bool isItalic,
    required bool isUnderline,
    required ValueChanged<String> onFontChanged,
    required ValueChanged<int> onSizeChanged,
    required ValueChanged<bool> onBoldChanged,
    required ValueChanged<bool> onItalicChanged,
    required ValueChanged<bool> onUnderlineChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TxtStyle.labelBold),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: font,
                    items: const [
                      DropdownMenuItem(
                          value: "Arial (Arabic)",
                          child: Text("Arial (Arabic)",
                              style: TextStyle(fontSize: 12))),
                      DropdownMenuItem(
                          value: "Cairo",
                          child: Text("Cairo", style: TextStyle(fontSize: 12))),
                    ],
                    onChanged: (val) {
                      if (val != null) onFontChanged(val);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: size,
                    items: [10, 12, 14, 16, 18, 20, 24].map((s) {
                      return DropdownMenuItem(
                          value: s,
                          child: Text("$s",
                              style: const TextStyle(fontSize: 12)));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) onSizeChanged(val);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ToggleButtons(
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              isSelected: [isBold, isItalic, isUnderline],
              onPressed: (index) {
                if (index == 0) onBoldChanged(!isBold);
                if (index == 1) onItalicChanged(!isItalic);
                if (index == 2) onUnderlineChanged(!isUnderline);
              },
              children: const [
                Text('B', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('I', style: TextStyle(fontStyle: FontStyle.italic)),
                Text('U',
                    style: TextStyle(decoration: TextDecoration.underline)),
              ],
            ),
          ],
        ),
      ],
    );
  }
}