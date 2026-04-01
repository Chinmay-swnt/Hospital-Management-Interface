import 'package:flutter/material.dart';
import 'appointment_page.dart'; // Ensure this import is correct

class DoctorPage extends StatefulWidget {
  const DoctorPage({super.key});

  @override
  State<DoctorPage> createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  // Production Logic: Track the active filter
  String activeFilter = "All";

  // Mock Database
  final List<Map<String, dynamic>> allDoctors = [
    {
      'name': 'Dr. Ananya Sharma',
      'spec': 'Senior Cardiologist',
      'exp': '14 yrs',
      'rating': 4.9,
      'appts': 12,
      'active': true,
      'cat': 'CARDIOLOGY',
    },
    {
      'name': 'Dr. Vikram Nair',
      'spec': 'Interventional Cardiology',
      'exp': '9 yrs',
      'rating': 4.7,
      'appts': 8,
      'active': true,
      'cat': 'CARDIOLOGY',
    },
    {
      'name': 'Dr. Riya Pillai',
      'spec': 'Neurologist',
      'exp': '11 yrs',
      'rating': 4.8,
      'appts': 6,
      'active': true,
      'cat': 'NEUROLOGY',
    },
    {
      'name': 'Dr. Karan Mehta',
      'spec': 'Neuro-surgeon',
      'exp': '16 yrs',
      'rating': 4.6,
      'appts': 0,
      'active': false,
      'cat': 'NEUROLOGY',
    },
    {
      'name': 'Dr. Sneha Gupta',
      'spec': 'Orthopaedic Surgeon',
      'exp': '8 yrs',
      'rating': 4.8,
      'appts': 9,
      'active': true,
      'cat': 'ORTHOPEDICS',
    },
  ];

  List<Map<String, dynamic>> get filteredDoctors {
    if (activeFilter == "On duty")
      return allDoctors.where((d) => d['active'] == true).toList();
    if (activeFilter == "Off duty")
      return allDoctors.where((d) => d['active'] == false).toList();
    return allDoctors;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // 1. App Bar
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFF1B4F72),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
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
                    child: Text(
                      "${filteredDoctors.length} active",
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Interactive Filter Toggle
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFF1B4F72),
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Row(
                children: [
                  _buildFilterBtn("All"),
                  const SizedBox(width: 8),
                  _buildFilterBtn("On duty"),
                  const SizedBox(width: 8),
                  _buildFilterBtn("Off duty"),
                ],
              ),
            ),
          ),

          // 3. Dynamic Specialty Sections
          ..._buildAllSections(),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  List<Widget> _buildAllSections() {
    // Grouping logic for production
    final categories = ["CARDIOLOGY", "NEUROLOGY", "ORTHOPEDICS"];
    return categories.map((cat) {
      final docsInCat = filteredDoctors.where((d) => d['cat'] == cat).toList();
      if (docsInCat.isEmpty)
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      return _buildSpecialtySection(cat, docsInCat);
    }).toList();
  }

  Widget _buildFilterBtn(String label) {
    bool isActive = activeFilter == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => activeFilter = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.white.withOpacity(0.2)
                : Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
            border: isActive ? Border.all(color: Colors.white30) : null,
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
          return _buildDoctorCard(doctors[index - 1]);
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFE6F1FB),
                child: Text(
                  doc['name'].split(' ').last[0],
                  style: const TextStyle(
                    color: Color(0xFF1B4F72),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: doc['active'] ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc['name'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${doc['spec']} · ${doc['exp']}",
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, size: 12, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      "${doc['rating']}",
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      doc['appts'] == 0 ? 'Off today' : '${doc['appts']} appts',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AppointmentPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B4F72),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              minimumSize: const Size(60, 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Book",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
