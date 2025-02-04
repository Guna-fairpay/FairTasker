import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import '../../../Utilities/appC.dart';

class  OilChangeCheckCompleteDialog{
  OilChangeCheckCompleteDialog._();

  static final OilChangeCheckCompleteDialog instance = OilChangeCheckCompleteDialog._();

  void show(BuildContext context) async {
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => DialogView());
  }
}

class DialogView extends StatelessWidget {
  const DialogView({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        insetPadding: const EdgeInsets.all(10),
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        backgroundColor: AppC.white,
        alignment: Alignment.topCenter,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          minTileHeight: 0,
          dense: true,
          horizontalTitleGap: 0,
          trailing: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
        ),
        elevation: 5,
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Utils.getText("Yesterday Hours Summary",size: 20),
              const SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(child: Column(
                    children: [
                      Utils.getText("00:00", weight: FontWeight.bold,size: 32,color: AppC.red),
                      Utils.getText("Idle Time", weight: FontWeight.bold,),
                      const SizedBox(height: 10,),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text.rich(TextSpan(children: [
                            TextSpan(
                                text: 'Checkin ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            TextSpan(
                                text: '00:00',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, color: AppC.green))
                          ]
                          )
                          ),
                        ],
                      ),


                    ],
                  )),
                  Expanded(child: Column(
                    children: [
                      Utils.getText("00:30", weight: FontWeight.bold,size: 32,color: AppC.green),
                      Utils.getText("Total Active Hours", weight: FontWeight.bold,),
                      10.height,
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text.rich(TextSpan(children: [
                            TextSpan(
                                text: 'Checkout ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            TextSpan(
                                text: '00:00',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, color: AppC.red))
                          ]
                          )
                          ),
                        ],
                      ),
                    ],
                  )
                  )
                ],
              ),
              // post cars
              // 1 (ListTile)
              // 2 (ListTile)
              /*minTileHeight: 0,
              dense: true,
              horizontalTitleGap: 0,*/
              Column(
                children: [
                  ListTile(leading: Utils.getText("PostCar",color: AppC.appColor), trailing: Utils.getText("00:15",),
                    contentPadding: EdgeInsets.zero,),
                ],
              )
            ],
          ),
        ));
  }
}

