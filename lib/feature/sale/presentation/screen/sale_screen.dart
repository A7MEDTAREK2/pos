// lib/feature/sales/presentation/screen/sales_history_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ====== Home (لعمل Refresh للداشبورد) ======
import '../../../home/logic/home_cubit.dart';

import '../../logic/sale_cubit.dart';
import '../../logic/sale_state.dart';
import '../widget/empty_sales_widget.dart';
import '../widget/error_sales_widget.dart';
import '../widget/loading_widget.dart';
import '../widget/sale_action.dart';
import '../widget/sale_card.dart';
import '../widget/sale_details_bottom_sheet.dart';
import '../widget/sales_history_dialogs.dart';
import '../widget/sales_search_field.dart';
import '../widget/sales_stats_card.dart';

class SalesHistoryScreen extends StatefulWidget {
  const SalesHistoryScreen({super.key});

  @override
  State<SalesHistoryScreen> createState() => _SalesHistoryScreenState();
}

class _SalesHistoryScreenState extends State<SalesHistoryScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SalesHistoryCubit>().loadSales();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text("سجل المبيعات"), centerTitle: true),
      body:

         Stack(
          children: [
            Column(
              children: [
                SalesSearchField(
                  controller: searchController,
                  onChanged: (value) {
                    if (value.trim().isEmpty) {
                      context.read<SalesHistoryCubit>().clearSearch();
                    } else {
                      context.read<SalesHistoryCubit>().searchSales(value);
                    }
                  },
                  onClear: () {
                    searchController.clear();
                    context.read<SalesHistoryCubit>().clearSearch();
                  },
                ),
                Expanded(
                  child: BlocBuilder<SalesHistoryCubit, SalesHistoryState>(
                    builder: (context, state) {
                      if (state is SalesHistoryLoading) {
                        return const SalesLoadingWidget();
                      }

                      if (state is SalesHistoryError) {
                        return ErrorSalesWidget(
                          message: state.message,
                          onRetry: () {
                            context.read<SalesHistoryCubit>().loadSales();
                          },
                        );
                      }

                      if (state is SalesHistorySuccess) {
                        return Column(
                          children: [
                            SalesStatsCard(state: state),

                            const SizedBox(height: 12),

                            Expanded(
                              child: state.displaySales.isEmpty
                                  ? const EmptySalesWidget()
                                  : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: state.displaySales.length,
                                itemBuilder: (context, index) {
                                  final sale = state.displaySales[index];

                                  return Card(
                                    margin: const EdgeInsets.only(
                                      bottom: 12,
                                    ),
                                    child: SaleCard(
                                      sale: sale,

                                      onDetails: () {
                                        SaleDetailsBottomSheet.show(
                                          context,
                                          sale.id,
                                        );
                                      },

                                      onDelete: () async {
                                        final confirm =
                                        await SaleActionDialogs.confirmDelete(
                                          context,
                                        );

                                        if (!confirm) return;

                                        await context
                                            .read<SalesHistoryCubit>()
                                            .deleteSale(sale.id);

                                        // 🌟 تحديث الداشبورد بعد الحذف
                                        if (context.mounted) {
                                          try {
                                            context.read<HomeCubit>().refreshDashboard();
                                          } catch (_) {}
                                        }
                                      },

                                      onPrint: () {
                                        context
                                            .read<SalesHistoryCubit>()
                                            .printSale(sale.id);
                                      },

                                      onReopen: () async {
                                        final confirm =
                                        await SaleActionDialogs.confirmReopen(
                                          context,
                                        );

                                        if (!confirm) return;

                                        await context
                                            .read<SalesHistoryCubit>()
                                            .reopenOrder(sale.id);

                                        // 🌟 تحديث الداشبورد بعد إعادة فتح الطلب
                                        if (context.mounted) {
                                          try {
                                            context.read<HomeCubit>().refreshDashboard();
                                          } catch (_) {}
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
            BlocBuilder<SalesHistoryCubit, SalesHistoryState>(
              builder: (context, state) {
                final loading =
                    state is SalesDeleteLoading ||
                        state is SalesReopenLoading ||
                        state is SalesPrintLoading;

                if (!loading) {
                  return const SizedBox.shrink();
                }

                return Positioned.fill(
                  child: ColoredBox(
                    color: Colors.black26,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),

    );
  }


}