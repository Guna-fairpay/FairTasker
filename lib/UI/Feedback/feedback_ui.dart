
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:fairpytasker/Response/working_history_count_response.dart';
import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
import 'package:fairpytasker/Event/todo_view_event.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'feedback_add_ui.dart';
import 'feedback_list_view_ui.dart';

class FeedBackUI extends StatefulWidget {
  const FeedBackUI({Key? key}) : super(key: key);

  @override
  State<FeedBackUI> createState() => _FeedBackUIState();
}

class _FeedBackUIState extends State<FeedBackUI> {
  late TodoViewBloc vendorDataBloc;
  final FocusNode searchFocusNode = FocusNode();
  TextEditingController dateController = TextEditingController();
  List<Map<String, dynamic>> resourceList = [];
  WorkingHistoryCountResponse? workingHistoryCountResponse;
  List<Map<String, dynamic>> historyCountList = [];
  Map<String, dynamic>? selectedResource;
  DateTime? selectedDate;
  DateRange? selectedDateRange;
  TextEditingController searchController = TextEditingController();
  bool isSelected = false;
  String selectedStatus = 'Pending';
  PageController pageController = PageController();

  final List<Map<String, String>> statuses = [
    {
      'label': 'Pending',
    },
    {
      'label': 'In Progress',
    },
    {
      'label': 'Review',
    },
    {
      'label': 'Closed',
    },
    {
      'label': 'Feature',
    },
    {
      'label': 'Archive',
    },
  ];

  List<Map<String, dynamic>> feedbacks = [];
  List<Map<String, dynamic>> pending = [];
  List<Map<String, dynamic>> inProcess = [];
  List<Map<String, dynamic>> review = [];
  List<Map<String, dynamic>> close = [];
  List<Map<String, dynamic>> feature = [];
  List<Map<String, dynamic>> archive = [];
  List<Map<String, dynamic>> filteredPending = [];
  List<Map<String, dynamic>> filteredInProcess = [];
  List<Map<String, dynamic>> filteredReview = [];
  List<Map<String, dynamic>> filteredClose = [];
  List<Map<String, dynamic>> filteredFeature = [];
  List<Map<String, dynamic>> filteredArchive = [];
  int pendingCount = 0;
  int inProcessCount = 0;
  int reviewCount = 0;
  int closeCount = 0;
  int featureCount = 0;
  int archiveCount = 0;

  @override
  void initState() {
    super.initState();
    // vendorDataBloc = TodoViewBloc();
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(const Duration(days: 7));
    selectedDateRange = DateRange(startOfWeek, now);
    // vendorDataBloc.add(GetWorkingHistoryList(
    //   startDate: Utils.getStartOfMonth(val: startOfWeek),
    //   endDate: Utils.getStartOfMonth(val: now),
    // ));
    // vendorDataBloc.add(GetWorkingHistoryCount(
    //   startDate: Utils.getStartOfMonth(val: startOfWeek),
    //   endDate: Utils.getStartOfMonth(val: now),
    // ));

    pending = [
      {
        'title': 'Archive & Rejected feedback',
        'priority': 'High',
        'time': '20d',
        'imgurls': [
          'assets/images/ic_introduction.png',
          'assets/images/ic_email_benner.png',
        ],
        'des': quill.Document.fromJson([
          {
            "insert":
                "Feedback currently in process, with medium priority.Description includes detailed feedback and ongoing action items.'This task has been ongoing for 30 days.\n"
          }
        ]).toDelta().toJson(),
      },
      {
        'title': 'Upload Reservation',
        'priority': 'High',
        'time': '63d',
        'imgurls': ['assets/images/ic_email_benner.png'],
        'des': quill.Document.fromJson([
          {
            "insert":
                "Feedback currently in process, with medium priority.Description includes detailed feedback and ongoing action items.'This task has been ongoing for 30 days.\n"
          }
        ]).toDelta().toJson(),
      },
      {
        'title': 'Upload Reservation',
        'priority': 'Medium',
        'time': '63d',
        'imgurls': ['assets/images/dollarbag.png'],
        'des': quill.Document.fromJson([
          {
            "insert":
                "Feedback currently in process, with medium priority.Description includes detailed feedback and ongoing action items.'This task has been ongoing for 30 days.\n"
          }
        ]).toDelta().toJson(),
      },
      {
        'title': 'Upload Reservation',
        'priority': 'High',
        'time': '63d',
        'imgurls': ['assets/images/ic_app_dev.png'],
        'des': quill.Document.fromJson([
          {
            "insert":
                "Feedback currently in process, with medium priority.Description includes detailed feedback and ongoing action items.'This task has been ongoing for 30 days.\n"
          }
        ]).toDelta().toJson(),
      },
      {
        'title': 'Upload Reservation',
        'priority': 'Medium',
        'time': '63d',
        'imgurls': ['assets/images/ic_ui_design.png'],
        'des': quill.Document.fromJson([
          {
            "insert":
                "Feedback currently in process, with medium priority.Description includes detailed feedback and ongoing action items.'This task has been ongoing for 30 days.\n"
          }
        ]).toDelta().toJson(),
      },
      {
        'title': 'Vehicle status incorrect',
        'priority': 'High',
        'time': '90d',
        'imgurls': ['assets/images/ic_search.png'],
        'des': quill.Document.fromJson([
          {
            "insert":
                "Feedback currently in process, with medium priority.Description includes detailed feedback and ongoing action items.'This task has been ongoing for 30 days.\n"
          }
        ]).toDelta().toJson(),
      },
      {
        'title': 'Swipe right',
        'priority': 'Low',
        'time': '50d',
        'imgurls': ['assets/images/ic_ui_design.png'],
        'des': quill.Document.fromJson([
          {
            "insert":
                "Feedback currently in process, with medium priority.Description includes detailed feedback and ongoing action items.'This task has been ongoing for 30 days.\n"
          }
        ]).toDelta().toJson(),
      },
      {
        'title': 'Future clean checkout time',
        'priority': 'Medium',
        'time': '43d',
        'imgurls': ['assets/images/splash_bg.png'],
        'des': quill.Document.fromJson([
          {
            "insert":
                "Feedback currently in process, with medium priority.Description includes detailed feedback and ongoing action items.'This task has been ongoing for 30 days.\n"
          }
        ]).toDelta().toJson(),
      },
      {
        'title': 'Checkout edit',
        'priority': 'Low',
        'time': '65d',
        'imgurls': ['assets/images/ic_web_dev.png'],
        'des': quill.Document.fromJson([
          {
            "insert":
                "Feedback currently in process, with medium priority.Description includes detailed feedback and ongoing action items.'This task has been ongoing for 30 days.\n"
          }
        ]).toDelta().toJson(),
      },
    ];

    inProcess = [
      {
        'title': 'In Process Feedback',
        'priority': 'Medium',
        'time': '30d',
        'des': quill.Document.fromJson([
          {
            "insert":
                "Feedback currently in process, with medium priority.Description includes detailed feedback and ongoing action items.'This task has been ongoing for 30 days.\n"
          }
        ]).toDelta().toJson(),
        'imgurls': ['assets/images/ic_web_dev.png'],
      },
    ];

    review = [
      {
        'title': 'Review Feedback',
        'priority': 'High',
        'time': '65d',
        'imgurls': ['assets/images/ic_web_dev.png'],
        'des': quill.Document.fromJson([
          {
            "insert":
                "Feedback currently in process, with medium priority.Description includes detailed feedback and ongoing action items.'This task has been ongoing for 30 days.\n"
          }
        ]).toDelta().toJson(),
      },
    ];

    close = [
      {
        'title': 'Closed Feedback',
        'priority': 'Medium',
        'time': '90d',
        'imgurls': ['assets/images/ic_search.png'],
        'des': quill.Document.fromJson([
          {
            "insert":
                "Feedback currently in process, with medium priority.Description includes detailed feedback and ongoing action items.'This task has been ongoing for 30 days.\n"
          }
        ]).toDelta().toJson(),
      },
    ];

    feature = [
      {
        'title': 'Feature Feedback',
        'priority': 'Low',
        'time': '90d',
        'imgurls': ['assets/images/ic_search.png'],
        'des': quill.Document.fromJson([
          {
            "insert":
                "Feedback currently in process, with medium priority.Description includes detailed feedback and ongoing action items.'This task has been ongoing for 30 days.\n"
          }
        ]).toDelta().toJson(),
      },
    ];

    archive = [
      {
        'title': 'Archive Feedback',
        'priority': 'Low',
        'time': '63d',
        'imgurls': ['assets/images/ic_email_benner.png'],
        'des': quill.Document.fromJson([
          {
            "insert":
                "Feedback currently in process, with medium priority.Description includes detailed feedback and ongoing action items.'This task has been ongoing for 30 days.\n"
          }
        ]).toDelta().toJson(),
      },
    ];

    _filterByStatus();
  }

  void _navigateToFeedbackAddUI() async {
    final newFeedback = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const FeedbackAddUI(), fullscreenDialog: true),
    );

    if (newFeedback != null) {
      setState(() {
        pending.add(newFeedback);
        filteredPending = pending; // Update filtered list
      });
    }
  }

  void _setFeedbackToClosed(int index) {
    setState(() {
      final feedback = feedbacks[index];
      feedback['status'] = 'Closed';
      close.add(feedback);
      if (selectedStatus == 'Pending') {
        pending.removeAt(index);
      } else if (selectedStatus == 'In Progress') {
        inProcess.removeAt(index);
      } else if (selectedStatus == 'Review') {
        review.removeAt(index);
      } else if (selectedStatus == 'Feature') {
        feature.removeAt(index);
      } else if (selectedStatus == 'Archive') {
        archive.removeAt(index);
      }
      pendingCount = pending.length;
      inProcessCount = inProcess.length;
      reviewCount = review.length;
      closeCount = close.length;
      featureCount = feature.length;
      archiveCount = archive.length;
      _filterByStatus();
    });
  }

  void _navigateToEditDepartmentUI(int index) async {
    final updatedFeedback = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => FeedbackListViewUI(
          feedbacks: feedbacks[index],
          status: selectedStatus,
        ),
      ),
    );

    if (updatedFeedback != null) {
      setState(() {
        feedbacks[index] = updatedFeedback;
        if (updatedFeedback['status'] == 'Closed') {
          _setFeedbackToClosed(index);
          // pendingCount = pending.length;
          // inProcessCount = inProcess.length;
          // reviewCount = review.length;
          // closeCount = close.length;
          // featureCount = feature.length;
          // archiveCount = archive.length;
        }
      });
    }
  }

  void _filterByStatus() {
    setState(() {
      pendingCount = pending.length;
      inProcessCount = inProcess.length;
      reviewCount = review.length;
      closeCount = close.length;
      featureCount = feature.length;
      archiveCount = archive.length;

      if (selectedStatus == 'Pending') {
        filteredPending = pending;
        feedbacks = filteredPending;
      } else if (selectedStatus == 'In Progress') {
        filteredInProcess = inProcess;
        feedbacks = filteredInProcess;
      } else if (selectedStatus == 'Review') {
        filteredReview = review;
        feedbacks = filteredReview;
      } else if (selectedStatus == 'Closed') {
        filteredClose = close;
        feedbacks = filteredClose;
      } else if (selectedStatus == 'Feature') {
        filteredFeature = feature;
        feedbacks = filteredFeature;
      } else if (selectedStatus == 'Archive') {
        filteredArchive = archive;
        feedbacks = filteredArchive;
      } else {
        feedbacks = pending;
      }
      _filterfeedbacks(
          searchController.text); // Reapply search filter after status change
    });
  }

  void _filterfeedbacks(String query) {
    setState(() {
      final lowerQuery = query.toLowerCase();
      List<Map<String, dynamic>> filterList;

      switch (selectedStatus) {
        case 'Pending':
          filterList = filteredPending;
          break;
        case 'In Progress':
          filterList = filteredInProcess;
          break;
        case 'Review':
          filterList = filteredReview;
          break;
        case 'Closed':
          filterList = filteredClose;
          break;
        case 'Feature':
          filterList = filteredFeature;
          break;
        case 'Archive':
          filterList = filteredArchive;
          break;
        default:
          filterList = pending;
      }

      feedbacks = filterList.where((feedback) {
        final title = feedback['title']?.toLowerCase() ?? '';
        return title.contains(lowerQuery);
      }).toList();
    });
  }

  void _showImageDialog(List<String> imageUrls, int index) {
    if (imageUrls.isEmpty) {
      print('No images to show');
      return;
    }

    PageController pageController = PageController();

    print('Showing images dialog with ${imageUrls.length} images');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(10),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppC.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Utils.getText(
                        feedbacks[index]['title'],
                        color: AppC().base,
                        size: 15,
                        weight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Container(
                  color: AppC.white,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: PageView.builder(
                    itemCount: imageUrls.length,
                    controller: pageController,
                    itemBuilder: (context, index) {
                      final imagePath = imageUrls[index];
                      print('Displaying image: $imagePath');
                      return Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: imagePath.startsWith('assets/')
                            ? Image.asset(
                                imagePath,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  print('Error loading asset image: $error');
                                  return const Center(
                                    child: Icon(Icons.error, color: Colors.red),
                                  );
                                },
                              )
                            : Image.file(
                                File(imagePath),
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  print('Error loading file image: $error');
                                  return const Center(
                                    child: Icon(Icons.error, color: Colors.red),
                                  );
                                },
                              ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SmoothPageIndicator(
                  controller: pageController,
                  count: imageUrls.length,
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
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteFeedback(int index) async {
    final confirmed = await _confirmDelete(context);
    if (confirmed == true) {
      print('Confirmed deletion at index: $index');
      setState(() {
        if (selectedStatus == 'Pending') {
          pending.removeAt(index);
        } else if (selectedStatus == 'In Progress') {
          inProcess.removeAt(index);
        } else if (selectedStatus == 'Review') {
          review.removeAt(index);
        } else if (selectedStatus == 'Closed') {
          close.removeAt(index);
        } else if (selectedStatus == 'Feature') {
          feature.removeAt(index);
        } else if (selectedStatus == 'Archive') {
          archive.removeAt(index);
        }
        pendingCount = pending.length;
        inProcessCount = inProcess.length;
        reviewCount = review.length;
        closeCount = close.length;
        featureCount = feature.length;
        archiveCount = archive.length;
        print('Feedbacks after deletion: $feedbacks');
        _filterfeedbacks(searchController.text); // Update filtered list
      });
      Utils.showMobileToast('Deleted');
    } else {
      print('Deletion canceled');
      Utils.showMobileToast('Deletion canceled');
    }
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppC.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Utils.getText('Are you sure!'),
        content:
            Utils.getText('Are you sure you want to delete this feedback?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Confirm the deletion
            },
            child: Utils.getText('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Cancel the deletion
            },
            child: Utils.getText('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: Utils.getSearchBarUI(
                      () {},
                      (value) {
                        _filterfeedbacks(value);
                      },
                      searchController,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 40,
                  child: Utils.getAddFilledButton('Add', () {
                    _navigateToFeedbackAddUI();
                  }),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: statuses.map((status) {
                        bool isSelected = selectedStatus == status['label'];
                        int count;

                        // Determine count based on the status
                        switch (status['label']) {
                          case 'Pending':
                            count = pendingCount;
                            break;
                          case 'In Progress':
                            count = inProcessCount;
                            break;
                          case 'Review':
                            count = reviewCount;
                            break;
                          case 'Closed':
                            count = closeCount;
                            break;
                          case 'Feature':
                            count = featureCount;
                            break;
                          case 'Archive':
                            count = archiveCount;
                            break;
                          default:
                            count = 0;
                        }
                        return Row(
                          children: [
                            Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Utils.getOutlinedButton(
                                  status['label']!,
                                  verticalPadding: 2.0,
                                  () {
                                    setState(() {
                                      selectedStatus = status['label']!;
                                      _filterByStatus();
                                    });
                                  },
                                  bgColor: isSelected
                                      ? AppC().base
                                      : Colors.transparent,
                                  textColor:
                                      isSelected ? Colors.white : AppC().base,
                                ),
                                Positioned(
                                  right: -2,
                                  top: -6,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: AppC.red,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppC.redOpac,
                                        width: 1,
                                      ),
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 10,
                                      minHeight: 10,
                                    ),
                                    child: Center(
                                      child: Utils.getText(
                                        count.toString(),
                                        color: AppC.white,
                                        size: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 5),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Divider(),
            const SizedBox(height: 5),
            Expanded(
              child: ListView.builder(
                itemCount: feedbacks.length,
                itemBuilder: (context, index) {
                  final feedback = feedbacks[index];
                  return Slidable(
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            setState(() {
                              _deleteFeedback(index);
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
                        _navigateToEditDepartmentUI(index);
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        color: AppC.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: feedback['priority'] == 'High'
                                          ? Colors.red[900]
                                          : feedback['priority'] == 'Medium'
                                              ? Colors.blue
                                              : feedback['priority'] == 'Low'
                                                  ? Colors.grey
                                                  : Colors.transparent,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    width: 20,
                                    child: Center(
                                      child: Utils.getText(
                                        feedback['priority'] == 'High'
                                            ? 'H'
                                            : feedback['priority'] == 'Medium'
                                                ? 'M'
                                                : feedback['priority'] == 'Low'
                                                    ? 'L'
                                                    : '',
                                        weight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Utils.getText(
                                      feedback['title']!,
                                      color: AppC().base,
                                      size: 15,
                                      weight: FontWeight.w600,
                                    ),
                                  ),
                                  if (feedback['imgurls'] != null &&
                                      feedback['imgurls'].isNotEmpty)
                                    GestureDetector(
                                      onTap: () {
                                        _showImageDialog(
                                            feedback['imgurls'] as List<String>,
                                            index);
                                      },
                                      child: Icon(
                                        Icons
                                            .image, // Use Icons.image for image icon
                                        color: AppC().base,
                                      ),
                                    ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Utils.getText(
                                    feedback['time'] ?? 'No Time Provided',
                                    color: AppC.blueGrey,
                                    weight: FontWeight.bold,
                                    size: 13,
                                  ),
                                  Utils.getText('PO', weight: FontWeight.bold),
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
    );
  }
}
