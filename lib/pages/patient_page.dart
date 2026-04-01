import 'package:flutter/material.dart';

class PatientPage extends StatelessWidget {
  const PatientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text("Patient records",  style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),),
            backgroundColor: Color(0xFF1B4F72),
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "ALL PATIENTS",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildPatientList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 1. Header with Search specifically for the Patient List
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
      decoration: const BoxDecoration(color: Color(0xFF1B4F72)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                icon: Icon(Icons.search, color: Colors.white60, size: 20),
                hintText: "Search by Name or ID...",
                hintStyle: TextStyle(color: Colors.white60, fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 2. The Patient List based on your UI data
  Widget _buildPatientList() {
    final List<Map<String, dynamic>> patients = [
      {
        'name': 'Rahul Kapoor',
        'id': '#P-0841',
        'dept': 'Cardiology',
        'status': 'Review',
        'color': Colors.orange,
        'avatar': 'RK',
      },
      {
        'name': 'Sanya Mehta',
        'id': '#P-0839',
        'dept': 'Orthopaedics',
        'status': 'Stable',
        'color': Colors.green,
        'avatar': 'SM',
      },
      {
        'name': 'Arjun Joshi',
        'id': '#P-0837',
        'dept': 'Neurology',
        'status': 'Critical',
        'color': Colors.red,
        'avatar': 'AJ',
      },
      {
        'name': 'Priya Desai',
        'id': '#P-0836',
        'dept': 'Pediatrics',
        'status': 'Stable',
        'color': Colors.green,
        'avatar': 'PD',
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: patients.length,
      itemBuilder: (context, index) {
        final p = patients[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE8ECF0)),
          ),
          child: Row(
            children: [
              // Avatar with specific background colors from your design
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: (p['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  p['avatar'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: p['color'],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p['name'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "ID ${p['id']} · ${p['dept']}",
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: (p['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  p['status'],
                  style: TextStyle(
                    fontSize: 10,
                    color: p['color'],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
