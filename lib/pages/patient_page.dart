import 'package:flutter/material.dart';

// 1. Data Model for better structure
class Patient {
  final String name;
  final String id;
  final String dept;
  final String status;
  final Color color;
  final String avatar;

  Patient({
    required this.name,
    required this.id,
    required this.dept,
    required this.status,
    required this.color,
    required this.avatar,
  });
}

class PatientPage extends StatefulWidget {
  const PatientPage({super.key});

  @override
  State<PatientPage> createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  // 2. State Management
  final TextEditingController _searchController = TextEditingController();
  final List<Patient> _allPatients = [
    Patient(
      name: 'Rahul Kapoor',
      id: '#P-0841',
      dept: 'Cardiology',
      status: 'Review',
      color: Colors.orange,
      avatar: 'RK',
    ),
    Patient(
      name: 'Sanya Mehta',
      id: '#P-0839',
      dept: 'Orthopaedics',
      status: 'Stable',
      color: Colors.green,
      avatar: 'SM',
    ),
    Patient(
      name: 'Arjun Joshi',
      id: '#P-0837',
      dept: 'Neurology',
      status: 'Critical',
      color: Colors.red,
      avatar: 'AJ',
    ),
    Patient(
      name: 'Priya Desai',
      id: '#P-0836',
      dept: 'Pediatrics',
      status: 'Stable',
      color: Colors.green,
      avatar: 'PD',
    ),
  ];

  List<Patient> _filteredPatients = [];

  @override
  void initState() {
    super.initState();
    _filteredPatients = _allPatients;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _filteredPatients = _allPatients
          .where(
            (p) =>
                p.name.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ) ||
                p.id.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ),
          )
          .toList();
    });
  }

  // 3. Add Patient Logic
  void _addNewPatient() {
    final formKey = GlobalKey<FormState>();
    String name = '';
    String dept = 'General';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add New Patient",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? "Please enter a name" : null,
                onSaved: (v) => name = v!,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: dept,
                decoration: InputDecoration(
                  labelText: "Department",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items:
                    [
                          "Cardiology",
                          "Neurology",
                          "Orthopaedics",
                          "Pediatrics",
                          "General",
                        ]
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                onChanged: (v) => dept = v!,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B4F72),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      setState(() {
                        final newPatient = Patient(
                          name: name,
                          id: "#P-${(1000 + _allPatients.length)}",
                          dept: dept,
                          status: "New",
                          color: Colors.blue,
                          avatar: name
                              .split(' ')
                              .map((e) => e[0])
                              .take(2)
                              .join()
                              .toUpperCase(),
                        );
                        _allPatients.insert(0, newPatient);
                        _onSearchChanged(); // Refresh filtered list
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    "Register Patient",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "Patient Records",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1B4F72),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1B4F72),
        onPressed: _addNewPatient,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _filteredPatients.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredPatients.length,
                    itemBuilder: (context, index) =>
                        _buildPatientCard(_filteredPatients[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      color: const Color(0xFF1B4F72),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            icon: Icon(Icons.search, color: Colors.white60, size: 20),
            hintText: "Search by Name or ID...",
            hintStyle: TextStyle(color: Colors.white60, fontSize: 14),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildPatientCard(Patient p) {
    return Dismissible(
      key: Key(p.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        setState(() {
          _allPatients.removeWhere((element) => element.id == p.id);
          _onSearchChanged();
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8ECF0)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: p.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                p.avatar,
                style: TextStyle(fontWeight: FontWeight.bold, color: p.color),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "ID ${p.id} · ${p.dept}",
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: p.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                p.status,
                style: TextStyle(
                  fontSize: 10,
                  color: p.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_search_outlined,
            size: 60,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            "No patients found",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
