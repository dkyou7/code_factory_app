import 'package:code_factory_app/common/model/cursor_pagination_model.dart';
import 'package:code_factory_app/common/model/pagination_params.dart';

abstract class IBasePaginationRepository<T>{
  Future<CursorPagination<T>> paginate({
    PaginationParams? paginationParams = const PaginationParams(),
  });
}