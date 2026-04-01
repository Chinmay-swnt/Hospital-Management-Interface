import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  int selectedDateIndex = 0;
  String? selectedTime;
  String selectedPatient = "Rahul Kapoor";
  // Added: State to track the selected doctor
  String selectedDoctor = "Dr. Sneha Gupta";
  bool isBooking = false;

  final TextEditingController _reasonController = TextEditingController();
  final ScrollController _dateScrollController = ScrollController();

  final List<Map<String, dynamic>> timeSlots = [
    {"time": "09:00 AM", "isBooked": false},
    {"time": "10:30 AM", "isBooked": false},
    {"time": "12:00 PM", "isBooked": true},
    {"time": "02:00 PM", "isBooked": false},
    {"time": "03:30 PM", "isBooked": false},
    {"time": "04:30 PM", "isBooked": false},
  ];

  final List<DateTime> availableDates = List.generate(
    14,
    (index) => DateTime.now().add(Duration(days: index)),
  );

  @override
  void dispose() {
    _reasonController.dispose();
    _dateScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B4F72),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Book Appointment",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildDateSelector(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBookingCard(),
                  const SizedBox(height: 24),
                  _buildSectionHeader("REASON FOR VISIT"),
                  const SizedBox(height: 12),
                  _buildReasonField(),
                  const SizedBox(height: 32),
                  _buildSectionHeader(
                    "AVAILABLE SLOTS · ${DateFormat('MMMM dd').format(availableDates[selectedDateIndex]).toUpperCase()}",
                  ),
                  const SizedBox(height: 16),
                  _buildTimeGrid(),
                  const SizedBox(height: 40),
                  _buildSubmitButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      color: const Color(0xFF1B4F72),
      padding: const EdgeInsets.only(bottom: 24, top: 8),
      child: SingleChildScrollView(
        controller: _dateScrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: List.generate(availableDates.length, (index) {
            DateTime date = availableDates[index];
            bool isSelected = selectedDateIndex == index;
            return GestureDetector(
              onTap: () => setState(() => selectedDateIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF7EC8E3)
                      : Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      DateFormat('MMM').format(date),
                      style: TextStyle(
                        color: isSelected
                            ? const Color(0xFF1B4F72)
                            : Colors.white60,
                        fontSize: 11,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date.day.toString(),
                      style: TextStyle(
                        color: isSelected
                            ? const Color(0xFF1B4F72)
                            : Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildBookingCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8ECF0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          _rowItem(
            "Patient",
            selectedPatient,
            isAction: true,
            onTap: _showPatientPicker,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, thickness: 0.5, color: Color(0xFFE8ECF0)),
          ),
          // Updated: Doctor row is now an action that triggers the picker
          _rowItem(
            "Doctor",
            selectedDoctor,
            isAction: true,
            onTap: _showDoctorPicker,
          ),
        ],
      ),
    );
  }

  Widget _rowItem(
    String label,
    String value, {
    required bool isAction,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                if (isAction)
                  const Icon(
                    Icons.keyboard_arrow_right,
                    size: 18,
                    color: Colors.grey,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReasonField() {
    return TextField(
      controller: _reasonController,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: "Briefly describe your symptoms...",
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.all(16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE8ECF0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF1B4F72)),
        ),
      ),
    );
  }

  Widget _buildTimeGrid() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: timeSlots.map((slot) {
        bool isBooked = slot['isBooked'];
        bool isSelected = selectedTime == slot['time'];
        return GestureDetector(
          onTap: isBooked
              ? null
              : () => setState(() => selectedTime = slot['time']),
          child: Container(
            width: (MediaQuery.of(context).size.width - 64) / 3,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: isBooked
                  ? Colors.grey.shade100
                  : (isSelected ? const Color(0xFF1B4F72) : Colors.white),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF1B4F72)
                    : const Color(0xFFE8ECF0),
              ),
            ),
            child: Text(
              isBooked ? "Booked" : slot['time'],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isBooked
                    ? Colors.grey
                    : (isSelected ? Colors.white : Colors.black87),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSubmitButton() {
    bool canSubmit = selectedTime != null && !isBooking;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: canSubmit ? _handleBooking : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1B4F72),
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isBooking
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                "Confirm & Pay",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  void _handleBooking() async {
    setState(() => isBooking = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => isBooking = false);
    _showSuccessDialog();
  }

  // Picker for selecting the patient
  void _showPatientPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: ["Rahul Kapoor", "Sanya Mehta", "Self"]
              .map(
                (name) => ListTile(
                  title: Text(name),
                  trailing: selectedPatient == name
                      ? const Icon(Icons.check, color: Color(0xFF1B4F72))
                      : null,
                  onTap: () {
                    setState(() => selectedPatient = name);
                    Navigator.pop(context);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  // Added: Picker for selecting the doctor
  void _showDoctorPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Select Doctor",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            ...["Dr. Sneha Gupta", "Dr. Rahul Sharma", "Dr. Ananya Iyer"]
                .map(
                  (name) => ListTile(
                    title: Text(name),
                    trailing: selectedDoctor == name
                        ? const Icon(Icons.check, color: Color(0xFF1B4F72))
                        : null,
                    onTap: () {
                      setState(() => selectedDoctor = name);
                      Navigator.pop(context);
                    },
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            const SizedBox(height: 16),
            const Text(
              "Booking Confirmed",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              "Your visit with $selectedDoctor is scheduled for ${DateFormat('MMM dd').format(availableDates[selectedDateIndex])} at $selectedTime.",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("Done"),
            ),
          ],
        ),
      ),
    );
  }
}
