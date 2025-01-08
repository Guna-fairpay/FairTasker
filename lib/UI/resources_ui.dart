import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/material.dart';

// Color selectedColor = const Color(0xff669833);
class ResourcesUI extends StatefulWidget {
  const ResourcesUI({Key? key}) : super(key: key);

  @override
  State<ResourcesUI> createState() => _ResourcesUIState();
}

class _ResourcesUIState extends State<ResourcesUI> {
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: AppC.white,
          title: Utils.getText('Resources', size: 18, weight: FontWeight.w700)),
      body: SafeArea(
          child: Container(
        color: AppC.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    //  await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TodoViewUI()));

                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Card(
                    shadowColor: AppC.white,
                    surfaceTintColor: AppC.white,
                    color: AppC.white,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: AppC().base.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 15),
                      child: Row(
                        children: [
                          Icon(Icons.person, color: AppC().base, size: 26),
                          const SizedBox(
                            width: 18,
                          ),
                          Utils.getText('Employees',
                              size: 16, weight: FontWeight.w400)
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  shadowColor: AppC.white,
                  surfaceTintColor: AppC.white,
                  color: AppC.white,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: AppC().base.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 15),
                    child: Row(
                      children: [
                        Icon(Icons.menu, color: AppC().base, size: 26),
                        const SizedBox(
                          width: 18,
                        ),
                        Utils.getText('Departments',
                            size: 16, weight: FontWeight.w400)
                      ],
                    ),
                  ),
                ),
                Card(
                  shadowColor: AppC.white,
                  surfaceTintColor: AppC.white,
                  color: AppC.white,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: AppC().base.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 15),
                    child: Row(
                      children: [
                        Icon(Icons.manage_accounts,
                            color: AppC().base, size: 26),
                        const SizedBox(
                          width: 18,
                        ),
                        Utils.getText('Roles',
                            size: 16, weight: FontWeight.w400)
                      ],
                    ),
                  ),
                ),
                Card(
                  shadowColor: AppC.white,
                  surfaceTintColor: AppC.white,
                  color: AppC.white,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: AppC().base.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 15),
                    child: Row(
                      children: [
                        Icon(Icons.vpn_key, color: AppC().base, size: 26),
                        const SizedBox(
                          width: 18,
                        ),
                        Utils.getText('Permissions',
                            size: 16, weight: FontWeight.w400)
                      ],
                    ),
                  ),
                ),
                Card(
                  shadowColor: AppC.white,
                  surfaceTintColor: AppC.white,
                  color: AppC.white,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: AppC().base.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 15),
                    child: Row(
                      children: [
                        Icon(Icons.watch_later_rounded,
                            color: AppC().base, size: 26),
                        const SizedBox(
                          width: 18,
                        ),
                        Utils.getText('Leave management',
                            size: 16, weight: FontWeight.w400)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
