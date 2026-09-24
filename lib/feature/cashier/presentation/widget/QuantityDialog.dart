// lib/feature/cashier/presentation/widget/quantity_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuantityDialog extends StatefulWidget {
  final String itemName;
  final int currentQuantity;

  const QuantityDialog({
    super.key,
    required this.itemName,
    required this.currentQuantity,
  });

  @override
  State<QuantityDialog> createState() => _QuantityDialogState();
}

class _QuantityDialogState extends State<QuantityDialog> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentQuantity.toString());

    // تحديد النص بالكامل أول ما الحوار يفتح عشان الكاشير يكتب الرقم الجديد مباشرة
    _controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _controller.text.length,
    );

    // تركيز الكيبورد تلقائياً على حقل النص أول ما الشاشة تفتح
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // التحكم عند الضغط على أزرار النامباد الظاهري
  void _onNumberTap(String val) {
    setState(() {
      if (val == "C") {
        _controller.text = "1";
      } else if (val == "⌫") {
        if (_controller.text.isNotEmpty) {
          _controller.text = _controller.text.substring(0, _controller.text.length - 1);
          if (_controller.text.isEmpty) _controller.text = "1";
        }
      } else {
        if (_controller.text == "1" && val != "0") {
          _controller.text = val;
        } else {
          _controller.text += val;
        }
      }
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    });
  }

  void _submit() {
    final qty = int.tryParse(_controller.text) ?? 1;
    Navigator.pop(context, qty > 0 ? qty : 1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // استقبال زر Enter من الكيبورد الحقيقي لتأكيد الكمية مباشرة
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (event) {
        if (event.logicalKey == LogicalKeyboardKey.enter ||
            event.logicalKey == LogicalKeyboardKey.numpadEnter) {
          _submit();
        }
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "تعديل كمية: ${widget.itemName}",
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: 260,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // حقل النص مدعوم بالكيبورد الحقيقي واللوحة الظاهرية
              TextField(
                controller: _controller,
                focusNode: _focusNode,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
                onSubmitted: (_) => _submit(), // الضغط على Enter في الكيبورد بيأكد
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
              const SizedBox(height: 16),

              // شبكة الأرقام (Numpad) للضغط بالماوس أو الشاشة
              _buildNumpad(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: _submit,
            child: const Text("تأكيد"),
          ),
        ],
      ),
    );
  }

  Widget _buildNumpad() {
    final List<String> buttons = [
      "1", "2", "3",
      "4", "5", "6",
      "7", "8", "9",
      "C", "0", "⌫"
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.5,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemCount: buttons.length,
      itemBuilder: (context, index) {
        final btn = buttons[index];
        return InkWell(
          onTap: () => _onNumberTap(btn),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            alignment: Alignment.center,
            child: Text(
              btn,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}