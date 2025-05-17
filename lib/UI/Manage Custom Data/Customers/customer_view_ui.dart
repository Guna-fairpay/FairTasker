

import 'package:fairpytasker/Bloc/private_rental_bloc.dart';
import 'package:fairpytasker/Event/private_rental_event.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../State/private_rental_state.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';
import 'customer_add_ui.dart';
import 'customer_edit_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerViewUi extends StatefulWidget {
  const CustomerViewUi({super.key});

  @override
  State<CustomerViewUi> createState() => _CustomerViewUiState();
}

class _CustomerViewUiState extends State<CustomerViewUi> {
  late PrivateRentalBloc privateRentalBloc;
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  List<Map<String, dynamic>> customer = [];
  List<Map<String, dynamic>> filteredCustomer = [];


  @override
  void initState() {
    super.initState();
    privateRentalBloc = PrivateRentalBloc();
    privateRentalBloc.add(const GetCustomerData());
  }

  void _filteredCustomer(String query) {
    setState(() {
      filteredCustomer = customer.where((customer) {
        final firstname = customer['first_name']?.toLowerCase() ?? '';
        final lastname = customer['last_name']?.toLowerCase() ?? '';
        final phone = customer['phone']?.toLowerCase() ?? '';
        final rent = customer['monthly_rental']?.toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();
        return firstname.contains(searchQuery) ||
            lastname.contains(searchQuery) ||
            phone.contains(searchQuery) ||
            rent.contains(searchQuery);
      }).toList();
    });
  }

  Future<void> _navigateToCustomerAddUI() async {
    final newCustomer = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const CustomerAddUI()),
    );

    if (newCustomer != null) {
      privateRentalBloc.add(AddCustomerData(
          firstName: newCustomer['first_name'],
          lastName: newCustomer['last_name'],
          phone: newCustomer['phone'],
          address: newCustomer['address'],
          monthlyRental: newCustomer['monthly_rental'],
          rentalStartDate: newCustomer['rental_start_date'],
          securityDeposit: newCustomer['security_deposit'],
          note: newCustomer['note'],
          id: newCustomer['id'],
        licenceAttach: newCustomer['licenceAttach'],
        insuranceAttach: newCustomer['insuranceAttach'],
      ));
      privateRentalBloc.add(const GetCustomerData());
      Utils.showMobileToast('Category Added successfully');
    }
  }

  Future<void> _navigateToEditCustomerUI(int index) async {
    final updatedCustomer = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerEditUi(
            id: filteredCustomer[index]['id']
        ),
      ),
    );
    if (updatedCustomer != null) {
      privateRentalBloc.add(AddCustomerData(
          firstName: updatedCustomer['first_name'],
          lastName: updatedCustomer['last_name'],
          phone: updatedCustomer['phone'],
          address: updatedCustomer['address'],
          monthlyRental: updatedCustomer['monthly_rental'],
          rentalStartDate: updatedCustomer['rental_start_date'],
          securityDeposit: updatedCustomer['security_deposit'],
          note: updatedCustomer['note'],
          licenceAttach: updatedCustomer['licenceAttach'],
          insuranceAttach: updatedCustomer['insuranceAttach'],
          id: updatedCustomer['id']
      ));
      privateRentalBloc.add(const GetCustomerData());
      Utils.showMobileToast('Category Updated successfully');
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> deleteCustomer(int index) async {
    final confirmed = await Utils.showCustomDeleteDialog(context,'Rental Customer');
    if (confirmed == true) {
      final delete = filteredCustomer[index];
      privateRentalBloc.add(DeleteCustomer(id: delete['id']));
      Utils.showMobileToast('Customer Deleted Successfully');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
        backgroundColor: AppC.appColor,
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        title: ListTile(
          title: const Text('Customer'),
          subtitle: const Text('Private Rental Customer'),
          titleTextStyle: context.textTheme.titleLarge?.copyWith(color: Colors.white),
          subtitleTextStyle: context.textTheme.labelMedium?.copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close,),)
        ],
      ),
      body: BlocProvider(
        create: (context) => privateRentalBloc..add(const GetCustomerData()),
        child: BlocConsumer<PrivateRentalBloc, PrivateRentalState>(
            listener: (context, state) async {
          if (state is PrivateRentalLoading) {
            EasyLoading.show();
          } else if (state is CustomerLoaded) {
            if (EasyLoading.isShow) EasyLoading.dismiss();
            filteredCustomer.clear();
            customer.clear();
            final List<Map<String, dynamic>> list = [];
            list.addAll(state.data ?? []);
            list.sort((a, b) => DateTime.parse(b['created_at'] ?? '')
                .compareTo(DateTime.parse(a['created_at'] ?? '')));
            customer.addAll(list);
            filteredCustomer = List.from(customer);
          } else if (state is CustomerListLoaded) {
            if (EasyLoading.isShow) EasyLoading.dismiss();
            privateRentalBloc.add(const GetCustomerData());
          } else {
            privateRentalBloc.add(const GetCustomerData());
            if (EasyLoading.isShow) EasyLoading.dismiss();
          }
        }, builder: (context, state) {
          return SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child: Column(
              spacing: 10,
              children: [
                Row(spacing: 10,
                  children: [
                    Expanded(
                      child: Utils.getSearchBarUI(onChange: (value) {
                        _filteredCustomer(value);
                      }, searchController: searchController,),
                    ),
                    Utils.getAddElevatedButton( () => _navigateToCustomerAddUI()
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index)=>const Divider(height: 0.5,),
                    itemCount: filteredCustomer.length,
                    itemBuilder: (context, index) {
                      final customer = filteredCustomer[index];
                      return InkWell(
                        onTap: () {
                          _navigateToEditCustomerUI(index);
                        },
                        child: SafeArea(
                          minimum: const EdgeInsets.all(10.0),
                          child: Row(
                            spacing: 20,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:CrossAxisAlignment.start,
                                  children: [
                                    Utils.getText(
                                        '${customer['first_name']} ${customer['last_name']}',
                                        weight: FontWeight.bold),
                                    Utils.getText(
                                        '${customer['phone']}',
                                        color: AppC.subText),

                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:CrossAxisAlignment.end,
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Utils.getText(
                                        ' ${Utils.convertCurrentDateToDateMonthYearFormat(customer['rental_start_date'])}',
                                        color: AppC.subText),
                                    Utils.getText(
                                        '\$ ${customer['monthly_rental']}',
                                        color: AppC.green),
                                  ],
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    deleteCustomer(index);
                                  },
                                  child: const Icon(Icons.delete_outline,color: AppC.redAccent,),
                              )
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
        }),
      ),
    );
  }
}
