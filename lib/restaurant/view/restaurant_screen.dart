import 'package:code_factory_app/common/model/cursor_pagination_model.dart';
import 'package:code_factory_app/restaurant/component/RestaurantCard.dart';
import 'package:code_factory_app/restaurant/model/restaurant_model.dart';
import 'package:code_factory_app/restaurant/provider/restaurant_provider.dart';
import 'package:code_factory_app/restaurant/repository/restaurant_repository.dart';
import 'package:code_factory_app/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(restaurantProvider);

    if (data.length == 0) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        itemCount: data.length,
        itemBuilder: (_, index) {
          final pItem = data[index];
          return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RestaurantDetailScreen(
                      id: pItem.id,
                    ),
                  ),
                );
              },
              child: RestaurantCard.fromModel(
                model: pItem,
              ));
        },
        separatorBuilder: (_, index) {
          return SizedBox(height: 24.0);
        },
      )
    );
  }
}
