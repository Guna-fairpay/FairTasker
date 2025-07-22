import 'package:fairpytasker/UI/Finance/Expense/component/icon_and_text.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

class AgreementStatusList extends StatelessWidget {
  const AgreementStatusList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionTile(
          childrenPadding: 5.horizontalPadding,
          tilePadding: 5.horizontalPadding,
          expansionAnimationStyle: const AnimationStyle(
            curve: Curves.fastOutSlowIn,
            duration: Duration(milliseconds: 350),
          ),
          title: const Text('# 775859 Canceled'),

          shape: ContinuousRectangleBorder(side: const BorderSide(color: AppC.grey), borderRadius: BorderRadius.circular(20)),
          collapsedShape: ContinuousRectangleBorder(side: const BorderSide(color: AppC.grey), borderRadius: BorderRadius.circular(20)),
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: FittedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          IconAndText(icon: Remix.user_fill, label: 'text', iconColor: AppC.appColor, padding: 0.padding, isExpanded: false),
                          IconAndText(icon: Remix.mail_fill, label: 'text', iconColor: AppC.appColor, padding: 0.padding, isExpanded: false),
                          const Text.rich(
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            TextSpan(
                              children: [
                                TextSpan(text: 'Booked On: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: '05-07-25'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Flexible(
                    child: FittedBox(
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            overflow: TextOverflow.ellipsis,
                            TextSpan(
                              children: [
                                TextSpan(text: 'From: ' , style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: '05-07-25 '),
                                TextSpan(text: '08:00 AM',),
                              ],
                            ),
                          ),
                          Text.rich(
                            overflow: TextOverflow.ellipsis,
                            TextSpan(
                              children: [
                                TextSpan(text: 'Till: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: '05-07-25 '),
                                TextSpan(text: '08:00 AM',),
                              ],
                            ),
                          ),
                          Text.rich(
                            overflow: TextOverflow.ellipsis,
                            TextSpan(
                              children: [
                                TextSpan(text: 'Total: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: '\$100'),
                              ],
                            ),
                          ),
                        ],),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
