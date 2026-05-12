import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/async_state_view.dart';
import 'standings_controller.dart';

class StandingsPage extends GetView<StandingsController> {
  const StandingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('积分榜')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: AsyncStateView<List<DataRow>>(
          controller: controller,
          onRetry: controller.loadStandings,
          builder: (rows) {
            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: Card(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('排名')),
                      DataColumn(label: Text('球队')),
                      DataColumn(label: Text('赛')),
                      DataColumn(label: Text('胜')),
                      DataColumn(label: Text('平')),
                      DataColumn(label: Text('负')),
                      DataColumn(label: Text('净胜')),
                      DataColumn(label: Text('积分')),
                    ],
                    rows: rows.map((item) {
                      final row = item as dynamic;
                      return DataRow(
                        cells: [
                          DataCell(Text('${row.rank}')),
                          DataCell(Text(row.team.shortName)),
                          DataCell(Text('${row.played}')),
                          DataCell(Text('${row.won}')),
                          DataCell(Text('${row.draw}')),
                          DataCell(Text('${row.lost}')),
                          DataCell(Text('${row.goalDiff}')),
                          DataCell(Text('${row.points}')),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
