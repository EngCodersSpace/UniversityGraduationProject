import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../models/study_plan_elements_model/study_plan_elements.dart';

Future<Uint8List> generateStudyPlanPdfFromElements({
  required List<StudyPlanElement> elements,
  required String studyPlanName,
  required int studyPlanId,
  required String sectionName, // ✅ added section name
}) async {
  final pdf = pw.Document();

  // Group by level
  final grouped = <int, List<StudyPlanElement>>{};
  for (final element in elements) {
    if (element.levelId == null) continue;
    grouped.putIfAbsent(element.levelId!, () => []).add(element);
  }

  final sortedLevels = grouped.keys.toList()..sort();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(24),
      build: (context) => [
        // Header
        pw.Header(
          level: 0,
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Study Plan',
                  style: pw.TextStyle(
                      fontSize: 22, fontWeight: pw.FontWeight.bold)),
              pw.Text(DateFormat('yyyy-MM-dd').format(DateTime.now())),
            ],
          ),
        ),

        // Plan details
        pw.Center(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
            pw.Text('Study Plan Name: $studyPlanName',
                style: pw.TextStyle(fontSize: 14)),
            pw.Text('Study Plan ID: $studyPlanId',
                style: pw.TextStyle(fontSize: 14)),
            pw.Text('Section: $sectionName', style: pw.TextStyle(fontSize: 14)),
            pw.SizedBox(height: 16),
          ]),
        ),
        // Body grouped by level
        ...sortedLevels.map((levelId) {
          final levelElements = grouped[levelId]!;

          final firstSemester =
              levelElements.where((e) => e.term == 'Term 1').toList();
          final secondSemester =
              levelElements.where((e) => e.term == 'Term 2').toList();

          pw.Widget buildTable(String title, List<StudyPlanElement> items) {
            return pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(title,
                      style: pw.TextStyle(
                          fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 4),
                  items.isEmpty
                      ? pw.Text('No subjects',
                          style: pw.TextStyle(fontStyle: pw.FontStyle.italic))
                      : pw.TableHelper.fromTextArray(
                          headers: ['Subject', 'No. Units'],
                          data: items
                              .map((e) => [
                                    e.subject?.subjectName ?? 'Unknown',
                                    e.subject?.units.toString() ?? '0',
                                  ])
                              .toList(),
                          headerStyle:
                              pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          border: pw.TableBorder.all(),
                          cellAlignment: pw.Alignment.centerLeft,
                          columnWidths: {
                            0: const pw.FlexColumnWidth(3),
                            1: const pw.FlexColumnWidth(1),
                          },
                        ),
                ],
              ),
            );
          }

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Level $levelId',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 6),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  buildTable('1st Semester', firstSemester),
                  pw.SizedBox(width: 20),
                  buildTable('2nd Semester', secondSemester),
                ],
              ),
              pw.SizedBox(height: 20),
            ],
          );
        }),
      ],
    ),
  );

  return pdf.save();
}
