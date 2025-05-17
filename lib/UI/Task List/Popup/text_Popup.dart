
import 'package:flutter/material.dart';

import '../../../Utilities/appC.dart';

class TextPopupTask {
  static void show(BuildContext context, String text) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Stack(
          children: [
            Positioned(
              top: 25, // Adjust the position from the top
              left: 0, // Start from the left edge
              right: 0, // End at the right edge
              child: Material(
                color: Colors.transparent, // Make background transparent
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
                  margin: const EdgeInsets.symmetric(horizontal: 16), // Add margin for a clean edge
                  child:
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text("Reason",style: TextStyle(color: AppC.appColor,
                                fontWeight: FontWeight.bold,
                            fontSize: 16),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Icon(Icons.close, size: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              text,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          const Expanded(
                            child: Text(""),
                          ),
                        ],
                      ),
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

  // static void show(BuildContext context, String text){
  //   AlertDialog(
  //     alignment: Alignment.topCenter,
  //     shape: ContinuousRectangleBorder(
  //         borderRadius: BorderRadius.circular(Num.borderRadiusXLarge)),
  //     backgroundColor: AppC.white,
  //     title: ListTile(leading: GestureDetector(
  //         onTap: context.popDialog,child: Icon(Icons.close,color: AppC.appColor)),),
  //     content: Utils.getText(text),
  //   );
  // }
}