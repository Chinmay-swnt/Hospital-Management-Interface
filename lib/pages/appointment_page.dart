import 'package:flutter/material.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  int selectedDateIndex = 2;
  String selectedTime = "10:30 AM";
  String selectedPatient = "Rahul Kapoor";
  bool isBooking = false; // Production: Handle loading state

  // Production: Define which slots are already taken
  final List<Map<String, dynamic>> timeSlots = [
    {"time": "9:00 AM", "isBooked": false},
    {"time": "10:30 AM", "isBooked": false},
    {"time": "12:00 PM", "isBooked": true}, // Already taken
    {"time": "2:00 PM", "isBooked": false},
    {"time": "3:30 PM", "isBooked": false},
    {"time": "4:00 PM", "isBooked": false},
  ];

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
          "Schedule",
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
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "AVAILABLE SLOTS · APRIL ${selectedDateIndex + 1}",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const Icon(
                        Icons.info_outline,
                        size: 14,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTimeGrid(),
                  const SizedBox(height: 48),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      color: const Color(0xFF1B4F72),
      padding: const EdgeInsets.only(bottom: 24, top: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: List.generate(14, (index) {
            bool isSelected = selectedDateIndex == index;
            return GestureDetector(
              onTap: () => setState(() => selectedDateIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF7EC8E3)
                      : Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  children: [
                    Text(
                      "Apr",
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
                      "${index + 1}",
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
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
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
          _rowItem("Doctor", "Dr. Sneha Gupta", isAction: false),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  color: isAction ? const Color(0xFF1B4F72) : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              if (isAction) ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: Color(0xFF1B4F72),
                ),
              ],
            ],
          ),
        ],
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
            width:
                (MediaQuery.of(context).size.width - 64) /
                3, // Perfect 3-column grid
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
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isBooking ? null : _handleBooking,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1B4F72),
          elevation: 2,
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
                "Confirm Appointment",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }

  void _handleBooking() async {
    setState(() => isBooking = true);
    // Simulating API call
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => isBooking = false);
    _showSuccessDialog();
  }

  void _showPatientPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: ["Rahul Kapoor", "Sanya Mehta", "Arjun Singh"]
              .map(
                (name) => ListTile(
                  title: Text(name),
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
              size: 80,
            ),
            const SizedBox(height: 16),
            const Text(
              "Success!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Appointment confirmed for $selectedPatient with Dr. Sneha Gupta on April ${selectedDateIndex + 1} at $selectedTime.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Pop dialog
                  Navigator.pop(context); // Back to Home
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B4F72),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Back to Home",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
