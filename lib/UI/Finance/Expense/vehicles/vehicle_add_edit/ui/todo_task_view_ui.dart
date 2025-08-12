part of 'vehicle_add_edit_main_ui.dart';

class TodoTaskViewUI extends StatelessWidget {
 final dynamic todoDetails;
  const TodoTaskViewUI({super.key, required this.todoDetails,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(todoDetails?['title'] ?? ''),
        foregroundColor: AppC.white,
        backgroundColor:todoDetails?['status'] == 'In Progress'? AppC.appColor: AppC.green,
        automaticallyImplyLeading: false,
        titleTextStyle: const TextStyle(
          color: AppC.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Utils.getText(
              "TODO DETAILS",
              weight: FontWeight.bold,
              size: 16,
            ),
            10.height,
            Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconAndText(
                    icon: Icons.date_range,
                    label: "${todoDetails['date_time'] ?? ''}",
                ),
                IconAndText(
                  icon: Icons.person,
                  label: todoDetails['user'],
                ),
                IconAndText(
                  icon: Icons.directions_car_filled,
                  label: todoDetails['vehicle'] ?? '',
                ),
                if(todoDetails['vendor'] != null)
                  IconAndText(
                    icon: Icons.person_pin_outlined,
                    label: "${todoDetails['vendor'] ?? ''}",
                  ),
                if (todoDetails['notes'] != null)
                  IconAndText(
                    icon: Icons.speaker_notes,
                    label: (todoDetails['notes'] ?? '').toString().removeHtmlTags,
                  ),
                if (List.from(todoDetails?['parts']).isNotEmpty)
                  ChoiceBoxWidget<String>(
                      bgColor: AppC.lightGreen,
                      items: (List<String>.from(todoDetails?['parts']))
                          .distinct((e) => e),
                      itemAsString: (item) => item.toString()),
                if (List.from(todoDetails?['supplies']).isNotEmpty)
                  ChoiceBoxWidget<String>(
                      bgColor: AppC.lightGreen,
                      items: (List<String>.from(todoDetails?['supplies']))
                          .distinct((e) => e),
                      itemAsString: (item) => item.toString()),
                IconAndText(
                  icon: Icons.speed,
                  label: "${todoDetails?['odometer'] ?? "No Odometer"}",
                ),
                if (todoDetails?['reference_id'] != null)
                InkWell(
                  onTap:()=> Utils.openURL(todoDetails['reference_id'].toString().toTuroReserveUrl),
                    child: Utils.getText('Reservation No - ${todoDetails['reference_id'] ?? ''}', color: AppC.redAccent)),

                Utils.getText(
                  "Expense",
                  weight: FontWeight.bold,
                  size: 16,
                  color: AppC.appColor,
                ),
                IconAndText(
                  icon: Icons.monetization_on_outlined,
                  label: "${todoDetails['amount'] ?? ''}",
                ),
                IconAndText(
                  icon: Icons.speaker_notes_outlined,
                  label: (todoDetails['description'] ?? '').toString().removeHtmlTags,
                ),
                IconAndText(
                  icon: Icons.category,
                  label: "${todoDetails['category'] ?? ''}",
                ),
                IconAndText(
                  icon: Icons.category_outlined,
                  label: "${todoDetails['sub_category'] ?? ''}",
                ),
                const Icon(Icons.attachment_outlined),
                if (List.from(todoDetails?['attachment']).isNotEmpty)
                  ImageUploadSection(
                    title: '',
                    borderColor: Colors.blue,
                    onRemove: (file){},
                    images: List.from(todoDetails?['attachment']),
                    logName: "expenseAttachmentsEvent",
                    isRequired: false,
                    isDeleteIcon: false,
                    showDownload: true,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
