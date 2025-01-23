import 'package:fairpytasker/Bloc/private_rental_bloc.dart';
import 'package:fairpytasker/Event/private_rental_event.dart';
import 'package:flutter/material.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../State/private_rental_state.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';
import 'customer_add_ui.dart';
import 'customer_edit_ui.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
  bool loading = false;

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
          // insuranceAttach: newCustomer['insuranceAttach'],
          // licenceAttach: newCustomer['licenceAttach'],
          id: newCustomer['id']));
      print("------------------>$newCustomer");
      privateRentalBloc.add(const GetCustomerData());
      Utils.showMobileToast('Category Added successfully');
    }
  }

  Future<void> _navigateToEditCustomerUI(int index) async {
    final updatedCustomer = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerEditUi(
            customer: filteredCustomer[index]), // Pass the location for editing
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
          //insuranceAttach: updatedCustomer['insuranceAttach'],
          //  licenceAttach: updatedCustomer['licenceAttach'],
          id: updatedCustomer['id']));
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
    final confirmed = await _confirmDelete(context);
    if (confirmed == true) {
      final delete = filteredCustomer[index];
      privateRentalBloc.add(DeleteCustomer(id: delete['id'].toString()));
      Utils.showMobileToast('Customer Deleted Successfully');
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
            Utils.getText('Are you sure you want to delete this customer?'),
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
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(35.0), // Change the height here
        child: HeaderView(),
      ),
      body: BlocProvider(
        create: (context) => privateRentalBloc..add(const GetCustomerData()),
        child: BlocConsumer<PrivateRentalBloc, PrivateRentalState>(
            listener: (context, state) async {
          if (state is PrivateRentalLoading) {
            loading = true;
          } else if (state is CustomerLoaded) {
            loading = false;
            filteredCustomer.clear();
            filteredCustomer.addAll((state.data ?? []));
            List<Map<String, dynamic>> list = [];
            list.addAll(state.data ?? []);
            list.sort((a, b) => DateTime.parse(b['created_at'] ?? '')
                .compareTo(DateTime.parse(a['created_at'] ?? '')));
            customer = list;
            filteredCustomer = List.from(customer);
          } else if (state is CustomerListLoaded) {
            loading = false;
            filteredCustomer.clear();
            privateRentalBloc.add(const GetCustomerData());
          } else {
            privateRentalBloc.add(const GetPrivateRentalData());
            loading = true;
          }
        }, builder: (context, state) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back)),
                        const SizedBox(
                          width: 10,
                        ),
                        Utils.getText('Private Rental Customer',
                            size: 20, weight: FontWeight.bold),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: Utils.getSearchBarUI(() {}, (value) {
                              _filteredCustomer(value);
                            }, searchController,),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 40,
                          child: Utils.getAddFilledButton('Add', () {
                            _navigateToCustomerAddUI();
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredCustomer.length,
                        itemBuilder: (context, index) {
                          final customer = filteredCustomer[index];
                          return Slidable(
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) => deleteCustomer(index),
                                  backgroundColor: AppC.white,
                                  foregroundColor: AppC.red,
                                  icon: Icons.delete_outline,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _navigateToEditCustomerUI(index);
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                color: AppC.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Utils.getText(
                                                  '${customer['first_name']} ${customer['last_name']}',
                                                  weight: FontWeight.bold)),
                                          const SizedBox(
                                            width: 50,
                                          ),
                                          Utils.getText(
                                              '\$ ${customer['monthly_rental']}',
                                              color: AppC.green),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Utils.getText(
                                                  '${customer['phone']}',
                                                  color: AppC.subText)),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Utils.getText(
                                              ' ${customer['rental_start_date']}',
                                              color: AppC.subText),
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
        }),
      ),
      drawer: const DrawerView(),
    );
  }
}
