
import 'package:fairpytasker/Bloc/private_rental_bloc.dart';
import 'package:fairpytasker/State/private_rental_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      body: BlocProvider(create: (context)=>privateRentalBloc..add(const GetPrivateRentalData()),
        child: BlocConsumer<PrivateRentalBloc,PrivateRentalState>(
          listener: (context, state) async{
            if (state is PrivateRentalLoading) {
             EasyLoading.show();
            }
            else {
              if(EasyLoading.isShow)EasyLoading.dismiss();
            if (state is PrivateRentalLoaded) {
              filterRental.clear();
              filterRental.addAll((state.data ?? []));
              List<Map<String, dynamic>> list = [];
              list.addAll(state.data ?? []);
              list.sort((a, b) => DateTime.parse(b['created_at'] ?? '')
                  .compareTo(DateTime.parse(a['created_at'] ?? '')));
              privateRental = list;
              filterRental = List.from(privateRental);
            } else {
              privateRentalBloc.add(const GetPrivateRentalData());
            }
          }
        },
        builder: (context, state) {
          return SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Utils.getSearchBarUI(
                              onChange: (value) {
                            _filterRentals(
                                value); // Filter rentals based on search query
                          },
                          searchController: searchController),
                    ),
                    const SizedBox(width: 8),
                    Utils.getAddElevatedButton(()=>_navigateToRentalAddUI()),
                  ],
                ),
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Container(
                    color: AppC.blue50,
                    padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                            child: Utils.getText(
                                'Vehicle Name',
                                weight: FontWeight.bold)
                        ),
                        Expanded(child: Utils.getText(
                            'Customer',
                            weight: FontWeight.bold)
                        ),
                      ],
                    ),
                  ),
                ),
                // const SizedBox(height: 10),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index)=>const Divider(height: 0.5,),
                    itemCount: filterRental.length,
                    itemBuilder: (context, index) {
                      final rental = filterRental[index];
                      return InkWell(
                        onTap: () {
                          _navigateToVehicleEditUI(index);
                        },
                        child: SafeArea(
                          minimum: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Utils.getText(
                                      rental['vehicle_name']??'',
                                    ),
                                  ],
                                ),
                              ),
                              if (rental['customer'] is Map<String, dynamic>)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Utils.getText(
                                     "${rental['customer']['first_name']??'-'} ${rental['customer']['last_name']??'-'}",
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.add,color: AppC.green,),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
        ),
      ),
    );
  }
}
