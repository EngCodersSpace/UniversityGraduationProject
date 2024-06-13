import 'package:get/get_rx/src/rx_types/rx_types.dart';
class TableTime {
  TableTime({
    this.id,
    this.days,
    this.time,
    this.title,
    this.description,
  });

  RxInt? id;
  Map? days ;
  RxString? time;
  RxString? title;
  RxString? description;
}