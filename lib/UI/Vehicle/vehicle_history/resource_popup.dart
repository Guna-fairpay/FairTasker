import 'dart:convert';
import 'package:flutter/material.dart';

import '../../../Utilities/Utils.dart';
import '../../../Utilities/appC.dart';

class UserGroupWidget extends StatelessWidget {
  final Map<String, dynamic> todos;
  final Function(String val)? onPressed;
  final List<Map<String, dynamic>> userGroupList;
  final List<Map<String, dynamic>> resourceList;

  const UserGroupWidget({
    Key? key,
    required this.todos,
    this.onPressed,
    required this.userGroupList,
    required this.resourceList,
  }) : super(key: key);

  String getInitials(String? firstName, String? lastName) {
    return '${firstName?[0].toUpperCase() ?? ''}${lastName?[0].toUpperCase() ?? ''}';
  }

  @override
  Widget build(BuildContext context) {
    String userGroupConcatenationName = '';
    List<String> userInitials = [];

    if (todos['users'] != null) {
      String userShortName = getInitials(
        todos['users']?['first_name'],
        todos['users']?['last_name'],
      );

      return Utils.getText(
        userShortName,
        color: AppC().base,
        weight: FontWeight.bold,
      );
    } else {
      for (Map<String, dynamic> group in userGroupList) {
        if (group['id'] == todos['user_group_id']) {
          List<dynamic> userList = [];
          try {
            userList = json.decode(group['userId'] ?? '[]');
          } catch (_) {
            continue;
          }

          for (Map<String, dynamic> res in resourceList) {
            if (userList.contains(res['id'])) {
              String initials = getInitials(
                res['first_name'],
                res['last_name'],
              );
              userInitials.add(initials);
            }
          }
          break;
        }
      }

      if (userInitials.isNotEmpty) {
        userGroupConcatenationName = (userInitials.length > 1)
            ? "${userInitials.first}..."
            : userInitials.join(',');
      }

      return InkWell(
        onTapDown: (TapDownDetails details) async {
          final value = userInitials.join(',');
          showMenu(
            context: context,
            position: RelativeRect.fromLTRB(
              details.globalPosition.dx,
              details.globalPosition.dy,
              MediaQuery.of(context).size.width - details.globalPosition.dx,
              MediaQuery.of(context).size.height - details.globalPosition.dy,
            ),
            items: [
              PopupMenuItem<String>(
                value: value,
                child: Text(value),
              ),
            ],
          );
        },
        child: Utils.getText(
          align: TextAlign.end,
          userGroupConcatenationName,
          color: AppC().base,
          weight: FontWeight.bold,
          overFlow: TextOverflow.ellipsis,
        ),
      );
    }
  }
}
