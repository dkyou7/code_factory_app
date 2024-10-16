import 'package:code_factory_app/common/component/pagination_list_view.dart';
import 'package:code_factory_app/product/component/product_card.dart';
import 'package:code_factory_app/product/model/product_model.dart';
import 'package:code_factory_app/product/provider/product_provider.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaginationListView<ProductModel>(
      provider: productProvider,
      itemBuilder: <ProductModel>(_, index, model) {
        return ProductCard.fromProductModel(
          model: model,
        );
      },
    );
  }
}
