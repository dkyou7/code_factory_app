import 'package:code_factory_app/user/model/basket_item_model.dart';
import 'package:code_factory_app/user/model/patch_basket_body.dart';
import 'package:code_factory_app/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

import '../../product/model/product_model.dart';

final basketProvider =
    StateNotifierProvider<BasketProvider, List<BasketItemModel>>((ref) {
  final repository = ref.watch(userMeRepositoryProvider);

  return BasketProvider(
    repository: repository,
  );
});

class BasketProvider extends StateNotifier<List<BasketItemModel>> {
  final UserMeRepository repository;

  BasketProvider({
    required this.repository,
  }) : super([]);

  Future<void> patchBasket() async{
    await repository.patchBasket(
      body: PatchBasketBody(
        basket: state
            .map(
              (e) => PatchBasketBodyBasket(
                productId: e.product.id,
                count: e.count,
              ),
            )
            .toList(),
      ),
    );
  }

  Future<void> addToBasket({
    required ProductModel product,
  }) async {
    /// 1) 아직 아무것도 없다면
    /// 장바구니에 상품을 추가한다.
    /// 2) 만약 들어있다면,
    /// 장바구니에 있는 값에 + 1을 한다.

    /// null 이 아니면 true
    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (exists) {
      state = state
          .map(
            (e) => e.product.id == product.id
                ? e.copyWith(
                    count: e.count + 1,
                  )
                : e,
          )
          .toList();
    } else {
      state = [
        ...state,
        BasketItemModel(
          product: product,
          count: 1,
        ),
      ];
    }
    // 긍정적 응답(Optimistic Response)
    // 될 것을 예상하고, 실제 응답 요청은 나중에 보냄
    await patchBasket();
  }

  Future<void> removeFromBasket({
    required ProductModel product,

    // isDelete 가 true 면 count 갯수와 상관 없이 그냥 삭제한다.
    bool isDelete = false,
  }) async {
    /// 1) 상품이 존재할 떄
    /// 1.1) count > 1 : 상품 count--
    /// 1.2) count == 1 : 상품 delete
    /// 2) 상품이 존재하지 않을 때
    /// 즉시 함수를 반환하고, 아무것도 하지 않는다.

    /// null 이 아니면 true
    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (!exists) return;

    final existingProduct = state.firstWhere((e) => e.product.id == product.id);

    if (existingProduct.count == 1 || isDelete) {
      // 아이디가 일치하지 않는 것만 모아서 리스트를 업데이트 시켜준다.
      state = state
          .where(
            (e) => e.product.id != product.id,
          )
          .toList();
    } else {
      // 아이디가 일치하는 것을 count -1 해준다.
      state = state
          .map(
            (e) =>
                e.product.id == product.id ? e.copyWith(count: e.count - 1) : e,
          )
          .toList();
    }

    await patchBasket();
  }
}
