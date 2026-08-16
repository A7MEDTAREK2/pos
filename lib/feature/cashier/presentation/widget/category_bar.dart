import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';
import '../../../category/logic/category_cubit.dart';
import '../../../category/logic/category_state.dart';
import '../../../product/logic/product_cubit.dart';

class PosCategoryBar extends StatefulWidget {
  const PosCategoryBar({super.key});

  @override
  State<PosCategoryBar> createState() => _PosCategoryBarState();
}

class _PosCategoryBarState extends State<PosCategoryBar> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      height: 70,
      child: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          debugPrint("CategoryBar State = $state");

          if (state is! CategorySuccess) {
            return const SizedBox();
          }

          debugPrint("Categories = ${state.categories.length}");

          return Listener(
            onPointerSignal: (pointerSignal) {
              if (pointerSignal is PointerScrollEvent) {
                final newOffset =
                    _scrollController.offset + pointerSignal.scrollDelta.dy;
                _scrollController.animateTo(
                  newOffset.clamp(
                    0.0,
                    _scrollController.position.maxScrollExtent,
                  ),
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                );
              }
            },
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                },
              ),
              child: ListView.separated(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                scrollDirection: Axis.horizontal,
                itemCount: state.categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final category = state.categories[index];

                  return Tooltip(
                    message: "Ctrl + ${index + 1} - ${category.name}",
                    waitDuration: const Duration(milliseconds: 300),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        context.read<ProductCubit>().loadProducts(
                          filterCategoryId: category.id,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: colorScheme.outlineVariant),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Iconss.restaurant,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              category.name,
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}