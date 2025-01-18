
import 'package:fairpytasker/Bloc/private_rental_bloc.dart';
import 'package:fairpytasker/State/private_rental_state.dart';
import 'package:flutter/material.dart';
import '../../../../Event/private_rental_event.dart';
import '../../../../Utilities/appC.dart';
import '../../../../Utilities/utils.dart';
import 'private_rental_add_ui.dart';
import 'private_rental_edit_ui.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class RentalViewUI extends StatefulWidget {
  const RentalViewUI({super.key});

  @override
  State<RentalViewUI> createState() => _RentalViewUIState();
}

class _RentalViewUIState extends State<RentalViewUI> {

  late PrivateRentalBloc privateRentalBloc;
  TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  List<Map<String, dynamic>> privateRental = [];
  List<Map<String, dynamic>> filterRental = [];
  bool loading=false;

  @override
  void initState() {
    super.initState();
    privateRentalBloc = PrivateRentalBloc();
  }


  void _filterRentals(String query) {
    setState(() {
      filterRental = privateRental.where((rental) {
        final vehicle = rental['vehicle_name']?.toLowerCase() ?? '';

        final customer = rental['customer'];
        final customerFirstName = (customer is Map && customer['first_name'] != null)
            ? (customer['first_name'].toString().toLowerCase())
            : '';
        final customerLastName = (customer is Map && customer['last_name'] != null)
            ? (customer['last_name'].toString().toLowerCase())
            : '';
        final searchQuery = query.toLowerCase();
        return vehicle.contains(searchQuery) || customerFirstName.contains(searchQuery) || customerLastName.contains(searchQuery);
      }).toList();
    });
  }




  void _navigateToRentalAddUI() async {
    final newRental = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const RentalAddUI()),
    );

    if (newRental != null) {
     privateRentalBloc.add(AddPrivateRentalData(
         vin:newRental['vin'],
         customerId: newRental['customer_id'],
         checkInDate: newRental['check_in_date'],
         checkOutDate: newRental['check_out_date'],
         checkInMileage: newRental['check_in_mileage'],
         checkOutMileage: newRental['check_out_mileage'],
         rentalStatus: newRental['rental_status'],
         id: newRental['id']));
     Utils.showMobileToast('Private Rental Added successfully');
     privateRentalBloc.add(const GetPrivateRentalData());
    }
  }


  Future<void> _deleteVehicle(int index) async {
    final confirmed = await _confirmDelete(context);
    if (confirmed == true) {
      setState(() {
        privateRental.removeAt(index);
        _filterRentals(searchController.text); // Update filtered list
      });
    }
  }

  void _navigateToVehicleEditUI(int index) async {
    final updatedRental = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => RentalEditUI(
          rentalData: filterRental[index],
        ),
      ),
    );

    if (updatedRental != null) {
      setState(() {
        privateRental[index] = updatedRental;
        filterRental = privateRental; // Update filtered list
      });
    }
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppC.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Utils.getText('Are you sure!'),
        content: Utils.getText('Are you sure you want to delete this rental?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Cancel the deletion
            },
            child: Utils.getText('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Confirm the deletion
            },
            child: Utils.getText('No'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      body: BlocProvider(create: (context)=>privateRentalBloc..add(const GetPrivateRentalData()),
        child: BlocConsumer<PrivateRentalBloc,PrivateRentalState>(
          listener: (context, state) async{
            if (state is PrivateRentalLoading) {
              loading =true;
            }
            else if(state is PrivateRentalLoaded){
              loading=false;
              filterRental.clear();
              filterRental.addAll((state.data??[]));
              List<Map<String, dynamic>> list = [];
              list.addAll(state.data??[]);
              list.sort((a, b) => DateTime.parse(b['created_at']??'').
              compareTo(DateTime.parse(a['created_at']??'')));
              privateRental = list;
              filterRental = List.from(privateRental);
            }
            else{
              privateRentalBloc.add(const GetPrivateRentalData());
              loading=true;
            }
            },
        builder: (context, state) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: Utils.getSearchBarUI(
                                    () {},
                                    (value) {
                                  _filterRentals(
                                      value); // Filter rentals based on search query
                                },
                                searchController,),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                            height: 40,
                            child: Utils.getAddFilledButton('Add', () {
                              _navigateToRentalAddUI();
                            })
                        ),
                      ],
                    ),
                    // const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filterRental.length,
                        itemBuilder: (context, index) {
                          final rental = filterRental[index];
                          return Slidable(
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) => _deleteVehicle(index),
                                  backgroundColor: AppC.white,
                                  foregroundColor: AppC.red,
                                  icon: Icons.delete_outline,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _navigateToVehicleEditUI(index);
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                color: AppC.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Utils.getText(
                                          rental['vehicle_name']!,
                                          weight: FontWeight.bold,
                                        ),
                                        if (rental['customer'] is Map<String, dynamic>)
                                        Utils.getText(
                                         " ${rental['customer']['first_name']} ${rental['customer']['last_name']}",
                                          weight: FontWeight.bold,
                                        ),
                                      ],
                                    ),
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
        }
        ),
      ),
    );
  }
}
