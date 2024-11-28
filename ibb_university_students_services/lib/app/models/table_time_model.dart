import 'package:get/get_rx/src/rx_types/rx_types.dart';
class TableTime {
  TableTime({
    this.sun,
    this.mon,
    this.tue,
    this.wed,
    this.the,
    this.sat,
  });

  List<TableDayContent>? sun;
  List<TableDayContent>? mon;
  List<TableDayContent>? tue;
  List<TableDayContent>? wed;
  List<TableDayContent>? the;
  List<TableDayContent>? sat;
}

class TableDayContent{

  TableDayContent({
    required this.title,
    required this.startTime,
    required this.endTime,
    this.doctor,
    this.hall ,
    this.description,
    this.canceled ,
  });
  RxString title;
  RxString startTime;
  RxString endTime;
  RxString? doctor;
  RxString? hall;
  RxString? description;
  RxBool? canceled = RxBool(false);
}
