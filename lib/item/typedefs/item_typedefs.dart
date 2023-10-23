import 'package:flutter/widgets.dart';
import 'package:glider/item/cubit/item_cubit.dart';
import 'package:glider_domain/glider_domain.dart';

typedef ItemCallback = void Function(
  BuildContext context,
  Item item,
);

typedef ItemWithCubitCallback = void Function(
  BuildContext context,
  Item item,
  ItemCubit itemCubit,
);
