import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class YearlyData {
  final String year;
  final double deployment;
  final double cumulative;

  YearlyData({
    required this.year,
    required this.deployment,
    required this.cumulative,
  });

  factory YearlyData.fromJson(Map<String, dynamic> json) {
    return YearlyData(
      year: json['_year'],
      deployment: json['deployment'] != "NA"
          ? double.parse(json['deployment'].toString())
          : 0,
      cumulative: double.parse(json['cumulative'].toString()),
    );
  }
}

final chartDataProvider = FutureProvider<List<YearlyData>>((ref) async {
  final response = await http.get(
    Uri.parse(
        'https://api.data.gov.in/resource/526548e3-c7b1-445b-ab8a-d2aa114e34a9?api-key=579b464db66ec23bdd000001cdd3946e44ce4aad7209ff7b23ac571b&format=json'),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body)['records'] as List;
    return data.map((e) => YearlyData.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load data');
  }
});
