import 'package:flutter/material.dart';
import 'patient_page.dart';
import 'doctor_page.dart';
import 'appointment_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Production Logic: Search Controller and Filtered List
  final TextEditingController _searchController = TextEditingController();

  // Mock Data Source
  final List<Map<String, dynamic>> _allPatients = [
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
    {
      'name': 'Arjun Singh',
      'id': '#P-0912',
      'dept': 'Neurology',
      'status': 'Critical',
      'color': Colors.red,
    },
  ];

  List<Map<String, dynamic>> _filteredPatients = [];

  @override
  void initState() {
    super.initState();
    _filteredPatients = _allPatients; // Initial state
  }

  // Search Logic
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allPatients;
    } else {
      results = _allPatients
          .where(
            (user) =>
                user["name"].toLowerCase().contains(
                  enteredKeyword.toLowerCase(),
                ) ||
                user["id"].toLowerCase().contains(enteredKeyword.toLowerCase()),
          )
          .toList();
    }

    setState(() {
      _filteredPatients = results;
    });
  }

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
                  _buildQuickActions(context),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "RECENT PATIENTS",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          letterSpacing: 1.2,
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        Text(
                          "${_filteredPatients.length} found",
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF1B4F72),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildPatientList(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 1. Functional Header with Working Search
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: const BoxDecoration(
        color: Color(0xFF1B4F72),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text.rich(
                TextSpan(
                  text: 'Medi',
                  style: TextStyle(
                    fontSize: 22,
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
              CircleAvatar(
                backgroundColor: const Color(0xFF7EC8E3),
                radius: 19,
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
          const SizedBox(height: 25),
          // PRODUCTION SEARCH BAR
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _runFilter(value),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search patients by name or ID...",
                hintStyle: const TextStyle(color: Colors.white60, fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Colors.white60),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white60),
                        onPressed: () {
                          _searchController.clear();
                          _runFilter('');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
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
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
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
                fontWeight: FontWeight.w600,
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

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _actionCard(
          context,
          Icons.assignment_rounded,
          "Patient records",
          "248 total",
          const Color(0xFFE1F5EE),
          const PatientPage(),
        ),
        _actionCard(
          context,
          Icons.person_search_rounded,
          "Doctors",
          "32 on duty",
          const Color(0xFFE6F1FB),
          const DoctorPage(),
        ),
        _actionCard(
          context,
          Icons.calendar_month_rounded,
          "Appointments",
          "18 today",
          const Color(0xFFFAEEDA),
          const AppointmentPage(),
        ),
      ],
    );
  }

  Widget _actionCard(
    BuildContext context,
    IconData icon,
    String title,
    String sub,
    Color color,
    Widget target,
  ) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => target),
      ),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE8ECF0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 22, color: const Color(0xFF1B4F72)),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(sub, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientList(BuildContext context) {
    if (_filteredPatients.isEmpty) {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Icon(
              Icons.search_off_rounded,
              size: 48,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 12),
            const Text(
              "No patients found matching your search",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredPatients.length,
      itemBuilder: (context, index) {
        final p = _filteredPatients[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE8ECF0)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFE6F1FB),
                child: Text(
                  p['name'][0],
                  style: const TextStyle(
                    color: Color(0xFF1B4F72),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p['name'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${p['id']} · ${p['dept']}",
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: (p['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
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
