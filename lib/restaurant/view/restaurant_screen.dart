import 'dart:math';

import 'package:code_factory_app/common/const/data.dart';
import 'package:code_factory_app/restaurant/component/RestaurantCard.dart';
import 'package:code_factory_app/restaurant/model/restaurant_model.dart';
import 'package:code_factory_app/restaurant/view/restaurant_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  Future<List> paginateRestaurant() async {
    final dio = Dio();

    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final resp = await dio.get(
      'http://$ip/restaurant',
      options: Options(
        headers: {
          'authorization': 'Bearer $accessToken',
        },
      ),
    );

    return resp.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FutureBuilder<List>(
              future: paginateRestaurant(),
              builder: (context, AsyncSnapshot<List> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView.separated(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) {
                    final item = snapshot.data![index];
                    // parsed
                    final pItem = RestaurantModel.fromJson(
                      json: item,
                    );

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
                      )
                    );
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
