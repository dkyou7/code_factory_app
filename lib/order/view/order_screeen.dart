import 'package:code_factory_app/common/component/pagination_list_view.dart';
import 'package:code_factory_app/order/component/order_card.dart';
import 'package:code_factory_app/order/model/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/order_provider.dart';

class OrderScreen extends ConsumerWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PaginationListView<OrderModel>(
      provider: orderProvider,
      itemBuilder: <OrderModel>(_, index, model) {
        return OrderCard.fromModel(model: model);
      },
    );
  }
}
