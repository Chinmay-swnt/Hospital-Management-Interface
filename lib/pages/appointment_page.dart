import 'package:flutter/material.dart';

// ----------------------------------------------------------------
// MODEL
// ----------------------------------------------------------------
class Appointment {
  final String doctorName;
  final String specialty;
  final String time;
  final String patientInfo;
  final String location;
  final Color timeBg;
  final Color timeColor;

  Appointment({
    required this.doctorName,
    required this.specialty,
    required this.time,
    required this.patientInfo,
    required this.location,
    this.timeBg = const Color(0xFFE3F2FD),
    this.timeColor = const Color(0xFF1B4F72),
  });
}

// ----------------------------------------------------------------
// PAGE
// ----------------------------------------------------------------
class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  // Theme Constants
  static const Color primaryNavy = Color(0xFF1B4F72);
  static const Color accentBlue = Color(0xFF7EC8E3);
  static const Color backgroundGray = Color(0xFFF5F7FA);

  int selectedDateIndex = 1;
  String? selectedTime = "10:30 AM";
  String selectedPatient = "Select patient...";
  String selectedDoctor = "Dr. Sneha Gupta";

  final List<Map<String, String>> dates = [
    {"day": "MON", "num": "31"},
    {"day": "TUE", "num": "1"},
    {"day": "WED", "num": "2"},
    {"day": "THU", "num": "3"},
    {"day": "FRI", "num": "4"},
    {"day": "SAT", "num": "5"},
  ];

  final List<String> timeSlots = [
    "9:00 AM",
    "10:30 AM",
    "2:00 PM",
    "3:30 PM",
    "4:00 PM",
    "Booked",
  ];

  // Logic: Success Dialog
  void _handleBookAppointment() {
    if (selectedPatient == "Select patient...") {
      _showToast("Please select a patient first", isError: true);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Column(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 48),
            SizedBox(height: 16),
            Text("Success"),
          ],
        ),
        content: Text(
          "Appointment scheduled with $selectedDoctor at $selectedTime",
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "OK",
              style: TextStyle(fontWeight: FontWeight.bold, color: primaryNavy),
            ),
          ),
        ],
      ),
    );
  }

  void _showToast(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : primaryNavy,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGray,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateStrip(),
            _buildSectionLabel("TODAY · APRIL 1"),
            _buildUpcomingCard(
              Appointment(
                doctorName: "Dr. Ananya Sharma",
                specialty: "Cardiology · Follow-up",
                time: "09:30 AM",
                patientInfo: "Rahul Kapoor · ID #P-0841",
                location: "Room 204 · Ward B",
              ),
            ),
            _buildSectionLabel("SCHEDULE NEW APPOINTMENT"),
            _buildScheduleSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // --- UI Components ---

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: primaryNavy,
      elevation: 0,
      title: const Text(
        "Appointments",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _buildDateStrip() {
    return Container(
      color: primaryNavy,
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final isSelected = selectedDateIndex == index;
          return GestureDetector(
            onTap: () => setState(() => selectedDateIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 60,
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dates[index]['day']!,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white60,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dates[index]['num']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isSelected)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: accentBlue,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUpcomingCard(Appointment apt) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8ECF0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    apt.doctorName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    apt.specialty,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: apt.timeBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  apt.time,
                  style: TextStyle(
                    color: apt.timeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 32, color: Color(0xFFF0F0F0)),
          _buildInfoRow(Icons.person_outline, apt.patientInfo),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.location_on_outlined, apt.location),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildActionBtn(
                  "Confirm",
                  primaryNavy,
                  Colors.white,
                  () => _showToast("Confirmed!"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionBtn(
                  "Reschedule",
                  backgroundGray,
                  Colors.grey,
                  () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null)
                      _showToast("Rescheduled to ${date.day}/${date.month}");
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8ECF0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel("PATIENT"),
          _buildSelectionField(
            selectedPatient,
            () => _showPicker("Select Patient", [
              "Rahul Kapoor",
              "Arjun Joshi",
              "Sanya Iyer",
            ], (v) => setState(() => selectedPatient = v)),
          ),
          const SizedBox(height: 16),
          _buildLabel("DOCTOR"),
          _buildSelectionField(
            selectedDoctor,
            () => _showPicker("Select Doctor", [
              "Dr. Sneha Gupta",
              "Dr. Rahul Sharma",
              "Dr. Ananya Iyer",
            ], (v) => setState(() => selectedDoctor = v)),
          ),
          const SizedBox(height: 20),
          _buildLabel("AVAILABLE SLOTS · APRIL 2"),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: timeSlots.map((t) => _buildSlotChip(t)).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _handleBookAppointment,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryNavy,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Schedule Appointment",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helpers ---

  Widget _buildSlotChip(String t) {
    final isBooked = t == "Booked";
    final isSelected = selectedTime == t;
    return GestureDetector(
      onTap: isBooked ? null : () => setState(() => selectedTime = t),
      child: Container(
        width: (MediaQuery.of(context).size.width - 100) / 3,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryNavy
              : (isBooked ? const Color(0xFFF5F5F5) : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryNavy : const Color(0xFFE8ECF0),
          ),
        ),
        child: Center(
          child: Text(
            t,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? Colors.white
                  : (isBooked ? Colors.grey : Colors.black87),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.blue.shade700),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.black54, fontSize: 12)),
      ],
    );
  }

  Widget _buildActionBtn(
    String title,
    Color bg,
    Color text,
    VoidCallback onTap,
  ) {
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 44,
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: text,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  void _showPicker(
    String title,
    List<String> options,
    Function(String) onSelect,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Divider(),
            ...options.map(
              (opt) => ListTile(
                title: Text(opt),
                onTap: () {
                  onSelect(opt);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionField(String value, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundGray,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(color: Colors.black87, fontSize: 13),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey,
                size: 20,
              ),
            ],
          ),
        ),
      );

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
        letterSpacing: 0.5,
      ),
    ),
  );
}
