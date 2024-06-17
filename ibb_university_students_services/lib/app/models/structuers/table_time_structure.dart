import 'package:get/get_rx/src/rx_types/rx_types.dart';
class TableTime {
  TableTime({
    this.id,
    this.sun,
    this.mon,
    this.tue,
    this.wed,
    this.the,
    this.sat,
  });

  RxInt? id;
  List<TableDayContent>? sun;
  List<TableDayContent>? mon;
  List<TableDayContent>? tue;
  List<TableDayContent>? wed;
  List<TableDayContent>? the;
  List<TableDayContent>? sat;
}

class TableDayContent{

  TableDayContent({
    required this.time,
    required this.title,
    this.hall,
    this.description
});
  RxString title;
  RxString time;
  RxString? hall;
  RxString? description;
}