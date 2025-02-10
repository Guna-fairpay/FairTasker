
import 'dart:io';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';
import '../../../Bloc/vendor_data_bloc.dart';
import '../../dialog/show_attachments_dialog.dart';
import 'vendor_add_ui.dart';
import 'vendor_edit_ui.dart';
import 'dart:math' as math;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class VendorViewUI extends StatefulWidget {
  const VendorViewUI({super.key});

  @override
  State<VendorViewUI> createState() => _VendorViewUIState();
}

class _VendorViewUIState extends State<VendorViewUI> {
  late VendorDataBloc vendorDataBloc;
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  List<Map<String, dynamic>> imageFile = [];
  List<Map<String, dynamic>> vendors = [];
  List<Map<String, dynamic>> filteredVendors = [];
  bool loading = false;
  List<dynamic> images=[];

  @override
  void initState() {
    super.initState();
    vendorDataBloc = VendorDataBloc();
  }

  void _filterVendors(String query) {
    setState(() {
      filteredVendors = vendors.where((vendor) {
        final name = vendor['name']?.toLowerCase() ?? '';
        final address = vendor['address']?.toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();
        return name.contains(searchQuery) || address.contains(searchQuery);
      }).toList();
    });
  }

  Future<void> _navigateToVendorAddUI() async {
    final newVendor = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const VendorAddUI()),
    );
    if (newVendor != null) {
      vendorDataBloc.add(AddVendorData(
        id: newVendor['id'],
        name: newVendor['name'],
        address: newVendor['address'],
        phone: newVendor['phone'],
        expertise: newVendor['expertise'],
        description: newVendor['description'],
        vendor_typeId: newVendor['vendor_type']?['id'].toString(),
        images: newVendor['images']!
            .map((e) => (e['path'] ?? '').isEmpty ? e.fileType : null)
            .where((element) => element != null)
            .cast<File>()
            .toList(),
        //newVendor.vendorType!.id,
      ));

      vendorDataBloc.add(const GetVendorList());
    }
  }

  Future<void> _navigateToEditVendorUI(int index) async {
    final updatedVendor = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => VendorEditUI(vendor: filteredVendors[index]),
      ),
    );

    if (updatedVendor != null) {
      vendorDataBloc.add(AddVendorData(
        id: updatedVendor['id'],
        name: updatedVendor['name'],
        address: updatedVendor['address'],
        phone: updatedVendor['phone'],
        expertise: updatedVendor['expertise'],
        description: updatedVendor['description'],
        vendor_typeId: updatedVendor['vendorType']?.todoId.toString(),
        images: updatedVendor['images']!
            .map((e) => (e['path'] ?? '').isEmpty ? e.fileType : null)
            .where((element) => element != null)
            .cast<File>()
            .toList(),
      ));

      vendorDataBloc.add(const GetVendorList());
      print(updatedVendor['address']);
    }
  }

  void _showImageDialog(
      List<Map<String, dynamic>> imageUrls, int initialIndex) {
    PageController pageController = PageController(initialPage: initialIndex);

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
                        'Images', // Adjust as needed
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
                      final image = imageUrls[index];
                      final imagePath = image['path'];

                      if (imagePath == null || !File(imagePath).existsSync()) {
                        return Center(
                          child: Text('Image not found: $imagePath'),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Image.file(
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

  void _deleteVendor(int index) async {
    final confirmed = await Utils.showCustomDeleteDialog(context,'vendor');
    if (confirmed == true) {
      final vendor = filteredVendors[index];
      vendorDataBloc.add(DeleteVendorEvent(id: vendor['id']));
      Utils.showMobileToast('Vendor deleted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
        backgroundColor: AppC.appColor,
        title: Utils.getText('Vendor',color: AppC.white,size: 20),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                  Icons.close,
                color: AppC.white,
              ))
        ],
      ),
      body: BlocProvider(
        create: (context) => vendorDataBloc..add(const GetVendorList()),
        child: BlocConsumer<VendorDataBloc, VendorDataState>(
          listener: (context, state) async {
            if (state is VendorDataLoading) {
              loading = true;
            } else if (state is VendorListLoaded) {
              loading = false;
              filteredVendors.clear();
              filteredVendors.addAll(state.resource ?? []);
              List<Map<String, dynamic>> list = [];
              list.addAll(state.resource ?? []);
              list.sort((a, b) => DateTime.parse(b['created_at'])
                  .compareTo(DateTime.parse(a['created_at'])));
              vendors = list;
              filteredVendors = List.from(vendors);
            }
            // else if(state is VendorListLoaded)
            //   {
            //     vendorDataBloc.add(const GetVendorList());
            //     loading = true;
            //   }
            else {
              vendorDataBloc.add(const GetVendorList());
              loading = true;
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                  child: Column(
                    children: [
                      Row(
                        spacing:10,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 40,
                              child: Utils.getSearchBarUI(() {}, (value) {
                                _filterVendors(value);
                              }, searchController,),
                            ),
                          ),
                          Utils.getAddElevatedButton(_navigateToVendorAddUI),
                        ],
                      ),
                      Expanded(
                        child: ListView.separated(
                          itemCount: filteredVendors.length,
                          itemBuilder: (context, index) {
                            final vendor = filteredVendors[index];
                            return GestureDetector(
                              onTap: () => _navigateToEditVendorUI(index),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      spacing:10,
                                      children: [
                                        Expanded(
                                          child: Utils.getText(
                                            vendor['name'] ?? '',
                                            weight: FontWeight.bold,
                                          ),
                                        ),
                                        if (vendor['images'] != null &&
                                            vendor['images']!.isNotEmpty)
                                          GestureDetector(
                                            onTap: () {
                                              ShowAttachmentsDialog.of.show(context,
                                                  attachments: filteredVendors[index]?['images']?.map((e) => e['path'].toString().toStorageURL).toList(),
                                                  title: vendor['name'] ?? '');
                                            },
                                            child: const Icon(
                                              Icons.visibility_outlined,
                                              color: AppC.appColor,
                                            ),
                                          ),
                                        // Icon(Icons.navigation_outlined,size: 15,)
                                        if(vendor['latitude'] != null && vendor['longitude'] != null)
                                        GestureDetector(
                                          onTap:()async {
                                            final Uri mapsUri = Uri(
                                              scheme: 'https',
                                              host: 'www.google.com',
                                              path: '/maps/search/ ${vendor['latitude']}, ${vendor['longitude']}',
                                              queryParameters: {'q': '${vendor['latitude']}, ${vendor['longitude']}'},
                                            );
                                            if (await canLaunchUrl(mapsUri)) {
                                              await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
                                            } else {
                                              throw 'Could not open the map.';
                                            }
                                            },
                                          child: Transform(
                                            alignment: Alignment.center,
                                            transform: Matrix4.rotationZ(
                                                50 * math.pi / 180),
                                            child: const Icon(
                                              Icons.navigation_outlined,
                                              color: AppC.green,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap:()=>_deleteVendor(index),
                                            child: const Icon(Icons.delete_outline,color: AppC.redAccent,)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }, separatorBuilder: (context,index) => const Divider(height: 0.5,),
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
      drawer: const DrawerView(),
    );
  }
}
