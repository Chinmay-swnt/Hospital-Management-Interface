import 'package:flutter/material.dart';

class DoctorPage extends StatelessWidget {
  const DoctorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // 1. App Bar / Header
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF1B4F72),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Doctor list",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "32 active",
                      style: TextStyle(color: Colors.white60, fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Filter Toggle (All, On duty, Off duty)
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFF1B4F72),
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Row(
                children: [
                  _buildFilterBtn("All", isActive: true),
                  const SizedBox(width: 8),
                  _buildFilterBtn("On duty"),
                  const SizedBox(width: 8),
                  _buildFilterBtn("Off duty"),
                ],
              ),
            ),
          ),

          // 3. Categorized Lists
          _buildSpecialtySection("CARDIOLOGY", [
            _doctorData(
              "Dr. Ananya Sharma",
              "Senior Cardiologist",
              "14 yrs",
              4.9,
              12,
              true,
            ),
            _doctorData(
              "Dr. Vikram Nair",
              "Interventional Cardiology",
              "9 yrs",
              4.7,
              8,
              true,
            ),
          ]),

          _buildSpecialtySection("NEUROLOGY", [
            _doctorData(
              "Dr. Riya Pillai",
              "Neurologist",
              "11 yrs",
              4.8,
              6,
              true,
            ),
            _doctorData(
              "Dr. Karan Mehta",
              "Neuro-surgeon",
              "16 yrs",
              4.6,
              0,
              false,
            ),
          ]),

          _buildSpecialtySection("ORTHOPEDICS", [
            _doctorData(
              "Dr. Sneha Gupta",
              "Orthopaedic Surgeon",
              "8 yrs",
              4.8,
              9,
              true,
            ),
          ]),

          // Padding at bottom for navigation bar
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  Widget _buildFilterBtn(String label, {bool isActive = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.white.withOpacity(0.18)
              : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white54,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialtySection(
    String title,
    List<Map<String, dynamic>> doctors,
  ) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 10),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1.1,
                ),
              ),
            );
          }
          final doc = doctors[index - 1];
          return _buildDoctorCard(doc);
        }, childCount: doctors.length + 1),
      ),
    );
  }

  Widget _buildDoctorCard(Map<String, dynamic> doc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8ECF0)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.blue.shade50,
            child: Text(doc['name'].split(' ')[1][0]), // Initial of surname
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc['name'],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${doc['spec']} · ${doc['exp']}",
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 10, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      "${doc['rating']} · ${doc['appts'] == 0 ? 'Off today' : '${doc['appts']} appts today'}",
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF854F0B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: doc['active'] ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _doctorData(
    String name,
    String spec,
    String exp,
    double rating,
    int appts,
    bool active,
  ) {
    return {
      'name': name,
      'spec': spec,
      'exp': exp,
      'rating': rating,
      'appts': appts,
      'active': active,
    };
  }
}
