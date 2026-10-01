import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'booking_confirmed_screen.dart';

class ContractScreen extends StatefulWidget {
  final String musicianId;
  final String musicianName;
  final String musicianImage;
  final String gigId;
  final String gigTitle;
  final String gigDate;
  final String gigTime;
  final String? gigDuration;
  final double amount;
  final String? location;
  final String? organizerName;

  const ContractScreen({
    super.key,
    required this.musicianId,
    required this.musicianName,
    required this.musicianImage,
    required this.gigId,
    required this.gigTitle,
    required this.gigDate,
    required this.gigTime,
    this.gigDuration,
    required this.amount,
    this.location,
    this.organizerName,
  });

  @override
  State<ContractScreen> createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen> {
  bool _agreed = false;

  String _getTimeRange() {
    if (widget.gigTime == 'TBD') return '8:00 PM - 11:00 PM';
    if (widget.gigTime.contains('-') || widget.gigTime.contains('to')) return widget.gigTime;
    try {
      final timeStr = widget.gigTime.toUpperCase().trim();
      // Handle formats like "1:00 PM", "1 PM", "01:00 PM"
      final DateFormat inputFormat = DateFormat.jm();
      DateTime startTime;
      
      try {
        startTime = inputFormat.parse(timeStr);
      } catch (e) {
        // Fallback for formats without minutes like "1 PM"
        if (RegExp(r'^\d+\s*(AM|PM)$').hasMatch(timeStr)) {
          final ampm = timeStr.contains('PM') ? 'PM' : 'AM';
          final hour = timeStr.replaceAll(RegExp(r'[^0-9]'), '');
          startTime = inputFormat.parse('$hour:00 $ampm');
        } else {
          return widget.gigTime;
        }
      }

      if (widget.gigDuration == null || widget.gigDuration!.isEmpty) {
        return inputFormat.format(startTime).toLowerCase();
      }

      // Extract hours and minutes from duration string (e.g., "2 hours", "2.5 hours", "90 mins")
      int totalMinutes = 0;
      final hourMatch = RegExp(r'(\d+\.?\d*)\s*(hour|hr|h)', caseSensitive: false).firstMatch(widget.gigDuration!);
      final minMatch = RegExp(r'(\d+)\s*(min|m)', caseSensitive: false).firstMatch(widget.gigDuration!);

      if (hourMatch != null) {
        totalMinutes += (double.parse(hourMatch.group(1)!) * 60).toInt();
      }
      if (minMatch != null) {
        totalMinutes += int.parse(minMatch.group(1)!);
      }

      if (totalMinutes == 0) return inputFormat.format(startTime).toLowerCase();

      final endTime = startTime.add(Duration(minutes: totalMinutes));
      final displayFormat = DateFormat('h:mm a');
      
      // Clean formatting: remove :00 if both times are on the hour for a cleaner look
      String startDisplay = displayFormat.format(startTime).toLowerCase();
      String endDisplay = displayFormat.format(endTime).toLowerCase();
      
      if (startDisplay.contains(':00')) startDisplay = startDisplay.replaceFirst(':00', '');
      if (endDisplay.contains(':00')) endDisplay = endDisplay.replaceFirst(':00', '');

      return '$startDisplay to $endDisplay';
    } catch (e) {
      debugPrint('Time calculation error: $e');
      return widget.gigTime;
    }
  }

  Future<void> _handleConfirm() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BookingConfirmedScreen(
          musicianName: widget.musicianName.isNotEmpty ? widget.musicianName : 'Sarah Johnson',
          gigTitle: widget.gigTitle.isNotEmpty ? widget.gigTitle : 'Jazz Night - Friday',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0F),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1F),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.chevron_left, color: Colors.white, size: 26),
          ),
        ),
        title: const Text('Payment',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stepper
              Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: Color(0xFFA2F301),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text('1',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text('Payment',
                          style: TextStyle(
                              color: Color(0xFF888888), fontSize: 11)),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.only(bottom: 20),
                      color: const Color(0xFF2A2A2F),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: Color(0xFFA2F301),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text('2',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text('Contract',
                          style: TextStyle(
                              color: Color(0xFF888888), fontSize: 11)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Contract card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1F),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Performance Agreement',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    Text(
                      'This agreement is made between ${widget.organizerName?.isNotEmpty == true ? widget.organizerName! : 'Blue Note Entertainment'} (Organizer) and ${widget.musicianName.isNotEmpty ? widget.musicianName : 'Sarah Johnson'} (Performer) for the performance at:',
                      style: const TextStyle(
                          color: Color(0xFF888888), fontSize: 13, height: 1.5),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A0A0F),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Event: ${widget.gigTitle.isNotEmpty ? widget.gigTitle : 'Jazz Night - Friday'}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text('Date: ${widget.gigDate.isNotEmpty ? widget.gigDate : 'Feb 15, 2026'}',
                              style: const TextStyle(
                                  color: Color(0xFF888888), fontSize: 13)),
                          const SizedBox(height: 4),
                          Text('Time: ${_getTimeRange()}',
                              style: const TextStyle(
                                  color: Color(0xFF888888), fontSize: 13)),
                          const SizedBox(height: 4),
                          Text('Location: ${widget.location?.isNotEmpty == true ? widget.location! : 'Blue Note Jazz Club, NYC'}',
                              style: const TextStyle(
                                  color: Color(0xFF888888), fontSize: 13)),
                          const SizedBox(height: 4),
                          Text(
                            'Compensation: \$${(widget.amount > 0 ? widget.amount : 750).toInt()}',
                            style: const TextStyle(
                                color: Color(0xFFA2F301),
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Payment will be held in escrow and released within 24 hours of successful performance completion.',
                      style: TextStyle(
                          color: Color(0xFF888888), fontSize: 13, height: 1.5),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Both parties agree to the terms and conditions outlined in this contract.',
                      style: TextStyle(
                          color: Color(0xFF888888), fontSize: 13, height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Agreement checkbox
              GestureDetector(
                onTap: () => setState(() => _agreed = !_agreed),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1F),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: _agreed
                              ? const Color(0xFFA2F301)
                              : const Color(0xFF141419),
                          border: Border.all(
                            color: _agreed
                                ? const Color(0xFFA2F301)
                                : const Color(0xFF2A2A2F),
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: _agreed
                            ? const Icon(Icons.check,
                                size: 14, color: Colors.black)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'I agree to the terms and conditions of this performance agreement and authorize the payment of \$${(widget.amount > 0 ? widget.amount : 750).toInt()} to be held in escrow.',
                          style: const TextStyle(
                              color: Color(0xFF888888),
                              fontSize: 13,
                              height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Signature
              const Text('Your Signature',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Container(
                height: 125,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1F),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text(
                    'Alex Chen',
                    style: TextStyle(
                      color: Color(0xFFA2F301),
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Digital signature • 2/6/2026',
                style: TextStyle(
                    color: Color(0xFF666666), fontSize: 11),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
            20, 12, 20, MediaQuery.of(context).padding.bottom + 16),
        child: GestureDetector(
          onTap: _handleConfirm,
          child: Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFA2F301),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Text(
                'Sign & Confirm Booking',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


