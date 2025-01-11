import 'package:fairpytasker/Component/header.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';

class ReportsView extends StatelessWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(35.0),
        child: HeaderView(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            ListTile(
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back),
              ),
              contentPadding: EdgeInsets.zero,
              title:
                  Utils.getText('Reports', size: 20, weight: FontWeight.bold),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFeaf0fa),
                    borderRadius: BorderRadius.circular(10)
                  ),
                              child: ListView.separated(
                shrinkWrap: true,
                  itemBuilder: (context, index) => ListTile(
                        title: Text("Index $index"),
                        trailing: GestureDetector(
                          onTap: () {},
                          child: Icon(Icons.download_rounded),
                        ),
                      ),
                  separatorBuilder: (context, index) => Container(
                    color: AppC.white.withValues(alpha: 0.2),
                    height: 1,
                  ),
                  itemCount: 5),
                            ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
