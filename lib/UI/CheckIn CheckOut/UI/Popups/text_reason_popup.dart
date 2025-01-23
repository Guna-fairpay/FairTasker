import 'package:fairpytasker/Component/reason_divider.dart';
import 'package:flutter/material.dart';

class TextPopupReason {
  static void show(BuildContext context, Map<String, dynamic> data) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Stack(
          children: [
            Positioned(
              top: 50, // Adjust the position from the top
              left: 16, // Add padding from the left
              right: 16, // Add padding from the right
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Close button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Icon(Icons.close, size: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Date
                      Text(
                        data['date'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Check-in Reason

                      if ((data['checkin_reason'] is List) && (data['checkin_reason'] as List).isNotEmpty)
                        ...(data['checkin_reason'] as List).map((e) => ReasonDivider(
                          child: Text.rich(TextSpan(
                            text: "Check-in Reason: ",
                            children: [
                              TextSpan(text: "$e",style: const TextStyle(fontSize: 14,fontWeight: FontWeight.normal),)
                            ]
                          ),
                            style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                          ),
                        ),
                        ).toList(),
                      // Check-out Reason
                      if ((data['checkout_reason'] is List) && (data['checkout_reason'] as List).isNotEmpty)
                        ...(data['checkout_reason'] as List).map((e) => ReasonDivider(
                          child: Text.rich(
                            TextSpan(
                                text: "Check-out Reason: ",
                                children: [
                                  TextSpan(text: "$e",style: const TextStyle(fontSize: 14,fontWeight: FontWeight.normal),)
                                ]
                            ),
                            style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                          ),
                        ),).toList()

                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
