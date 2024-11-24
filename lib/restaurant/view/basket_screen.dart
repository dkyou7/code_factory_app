import 'package:code_factory_app/common/const/colors.dart';
import 'package:code_factory_app/common/layout/default_layout.dart';
import 'package:code_factory_app/order/provider/order_provider.dart';
import 'package:code_factory_app/order/view/order_done_screen.dart';
import 'package:code_factory_app/product/component/product_card.dart';
import 'package:code_factory_app/user/provider/basket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BasketScreen extends ConsumerWidget {
  static String get routeName => 'basket';

  const BasketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);

    if (basket.isEmpty) {
      return DefaultLayout(
          title: '장바구니',
          child: Center(
            child: Text('장바구니가 비어있습니다.'),
          ));
    }

    final productTotal = basket.fold(
      0,
      // p : 기존값
      // n : next 값을
      // => 우측에서 구현해서 넣겠다.
      (p, n) => p + (n.product.price * n.count),
    );
    final deliveryFee = basket.first.product.restaurant.deliveryFee;

    return DefaultLayout(
      title: '장바구니',
      child: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (_, index) {
                    return const Divider(
                      height: 32.0,
                    );
                  },
                  itemBuilder: (_, index) {
                    final model = basket[index].product;

                    return ProductCard.fromProductModel(
                      model: model,
                      onAdd: () {
                        ref
                            .read(basketProvider.notifier)
                            .addToBasket(product: model);
                      },
                      onSubtract: () {
                        ref
                            .read(basketProvider.notifier)
                            .removeFromBasket(product: model);
                      },
                    );
                  },
                  itemCount: basket.length,
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '장바구니 금액',
                        style: TextStyle(
                          color: BODY_TEXT_COLOR,
                        ),
                      ),
                      Text(
                        productTotal.toString() + '원',
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '배달비',
                        style: TextStyle(
                          color: BODY_TEXT_COLOR,
                        ),
                      ),
                      if (basket.length > 0) Text(deliveryFee.toString() + '원'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '총 금액',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: BODY_TEXT_COLOR,
                        ),
                      ),
                      Text((productTotal + deliveryFee).toString() + '원'),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final resp =
                            await ref.read(orderProvider.notifier).postOrder();

                        if (resp) {
                          context.goNamed(OrderDoneScreen.routeName);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('결제 실패'),
                          ));
                        }
                      },
                      child: Text('결제하기'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PRIMARY_COLOR,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
