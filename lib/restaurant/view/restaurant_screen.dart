import 'dart:math';

import 'package:code_factory_app/common/const/data.dart';
import 'package:code_factory_app/common/dio/dio.dart';
import 'package:code_factory_app/restaurant/component/RestaurantCard.dart';
import 'package:code_factory_app/restaurant/model/restaurant_model.dart';
import 'package:code_factory_app/restaurant/repository/restaurant_repository.dart';
import 'package:code_factory_app/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  Future<List<RestaurantModel>> paginateRestaurant(WidgetRef ref) async {
    final dio =  ref.watch(dioProvider);

    final resp =
    await RestaurantRepository(dio,baseUrl: 'http://$ip/restaurant')
    .paginate();

    return resp.data;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FutureBuilder<List<RestaurantModel>>(
              future: paginateRestaurant(ref),
              builder: (context, AsyncSnapshot<List<RestaurantModel>> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView.separated(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) {
                    final pItem = snapshot.data![index];
                    // parsed
                    // final pItem = RestaurantModel.fromJson(item,);

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
                );
              },
            )),
      ),
    );
  }
}
