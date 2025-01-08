// InkWell(
//   onTapDown: (TapDownDetails? details) async {
//     await getUserGroupList(widget.todoItem!);
//
//     showObjectPopupMenuWithCheckBox(
//       /*context,*/
//         widget.todoItem!.selectedUserGroupOrUser ?? resourceList,
//         details, (resource) {
//       log('selectedResource: ${jsonEncode(resource)}');
//       userGroupConcatenationName = '';
//       userShortName = '';
//       selectedResourceIdList = getSelectedResourceList(
//           widget.todoItem!.selectedUserGroupOrUser ?? resourceList);
//       if ((selectedResourceIdList ?? []).length == 1) {
//         selectedResourceId = selectedResourceIdList![0] ?? 0;
//         userShortName = userGroupConcatenationName;
//         selectedResourceIdList = null;
//         widget.todoItem['user_group_id'] = null;
//       } else {
//         widget.todoItem['user_id'] = null;
//       }
//       setState(() {});
//     }, true);
//   },
//   child: Visibility(
//     visible:
//     true /*widget.todoItem!.users != null ||
//         widget.todoItem!.userGroupId != null*/
//     ,
//     child: (userShortName ?? '').isNotEmpty
//         ? Utils.getText(userShortName!,
//         color: AppC().base, weight: FontWeight.bold, size: 14)
//         : (userGroupConcatenationName ?? '').isNotEmpty
//         ? Utils.getText(userGroupConcatenationName!,
//         color: AppC().base,
//         weight: FontWeight.bold,
//         size: 14)
//         : Utils.getText('...',
//         color: AppC().base,
//         weight: FontWeight.bold,
//         size: 16),
//   ),
// ),
// InkWell(
//   onTapDown: (TapDownDetails? details) async {
//     await getUserGroupList(widget.todoItem);
//     showObjectPopupMenuWithCheckBox(
//       selectedUserGroupOrUser ?? resourceList,
//       details,
//           (resource) {
//         log('selectedResource: ${jsonEncode(resource)}');
//         userGroupConcatenationName = '';
//         userShortName = '';
//         selectedResourceIdList =
//             getSelectedResourceList(selectedUserGroupOrUser ?? resourceList)
//                 .cast<int?>();
//         if ((selectedResourceIdList ?? []).length == 1) {
//           selectedResourceId = selectedResourceIdList![0] ?? 0;
//           userShortName = userGroupConcatenationName;
//           selectedResourceIdList = null;
//           widget.todoItem['user_group_id'] = null;
//         } else {
//           widget.todoItem['user_id'] = null;
//         }
//         setState(() {});
//       },
//       true,
//     );
//   },
//   child: (userShortName ?? '').isNotEmpty
//       ? Expanded(
//         child: Utils.getText(
//                         userShortName!,
//                         color: AppC().base,
//                         weight: FontWeight.bold,
//                         size: 14,
//                         overFlow: TextOverflow.ellipsis,
//                       ),
//       )
//       : (userGroupConcatenationName ?? '').isNotEmpty
//       ? Expanded(
//         child: Utils.getText(
//                         userGroupConcatenationName!,
//                         color: AppC().base,
//                         weight: FontWeight.bold,
//                         overFlow: TextOverflow.ellipsis,
//                         size: 14,
//                       ),
//       )
//       : Utils.getText(
//     '...',
//     color: AppC().base,
//     weight: FontWeight.bold,
//     overFlow: TextOverflow.ellipsis,
//     size: 16,
//   ),
// ),