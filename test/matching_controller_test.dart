// // test/matching_controller_test.dart

// // ignore_for_file: constant_identifier_names

// import 'package:flutter_test/flutter_test.dart';
// // يجب تعديل المسارات هنا لتتوافق مع مشروعك
// import 'package:rideshare/controller/matching _controller.dart'; 
// import 'package:rideshare/model/data_ model.dart'; 

// // إحداثيات ثابتة للاختبار
// const double CAMPUS_CENTER_LAT = 24.4716; 
// const double CAMPUS_CENTER_LON = 39.6083;

// // 1. نقطة التقاط داخل الحرم الجامعي (لتفعيل التجاوز/Bypass)
// final Location campusPickup = Location(CAMPUS_CENTER_LAT + 0.001, CAMPUS_CENTER_LON + 0.001); 

// // 2. نقطة التقاط خارج الحرم الجامعي (لتفعيل فلتر الـ 7 كم)

// // في ملف test/matching_controller_test.dart

// // 2. نقطة التقاط خارج الحرم الجامعي (لتفعيل فلتر الـ 7 كم)
// final Location nonCampusPickup = Location(25.0000, 40.0000); 

// // قائمة سائقين وهمية مُعدلة لضمان قرب NearDriver و CloseDriver:
// final List<Driver> testDrivers = [
//   // السائق 1: قريب جداً - ضمن الـ 7 كم
//   Driver(id: "D101", name: "NearDriver", location: Location(25.0050, 40.0050)), 
  
//   // السائق 2: بعيد جداً - سيتم فلترته
//   Driver(id: "D102", name: "FarDriver", location: Location(24.0000, 41.0000)), 

//   // السائق 3: قريب جداً - ضمن الـ 7 كم
//   Driver(id: "D103", name: "CloseDriver", location: Location(25.0100, 40.0100)), 
// ];


// // 🟢 تم إضافة الدالة الرئيسية هنا 🟢
// void main() { 
//   final MatchingController matcher = MatchingController();

//   group('MatchingController - Final Test Cases (S5)', () {
    
//     // الاختبار 1: التحقق من عمل فلتر 7 كم (General Rides)
//     test('1. Should filter out drivers further than 7km for Non-Campus pickup', () {
//       final filteredList = matcher.applyDistanceFilter(
//         pickupLocation: nonCampusPickup,
//         availableDrivers: List.from(testDrivers), 
//       );
//       // التأكد من أن العدد هو 2 (استبعاد السائق البعيد D102)
//       expect(filteredList.length, 2); 
//       // التأكد من استبعاد السائق البعيد
//       expect(filteredList.any((d) => d.id == "D102"), isFalse); 
//     });

//     // الاختبار 2: التحقق من تجاوز الفلتر (Campus Override)
//     test('2. Should bypass the 7km filter and return ALL 3 drivers for Campus pickup', () {
//       final filteredList = matcher.applyDistanceFilter(
//         pickupLocation: campusPickup,
//         availableDrivers: List.from(testDrivers),
//       );
//       // التأكد من أن العدد هو 3 (إرجاع الجميع)
//       expect(filteredList.length, 3);
//       // التأكد من أن السائق البعيد (D102) لم يتم استبعاده
//       expect(filteredList.any((d) => d.id == "D102"), isTrue); 
//     });
//   });
// }