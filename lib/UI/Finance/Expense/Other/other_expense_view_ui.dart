
import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:photo_view/photo_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../Bloc/todo_view_bloc.dart';
import '../../../../../Event/todo_view_event.dart';
import '../../../../../Utilities/Str.dart';
import '../../../../../Utilities/appC.dart';
import '../../../../../Utilities/num.dart';
import 'other_expense_add_ui.dart';
import 'other_expense_edit_ui.dart';

class OtherExpenseViewUI extends StatefulWidget {
  const OtherExpenseViewUI({
    Key? key,
  }) : super(key: key);

  @override
  State<OtherExpenseViewUI> createState() => _OtherExpenseViewUIState();
}

class _OtherExpenseViewUIState extends State<OtherExpenseViewUI> {
  late TodoViewBloc expenseBloc;
  DateRange? selectedDateRange;
  DateRange? startDate;
  DateRange? endDate;
  List<Map<String, dynamic>> personList = [];
  dynamic totalExpenseAmount;
  bool loading = false;


  @override
  void initState()
  {
    expenseBloc=TodoViewBloc();
    DateTime now = DateTime.now();
    selectedDateRange = DateRange(
      now.subtract(const Duration(days: 7)),
      now,
    );
    FBroadcast.instance().register("saved", (value, callback) => print("TRIGGERED"));
    super.initState();
  }

  @override
  void dispose()
  {
    expenseBloc.close();
    super.dispose();
  }

//Add Otherui
  void _navigateToTaskAddUI() async
  {
    final newPersonList = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) =>  const OtherAddUi()),
    );
    if (newPersonList != null)
    {
      expenseBloc.add(AddOtherData(
          expenseDate: newPersonList['expense_date']
              .toString()
              .split('-')
              .reversed
              .join('-'),
          expenseAmount: newPersonList['expense_amount'],
          categoryId: (newPersonList['category_id']).toString(),
          subcategoryId: (newPersonList['subcategory_id']).toString(),
          approved: newPersonList['approved'],
          expenseDescription: newPersonList['expense_description'].toString(),
          expenseTo: newPersonList['expense_to'],
          paymentId: newPersonList['payment_method_id'],
          id: newPersonList['id']));
      Utils.showMobileToast('Other Expense added successfully');
      expenseBloc.add(GetExpenseOtherData(minDate: selectedDateRange!.start.toString(),maxDate:  selectedDateRange!.end.toString(),));
    }
  }
  //Edit Otherui
  void _navigateToTaskEditUI(int index) async {
    // Passing the correct data (existingData) to OtherEditUi
    final updatedPerson = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => OtherEditUi(existingData: personList[index]),
      ),
    );

    if (updatedPerson != null) {
      expenseBloc.add(AddOtherData(
          expenseDate: updatedPerson['expense_date'],
          expenseAmount: updatedPerson['expense_amount'],
          categoryId: updatedPerson['category_id'].toString(),
          subcategoryId: updatedPerson['subcategory_id'].toString(),
          approved: updatedPerson['approved'],
          expenseDescription: updatedPerson['expense_description'].toString(),
          expenseTo:updatedPerson['expense_to'],
          paymentId: updatedPerson['payment_method_id'],
          id: updatedPerson['id']));
      Utils.showMobileToast('Other Expense updated successfully');
      expenseBloc.add(GetExpenseOtherData(minDate: selectedDateRange!.start.toString(),maxDate:  selectedDateRange!.end.toString(),));
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
                /// COMMENTED DUE TO LIBRARY REMOVED BY PRABHU CHANDRAN (NEED CLARIFICATION ON THIS LIBRARY photo_view)
                /*Expanded(
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
                ),*/
                const SizedBox(height: 8,),
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
                        const int initialIndex = 0; // Or any index from your list
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
                // return PhotoView(
                //   imageProvider: NetworkImage(imageUrl),
                //   backgroundDecoration: const BoxDecoration(color: Colors.black),
                // );
                return InteractiveViewer(
                    maxScale: 5.0,
                    minScale: 0.01,
                    boundaryMargin: const EdgeInsets.all(double.infinity),
                    child: Image.network(imageUrl));
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget datePickerBuilder(BuildContext context, dynamic Function(DateRange?) onDateRangeChanged, [bool doubleMonth = false])
  {
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
  Widget build(BuildContext context)
  {
    // Initialize the ExpensePersonBloc inside BlocProvider
    return Scaffold(
      backgroundColor: AppC.white,
      body:BlocProvider(
        create: (context) => expenseBloc..add(GetExpenseOtherData(minDate: selectedDateRange!.start.toString(),maxDate:  selectedDateRange!.end.toString(),)),
        child:  BlocConsumer<TodoViewBloc, TodoViewState>(
          listener: (context, state) {
            if (state is TodoListLoading) {
                loading = true;
            } else if (state is ExpenseOtherLoaded) {

                loading = false;
                personList = state.data;
                if (state.totalExpensesAmount is double) {
                  totalExpenseAmount = state.totalExpensesAmount;
                } else if (state.totalExpensesAmount is int) {
                  totalExpenseAmount = state.totalExpensesAmount;
                } else {
                  print('Invalid type for totalExpensesAmount');
                }
            } else {
                loading = false;
            }
          },
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
                                  selectedDateRange = value;
                                  String startDate = selectedDateRange!.start.toString();
                                  String endDate = selectedDateRange!.end.toString();
                                  expenseBloc.add(GetExpenseOtherData(minDate: startDate,maxDate:  endDate));
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
                          Utils.getText(
                            'Total: \$${totalExpenseAmount ?? ''}',
                            color: AppC.appColor,
                            weight: FontWeight.bold,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        child:
                        ListView.builder(
                          itemCount: personList.length,
                          itemBuilder: (context, index) {
                            final item = personList[index];
                            bool isChecked = (item['approved'] == 1);
                            return Slidable(
                              key: Key(item['id'].toString()),
                              endActionPane:
                              ActionPane(
                                motion: const DrawerMotion(),
                                dismissible: DismissiblePane(
                                  onDismissed: () async {
                                    // Show a confirmation dialog
                                    final confirmDelete = await showDialog<bool>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return
                                          AlertDialog(
                                          title: const Text('Confirm Delete'),
                                          content: const Text('Are you sure you want to delete this item?'),
                                          actions: [
                                            TextButton(
                                              child: const Text('Cancel'),
                                              onPressed: () => Navigator.of(context).pop(false), // Cancel
                                            ),
                                            TextButton(
                                              child: const Text('Delete'),
                                              onPressed: () => Navigator.of(context).pop(true), // Confirm delete
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                  },
                                ),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      // Triggering the delete action directly here if needed.
                                      // Optionally show a confirmation dialog before the deletion.
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
                                  margin: const EdgeInsets.symmetric(vertical: 4),
                                  color: AppC.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Date
                                            Row(
                                              children: [
                                                Utils.getText(
                                                  item['expense_date']?.substring(5) ?? '',
                                                  color: item['approved'] == 0
                                                      ? AppC.redAccent
                                                      : AppC.appColor,
                                                ),
                                                const SizedBox(width: 10),
                                                Utils.getText(
                                                  item['subcategory']['name'].toString(),
                                                  weight: FontWeight.bold,
                                                  color: item['approved'] == 0
                                                      ? AppC.redAccent
                                                      : AppC.appColor,
                                                ),
                                                const SizedBox(width: 5),
                                                // Full Name
                                                SizedBox(
                                                  width: 50,
                                                  child: Utils.getText(
                                                      "( ${item['expense_description'].toString()} )",
                                                      weight: FontWeight.bold,
                                                      color: item['approved'] == 0
                                                          ? AppC.redAccent
                                                          : AppC.appColor,
                                                      overFlow: TextOverflow.ellipsis
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // Initials
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                // Initials from the name
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
                                                      size: 18,
                                                    ),
                                                  ),
                                                Utils.getText(
                                                  '',
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
                                                Utils.getText("|", size: 12, color: Colors.grey),
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
                                                    Transform.scale(scale:0.7,
                                                      child: SizedBox(
                                                        width: 5,
                                                        height: 5,
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
    );
  }
}

