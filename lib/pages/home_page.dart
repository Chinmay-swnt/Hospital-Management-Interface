import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          _buildHeader(),
          _buildStatsStrip(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuickActions(),
                  const SizedBox(height: 24),
                  const Text(
                    "RECENT PATIENTS",
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

  // 1. Dark Blue Header with Search
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: const BoxDecoration(color: Color(0xFF1B4F72)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text.rich(
                TextSpan(
                  text: 'Medi',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  children: [
                    TextSpan(
                      text: 'Care',
                      style: TextStyle(color: Color(0xFF7EC8E3)),
                    ),
                  ],
                ),
              ),
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: Color(0xFF7EC8E3),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  "DR",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B4F72),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: const [
                Icon(Icons.search, color: Colors.white60, size: 20),
                SizedBox(width: 10),
                Text(
                  "Search patients, records...",
                  style: TextStyle(color: Colors.white60),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 2. Overlapping Stats Strip
  Widget _buildStatsStrip() {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _statItem(
              "248",
              "PATIENTS",
              const Color(0xFF7EC8E3),
              isAccent: true,
            ),
            const SizedBox(width: 10),
            _statItem("14", "ADMITTED", const Color(0xFF2C5E7E)),
            const SizedBox(width: 10),
            _statItem("6", "CRITICAL", const Color(0xFF2C5E7E)),
          ],
        ),
      ),
    );
  }

  Widget _statItem(
    String num,
    String label,
    Color bg, {
    bool isAccent = false,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4),
          ],
        ),
        child: Column(
          children: [
            Text(
              num,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isAccent ? const Color(0xFF1B4F72) : Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                color: isAccent
                    ? const Color(0xFF1B4F72).withOpacity(0.7)
                    : Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. Quick Actions Grid (Patient Records, Doctors, etc.)
  Widget _buildQuickActions() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        _actionCard(
          Icons.assignment,
          "Patient records",
          "248 total",
          const Color(0xFFE1F5EE),
        ),
        _actionCard(
          Icons.person,
          "Doctors",
          "32 on duty",
          const Color(0xFFE6F1FB),
        ),
        _actionCard(
          Icons.calendar_today,
          "Appointments",
          "18 today",
          const Color(0xFFFAEEDA),
        ),
        _actionCard(
          Icons.star,
          "Reports",
          "3 pending",
          const Color(0xFFEEEDFE),
        ),
      ],
    );
  }

  Widget _actionCard(IconData icon, String title, String sub, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8ECF0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: Colors.black87),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Text(sub, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  // 4. Recent Patient List
  Widget _buildPatientList() {
    final patients = [
      {
        'name': 'Rahul Kapoor',
        'id': '#P-0841',
        'dept': 'Cardiology',
        'status': 'Review',
        'color': Colors.orange,
      },
      {
        'name': 'Sanya Mehta',
        'id': '#P-0839',
        'dept': 'Orthopaedics',
        'status': 'Stable',
        'color': Colors.green,
      },
    ];

    return Column(
      children: patients
          .map(
            (p) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE8ECF0)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: Text(p['name'].toString()[0]),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p['name'].toString(),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${p['id']} · ${p['dept']}",
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: (p['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      p['status'].toString(),
                      style: TextStyle(
                        fontSize: 10,
                        color: p['color'] as Color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
