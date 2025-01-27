

import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:fairpytasker/UI/Finance/Expense/Person/person_expense_edit_ui.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Event/todo_view_event.dart';
import '../../../../Utilities/Str.dart';
import '../../../../Utilities/appC.dart';
import '../../../../Utilities/num.dart';
import 'person_expense_add_ui.dart';

class PersonExpenseViewUI extends StatefulWidget {
  const PersonExpenseViewUI({Key? key}) : super(key: key);

  @override
  State<PersonExpenseViewUI> createState() => _PersonExpenseViewUIState();
}

class _PersonExpenseViewUIState extends State<PersonExpenseViewUI> {

  double _rotationAngle = 0.0;
  bool loading = false;
  final TextEditingController _dateRangeController = TextEditingController();
  DateRange? selectedDateRange;
  List<Map<String, dynamic>> personList = [];
  dynamic totalExpenseAmount;

  @override
  void initState() {
    super.initState();
    // Set up the selected date range (last 7 days by default)
    DateTime now = DateTime.now();
    selectedDateRange = DateRange(
      now.subtract(const Duration(days: 7)),
      now,
    );
  }

  void _navigateToTaskAddUI() async {
    final newPersonList = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const ExpensePersonAddUi()),
    );
    print(newPersonList);
    if (newPersonList != null) {
      setState(() {
        personList.add(newPersonList);
      });
    }
  }


  void _showImageDialog(BuildContext context, List<String> imagePaths, List<String> imageNames) {
    ValueNotifier<int> currentIndex = ValueNotifier<int>(0); // Tracks the current index
    PageController pageController = PageController(initialPage: 0);
    ValueNotifier<double> rotationAngle = ValueNotifier(0.0);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              children: [
                // Top Row: Image Name and Close Button
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ValueListenableBuilder<int>(
                        valueListenable: currentIndex,
                        builder: (context, value, _) {
                          return Text(
                            imageNames[value], // Display dynamic image name
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          );
                        },
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        icon: const Icon(Icons.close),
                        color: Colors.red,
                        tooltip: 'Close',
                      ),
                    ],
                  ),
                ),
                // Main Content: PageView with Image and Rotation
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: imagePaths.length,
                    onPageChanged: (index) {
                      currentIndex.value = index; // Update current index
                      rotationAngle.value = 0.0; // Reset rotation on page change
                    },
                    itemBuilder: (context, index) {
                      final String fullImageUrl = Str.STORAGE_BASE_URL + imagePaths[index];
                      return Center(
                        child: ValueListenableBuilder<double>(
                          valueListenable: rotationAngle,
                          builder: (context, angle, _) {
                            return Transform.rotate(
                              angle: angle,
                              child: PhotoView(
                                imageProvider: NetworkImage(fullImageUrl),
                                backgroundDecoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 8,),
                // Page Indicator
                SmoothPageIndicator(
                  controller: pageController,
                  count: imagePaths.length,
                  effect: const JumpingDotEffect(
                    spacing: 8.0,
                    radius: 8.0,
                    dotWidth: 10.0,
                    dotHeight: 10.0,
                    paintStyle: PaintingStyle.fill,
                    strokeWidth: 1.5,
                    dotColor: Colors.grey,
                    activeDotColor: Colors.indigo,
                  ),
                ),

                // Control Buttons: Fullscreen and Rotate
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Fullscreen Button
                    IconButton(
                      icon: const Icon(Icons.fullscreen),
                      onPressed: () {
                        final List<String> imageUrls = imagePaths; // Replace with your image URLs
                        final int initialIndex = 0; // Or any index from your list
                        _showFullScreenImage(context, imageUrls, initialIndex);
                      },
                    )
                    ,

                    // Rotate Button
                    IconButton(
                      onPressed: () {
                        rotationAngle.value += 3.14159265359 / 2; // Rotate 90°
                        if (rotationAngle.value >= 2 * 3.14159265359) {
                          rotationAngle.value = 0.0; // Reset after 360°
                        }
                      },
                      icon: const Icon(Icons.autorenew),
                      tooltip: 'Rotate 90°',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Fullscreen Image Viewer
  void _showFullScreenImage(BuildContext context, List<String> imageUrls, int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: Center(
            child: PageView.builder(
              itemCount: imageUrls.length,
              controller: PageController(initialPage: initialIndex),
              itemBuilder: (context, index) {
                final imageUrl = Str.STORAGE_BASE_URL + imageUrls[index];
                return PhotoView(
                  imageProvider: NetworkImage(imageUrl),
                  backgroundDecoration: const BoxDecoration(color: Colors.black),
                );
              },
            ),
          ),
        ),
      ),
    );
  }





  void _navigateToTaskEditUI(int index) async {
    final updatedPerson = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => ExpensePersonEditUi(existingData: personList[index]),
      ),
    );
    if (updatedPerson != null) {
      setState(() {
        personList[index] = updatedPerson;
      });
    }
  }

  // Date Picker Builder
  Widget datePickerBuilder(BuildContext context, dynamic Function(DateRange?) onDateRangeChanged, [bool doubleMonth = false]) {
    return DateRangePickerWidget(
      doubleMonth: doubleMonth,
      initialDateRange: selectedDateRange,
      initialDisplayedDate: selectedDateRange?.start ?? DateTime.now(),
      onDateRangeChanged: onDateRangeChanged,
      height: 340,
      displayMonthsSeparator: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Initialize the ExpensePersonBloc inside BlocProvider
    return BlocProvider(
      create: (context) => TodoViewBloc()..add(GetExpensePersonData(
        minDate: selectedDateRange!.start.toIso8601String(),
        maxDate: selectedDateRange!.end.toIso8601String(),
      )), // Dispatch event immediately
      child: Scaffold(
        backgroundColor: AppC.white,
        body: BlocListener<TodoViewBloc, TodoViewState>(
          listener: (context, state) {
            if (state is TodoListLoading) {
              setState(() {
                loading = true;
              });
            } else if (state is ExpensePersonLoaded) {
              setState(() {
                loading = false;
                personList = state.data;
                totalExpenseAmount=state.totalExpensesAmount;
                //print("filtered person $personList");
                //print("Image path--------- $personList['attachments']['path']");
              });
            } else {
              setState(() {
                loading = false;
              });
            }
          },
          child: BlocBuilder<TodoViewBloc, TodoViewState>(
            builder: (context, state) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Date Picker Input Box
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: 40,
                                child: DateRangeField(
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(Num.subradiusButton),
                                    ),
                                    label: Utils.getText('Date Range', color: AppC.grey),
                                  ),
                                  selectedDateRange: selectedDateRange,
                                  onDateRangeSelected: (DateRange? value) {
                                    setState(() {
                                      selectedDateRange = value;
                                      String startDate = selectedDateRange!.start.toString();
                                      String endDate = selectedDateRange!.end.toString();
                                      context.read<TodoViewBloc>().add(GetExpensePersonData(minDate: startDate, maxDate: endDate));
                                    });
                                  },
                                  pickerBuilder: (context, onDateRangeChanged) => datePickerBuilder(context, onDateRangeChanged),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Add Button
                            GestureDetector(
                              onTap: () {
                                _navigateToTaskAddUI();
                              },
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppC.appColor,
                                ),
                                child: const Icon(Icons.add, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 20),

                            // Total Amount
                            Utils.getText(
                              'Total: \$${totalExpenseAmount ?? ''}',
                              color: AppC.appColor,
                              weight: FontWeight.bold,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        // Itemized Rows in ListView.builder
                        Expanded(
                          child: ListView.builder(
                            itemCount: personList.length,
                            itemBuilder: (context, index) {
                              final item = personList[index];
                              bool isChecked = (item['approved'] == 1);
                              return Slidable(
                                endActionPane: ActionPane(
                                  motion: const DrawerMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) {
                                        setState(() {
                                          personList.removeAt(index); // Handle delete
                                        });
                                      },
                                      backgroundColor: AppC.white,
                                      foregroundColor: AppC.red,
                                      icon: Icons.delete_outline,
                                      label: 'Delete',
                                    ),
                                  ],
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    _navigateToTaskEditUI(index);
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(vertical: 6),
                                    color: AppC.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              // Date
                                              Utils.getText(
                                                item['expense_date']?.substring(5) ?? '',
                                                color: item['approved'] == 0
                                                    ? AppC.redAccent
                                                    : AppC.appColor,
                                              ),
                                              const SizedBox(width: 10),
                                              // Full Name
                                              Expanded(
                                                child: Utils.getText(
                                                  item['employee_name'].toString(),
                                                  weight: FontWeight.bold,
                                                  color: item['approved'] == 0
                                                      ? AppC.redAccent
                                                      : AppC.appColor,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              if (item['attachments'] != null && item['attachments'].isNotEmpty)
                                              GestureDetector(
                                                onTap: (){
                                                  final List<dynamic> attachments = item['attachments'];
                                                  if (attachments.isNotEmpty) {
                                                    // Extract all paths into a list
                                                    final List<String> paths = attachments
                                                        .map((attachment) => attachment['path'] as String)
                                                        .toList();
                                                    final List<String> imageNames = attachments
                                                        .map((attachment) => attachment['name'] as String)
                                                        .toList();

                                                    // Call the dialog function with the list of paths and names
                                                    _showImageDialog(context, paths, imageNames);
                                                  } else {
                                                    print("No attachments found.");
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.visibility,
                                                  color: item['approved'] == 0 ? AppC.redAccent : AppC.appColor,
                                                  size: 17,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              // Initials
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  // Initials from the name
                                                  Utils.getText(
                                                    '${item['employee_name']?.split(' ').map((word) => word[0]).join() ?? ''}',
                                                    weight: FontWeight.bold,
                                                    color: item['approved'] == 0 ? AppC.redAccent : AppC.appColor,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Utils.getText(
                                                    '\$${item['expense_amount'].toString() ?? '0.00'}',
                                                    weight: FontWeight.bold,
                                                    color: item['approved'] == 0 ? AppC.redAccent : AppC.appColor,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          // Categories, Checkbox, and Amount
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Utils.getText(
                                                    item['category']['name'].toString() ?? '',
                                                    color: Colors.grey,
                                                    overFlow: TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Utils.getText("|", size: 15, color: Colors.grey),
                                                  const SizedBox(width: 5),
                                                  Utils.getText(
                                                    item['subcategory']['name'].toString() ?? '',
                                                    color: Colors.grey,
                                                    overFlow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 5,
                                                        height: 10,
                                                        child: Checkbox(
                                                          activeColor: AppC.appColor,
                                                          value: isChecked,
                                                          onChanged: (bool? value) {
                                                            setState(() {
                                                              isChecked = value ?? false;
                                                              item['approved'] = isChecked ? 1 : 0;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(width: 15),
                                                    ],
                                                  ),
                                                  Utils.getText(
                                                    '\$${totalExpenseAmount ?? ''}',
                                                    color: Colors.grey,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                      visible: loading,
                      child: Center(child: Utils.getProgressIndicator(context)))
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
