import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../models/profile_status_model.dart';

class ProfileCompleteDialog extends StatelessWidget {
  final ProfileStatusModel profileStatus;
  final VoidCallback onSkip;
  final VoidCallback onGoToProfile;

  const ProfileCompleteDialog({
    super.key,
    required this.profileStatus,
    required this.onSkip,
    required this.onGoToProfile,
  });

  @override
  Widget build(BuildContext context) {
    final String profileStatusText =
        profileStatus.profileStatus;

    final String deduction =
        profileStatus.deduction;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              14,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ------------------------------------------------
                // TOP HANDLE
                // ------------------------------------------------

                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius:
                    BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 12),

                // ------------------------------------------------
                // ANIMATION
                // ------------------------------------------------

                SizedBox(
                  height: 130,
                  width: 130,
                  child: Lottie.asset(
                    'assets/shopper_profile_anim.json',
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 4),

                // ------------------------------------------------
                // TITLE
                // ------------------------------------------------

                const Text(
                  "You're almost there!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF222222),
                  ),
                ),

                const SizedBox(height: 12),

                // ------------------------------------------------
                // MESSAGE
                // ------------------------------------------------

                _buildMessage(
                  profileStatusText,
                  deduction,
                ),

                const SizedBox(height: 20),

                // ------------------------------------------------
                // BUTTONS
                // ------------------------------------------------

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onSkip,
                        style: OutlinedButton.styleFrom(
                          minimumSize:
                          const Size.fromHeight(46),
                          side: const BorderSide(
                            color: Color(0xFF00407E),
                          ),
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'SKIP',
                          style: TextStyle(
                            color: Color(0xFF00407E),
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: onGoToProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color(0xFF00407E),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          minimumSize:
                          const Size.fromHeight(46),
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'GO TO PROFILE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessage(
      String profileStatusText,
      String deduction,
      ) {
    return Text.rich(
      TextSpan(
        style: const TextStyle(
          fontSize: 15,
          height: 1.5,
          color: Color(0xFF555555),
        ),
        children: [
          const TextSpan(
            text: "You've completed ",
          ),

          TextSpan(
            text: profileStatusText,
            style: const TextStyle(
              color: Color(0xFFF47320),
              fontWeight: FontWeight.w700,
            ),
          ),

          const TextSpan(
            text:
            " of your profile. Complete it to ",
          ),

          const TextSpan(
            text: "100%",
            style: TextStyle(
              color: Color(0xFFF47320),
              fontWeight: FontWeight.w700,
            ),
          ),

          const TextSpan(
            text:
            " and unlock an extra ",
          ),

          TextSpan(
            text: deduction,
            style: const TextStyle(
              color: Color(0xFFF47320),
              fontWeight: FontWeight.w700,
            ),
          ),

          const TextSpan(
            text:
            " audit value as a reward.\nEnhance your profile today and maximize your benefits!",
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}