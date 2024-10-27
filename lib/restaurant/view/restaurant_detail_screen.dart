import 'package:code_factory_app/common/const/colors.dart';
import 'package:code_factory_app/common/layout/default_layout.dart';
import 'package:code_factory_app/common/model/cursor_pagination_model.dart';
import 'package:code_factory_app/common/utils/pagination_utils.dart';
import 'package:code_factory_app/product/component/product_card.dart';
import 'package:code_factory_app/product/model/product_model.dart';
import 'package:code_factory_app/rating/component/rating_card.dart';
import 'package:code_factory_app/rating/model/rating_model.dart';
import 'package:code_factory_app/restaurant/component/RestaurantCard.dart';
import 'package:code_factory_app/restaurant/model/restaurant_detail_model.dart';
import 'package:code_factory_app/restaurant/model/restaurant_model.dart';
import 'package:code_factory_app/restaurant/provider/restaurant_provider.dart';
import 'package:code_factory_app/restaurant/provider/restaurant_rating_provider.dart';
import 'package:code_factory_app/user/provider/basket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:badges/badges.dart' as badge;

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => 'RestaurantDetail';

  final String id;

  const RestaurantDetailScreen({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);

    controller.addListener(listener);
  }

  void listener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(
        restaurantRatingProvider(widget.id).notifier,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));
    final ratingsState = ref.watch(restaurantRatingProvider(widget.id));
    final basket = ref.watch(basketProvider);

    if (state == null) {
      return DefaultLayout(
          child: Center(
        child: CircularProgressIndicator(),
      ));
    }

    return DefaultLayout(
      title: '불타는 떡볶이',
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: PRIMARY_COLOR,
        child: badge.Badge(
          // 0 이면 안보여줘도 된다.
          showBadge: basket.isNotEmpty,
          badgeContent: Text(
            basket
                .fold<int>(
                  0,  // 초기값
                  (previous, next) => previous + next.count,
                )
                .toString(),
            style: TextStyle(color: PRIMARY_COLOR,fontSize: 10.0),
          ),
          badgeStyle: badge.BadgeStyle(
            badgeColor: Colors.white,
          ),
          child: Icon(
            Icons.shopping_basket_outlined,
            color: Colors.white,
          ),
        ),
      ),
      child: CustomScrollView(
        controller: controller,
        slivers: [
          renderTop(
            model: state,
          ),
          if (state is! RestaurantDetailModel) renderLoading(),
          if (state is RestaurantDetailModel) renderLabel(),
          if (state is RestaurantDetailModel)
            renderProducts(
              products: state.products,
              restaurant: state,
            ),
          if (ratingsState is CursorPagination<RatingModel>)
            renderRatings(
              models: ratingsState.data,
            ),
        ],
      ),
    );
  }

  SliverPadding renderLabel() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  SliverPadding renderRatings({
    required List<RatingModel> models,
  }) =>
      SliverPadding(
          padding: EdgeInsets.all(16.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, index) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: RatingCard.fromModel(
                  model: models[index],
                ),
              ),
              childCount: models.length,
            ),
          ));

  SliverPadding renderLoading() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 16.0,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          List.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: SkeletonParagraph(
                style: SkeletonParagraphStyle(
                  lines: 5,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  SliverPadding renderProducts({
    required RestaurantModel restaurant,
    required List<RestaurantProductModel> products,
  }) =>
      SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final model = products[index];
              return InkWell(
                onTap: () {
                  ref.read(basketProvider.notifier).addToBasket(
                        product: ProductModel(
                          id: model.id,
                          name: model.name,
                          detail: model.detail,
                          imgUrl: model.imgUrl,
                          price: model.price,
                          restaurant: restaurant,
                        ),
                      );
                },
                child: Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child:
                        ProductCard.fromRestaurantProductModel(model: model)),
              );
            },
            childCount: products.length,
          ),
        ),
      );

  SliverToBoxAdapter renderTop({
    required RestaurantModel model,
  }) =>
      SliverToBoxAdapter(
          child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ));
}
