import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../widgets/pending_deposits_tab.dart';
import '../widgets/loan_queue_tab.dart';
import '../widgets/students_tab.dart';
import '../widgets/reports_tab.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Panel'),
          bottom: const TabBar(
            isScrollable: true,
            labelColor: primary500,
            unselectedLabelColor: gray500,
            tabs: [
              Tab(text: 'Deposits'),
              Tab(text: 'Loans'),
              Tab(text: 'Students'),
              Tab(text: 'Reports'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PendingDepositsTab(),
            LoanQueueTab(),
            StudentsTab(),
            ReportsTab(),
          ],
        ),
      ),
    );
  }
}
