import 'package:flutter/material.dart';
import '../../../Utilities/Utils.dart';
import '../../../Utilities/appC.dart';

class ByDayComponent extends StatelessWidget {
  final String? vehicleName;
  final String? title;
  final String? imageUrl;
  final String? time;
  final String? resource;
  final String? notes;
  final String? vendorName;

  const ByDayComponent({
    Key? key,
    this.vehicleName,
    this.title,
    this.imageUrl,
    this.time,
    this.resource,
    this.notes,
    this.vendorName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(imageUrl ?? 'https://img.icons8.com/?size=100&id=122635&format=png&color=000000'),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppC.grey,
                    width: 1.0,
                  ),
                )
              ),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('${title ?? ''}',
                    style: const TextStyle(fontWeight: FontWeight.bold,color: AppC.appColor,)),
                subtitle: SizedBox(
                  width: 100,
                  child: Column(
                    spacing: 4,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Utils.getText("${vehicleName ?? ''}",),
                    Row(
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Utils.getText("${vendorName ?? ''}",overFlow: TextOverflow.ellipsis),
                        if(notes != null && notes!.isNotEmpty && notes != '')...[
                          Expanded(child: Utils.getText("(${notes ?? ''})",color: AppC.appColor,overFlow: TextOverflow.ellipsis))
                        ] else...[
                          SizedBox()
                        ],
                      ],
                    )
                  ]),
                ),
                trailing: Column(
                  spacing: 2,
                  children:[
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        '${time ?? ''}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      '${resource ?? ''}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppC.appColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}