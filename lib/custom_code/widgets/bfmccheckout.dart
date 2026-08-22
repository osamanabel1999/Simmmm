// Automatic FlutterFlow imports
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:google_fonts/google_fonts.dart';

class Bfmccheckout extends StatefulWidget {
  const Bfmccheckout({
    super.key,
    this.width,
    this.height,
    required this.onPayPressed,
    required this.onPrivacyPressed,
    required this.onContactPressed,
    required this.onAboutPressed,
    required this.onRefundPressed,
  });

  final double? width;
  final double? height;
  final Future Function() onPayPressed;
  final Future Function() onPrivacyPressed;
  final Future Function() onContactPressed;
  final Future Function() onAboutPressed;
  final Future Function() onRefundPressed;

  @override
  State<Bfmccheckout> createState() => _BfmccheckoutState();
}

class _BfmccheckoutState extends State<Bfmccheckout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      color: const Color(0xFF14181B),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24, 60, 24, 40),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0x332ECC71),
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: const Color(0xFF2ECC71), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'OFFER: 30% DISCOUNT APPLIED',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF2ECC71),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Simulator Station Pro',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0x0DFFFFFF),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0x1AFFFFFF)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '499.00',
                                style: GoogleFonts.inter(
                                  color: const Color(0x80FFFFFF),
                                  fontSize: 18,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '349.00 EGP',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'One-time payment for full access',
                            style: GoogleFonts.inter(
                                color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // القائمة النهائية للمميزات مع دعم Zibo Mod
                  // القائمة النهائية للمميزات (7 جمل احترافية)
                  _featureItem('Full Aircraft Movement Control'),
                  _featureItem('Interactive AI Virtual Co-Pilot'),
                  _featureItem('Smart Briefing & Dynamic Checklists'),
                  _featureItem('Real-time Performance & Weather Tools'),
                  _featureItem('Advanced Systems Failure Training'),
                  _featureItem('Full Zibo 737 FMC Compatibility'),
                  _featureItem('Supports X-Plane 11 & 12 Pro'),

                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () async => await widget.onPayPressed(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2ECC71),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                        'CONFIRM & PAY NOW',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 15,
                    runSpacing: 10,
                    children: [
                      _footerBtn('About Us', widget.onAboutPressed),
                      _footerBtn('Contact Us', widget.onContactPressed),
                      _footerBtn('Privacy Policy', widget.onPrivacyPressed),
                      _footerBtn('Refund Policy', widget.onRefundPressed),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF2ECC71), size: 20),
          const SizedBox(width: 12),
          Text(text,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _footerBtn(String label, Future Function() action) {
    return InkWell(
      onTap: () async => await action(),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: Colors.grey,
          fontSize: 11,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
