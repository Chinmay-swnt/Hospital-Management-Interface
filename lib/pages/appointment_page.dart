import 'package:flutter/material.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  DateTime selectedDate = DateTime.now();
  String selectedTime = "10:30 AM";

  final List<String> timeSlots = [
    "9:00 AM",
    "10:30 AM",
    "12:00 PM",
    "2:00 PM",
    "3:30 PM",
    "4:00 PM",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B4F72),
        elevation: 0,
        title: const Text(
          "Schedule",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          _buildDateSelector(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBookingCard(),
                  const SizedBox(height: 30),
                  const Text(
                    "AVAILABLE SLOTS · APRIL 2",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildTimeGrid(),
                  const SizedBox(height: 40),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 1. Horizontal Date Strip
  Widget _buildDateSelector() {
    return Container(
      color: const Color(0xFF1B4F72),
      padding: const EdgeInsets.only(bottom: 20, top: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: List.generate(7, (index) {
            bool isSelected = index == 2; // Mocking April 2nd as selected
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF7EC8E3)
                    : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    "Apr",
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFF1B4F72)
                          : Colors.white60,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    "${index + 31 > 31 ? index - 0 : index + 31}", // Mock dates
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFF1B4F72)
                          : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  // 2. Doctor/Patient Info Card
  Widget _buildBookingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8ECF0)),
      ),
      child: Column(
        children: [
          _rowItem("Patient", "Select patient", isAction: true),
          const Divider(height: 24),
          _rowItem("Doctor", "Dr. Sneha Gupta", isAction: false),
        ],
      ),
    );
  }

  Widget _rowItem(String label, String value, {required bool isAction}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Text(
          value,
          style: TextStyle(
            color: isAction ? const Color(0xFF1B4F72) : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 13,
            decoration: isAction ? TextDecoration.underline : null,
          ),
        ),
      ],
    );
  }

  // 3. Time Slot Grid
  Widget _buildTimeGrid() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: timeSlots.map((time) {
        bool isSelected = selectedTime == time;
        return GestureDetector(
          onTap: () => setState(() => selectedTime = time),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF1B4F72) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF1B4F72)
                    : const Color(0xFFE8ECF0),
              ),
            ),
            child: Text(
              time,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // 4. Submit Button
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1B4F72),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          "Book appointment",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
