import 'package:fairpytasker/Bloc/employee_bloc.dart';
import 'package:fairpytasker/Bloc/vehicle_data_bloc.dart';
import 'package:fairpytasker/Event/employee_event.dart';
import 'package:fairpytasker/State/employee_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Utilities/appC.dart';
import '../../Utilities/utils.dart';

class VehicleNotesHistoryViewUi extends StatefulWidget {
  final String? vin;
  final String? vehicleName;

  const VehicleNotesHistoryViewUi({
    super.key,
    required this.vin,
    required this.vehicleName,
  });

  @override
  State<VehicleNotesHistoryViewUi> createState() =>
      _VehicleNotesHistoryViewUiState();
}

class _VehicleNotesHistoryViewUiState extends State<VehicleNotesHistoryViewUi> {
  late VehicleDataBloc vehicleDataBloc;
  late EmployeeBloc employeeBloc;
  final List<Map<String, dynamic>> vehicleNotesHistory = [];
  final List<Map<String, dynamic>> employeeData = [];
  final List<Map<String, dynamic>> filterEmployeeData = [];
  final TextEditingController notesController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  bool loading = false;
  String? vin;
  String? vehicleName;

  void _saveNote() {
    final newNote = {
      'note': notesController.text,
      'created_at': DateTime.now().toIso8601String(),
      'created_by': employeeData.isNotEmpty ? employeeData.first['id'] : null,
    };
    setState(() {
      vehicleNotesHistory.insert(0, newNote);
      notesController.clear();
      dateController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    vehicleDataBloc = VehicleDataBloc();
    employeeBloc = EmployeeBloc();
    vin = widget.vin;
    vehicleName = widget.vehicleName;
    vehicleDataBloc.add(GetVehicleNotesHistoryList(vin: vin));
    employeeBloc.add(const GetEmployeeData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
        title: Utils.getText(
          vehicleName!,
          weight: FontWeight.bold,
          color: AppC.white,
          size: 16,
          overFlow: TextOverflow.ellipsis,
        ),
        titleSpacing: -8,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppC.appColor,
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                vehicleDataBloc..add(GetVehicleNotesHistoryList(vin: vin)),
          ),
          BlocProvider(
            create: (context) => employeeBloc..add(const GetEmployeeData()),
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<VehicleDataBloc, VehicleDataState>(
                listener: (context, state) {
              if (state is VehicleDataLoading) {
                setState(() => loading = true);
              } else if (state is VehicleNotesHistoryLoaded) {
                setState(() {
                  loading = false;
                  vehicleNotesHistory.clear();
                  vehicleNotesHistory.addAll(state.data ?? []);
                });
              }
            }),
            BlocListener<EmployeeBloc, EmployeeState>(
                listener: (context, state) {
              if (state is EmployeeListLoaded) {
                setState(() {
                  employeeData.clear();
                  employeeData.addAll(state.data ?? []);
                  filterEmployeeData.addAll(state.data ?? []);
                });
              }
            }),
          ],
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Utils.getBorderedMultilineTextField(
                        'Notes',
                        notesController,
                        minLines: 10,
                        fillColor: AppC.white,
                        autofocus: false,
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 40,
                        child:
                            Utils.getTextFormField(
                          'dd-mm-YYYY',
                          dateController,
                          suffixIcon: const Icon(Icons.date_range,
                              color: AppC.appColor),
                          readOnly: true,
                          onTapCallback: () {
                            Utils.datePicker(
                              context,
                              '',
                              initial: DateTime.parse("1970-01-01"),
                            ).then((value) {
                              if (value != null) {
                                dateController.text =
                                    Utils.convertDateTimeToTheFormat(
                                        value.toString());
                              }
                            });
                          },
                          label: Utils.getText('', color: AppC.grey),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 40,
                            child: Utils.getAddFilledButton('Save', () {
                              _saveNote();
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Utils.getText('History',
                          weight: FontWeight.bold, size: 18),
                      ListView.builder(
                        shrinkWrap: true, // Important for nested ListView
                        physics:
                            const NeverScrollableScrollPhysics(), // Disable scrolling for this ListView
                        itemCount: vehicleNotesHistory.length,
                        itemBuilder: (context, index) {
                          final notes = vehicleNotesHistory[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start, // Centers vertically
                                  children: [
                                    Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: AppC.appColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                                0.2), // Shadow color
                                            spreadRadius:
                                                2, // Spread radius of the shadow
                                            blurRadius:
                                                4, // Blur radius of the shadow
                                            offset: const Offset(0,
                                                2), // Offset of the shadow (x, y)
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Utils.getText(
                                          notes['created_by'].toString(),
                                          weight: FontWeight.bold,
                                          color: AppC.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Utils.getText(
                                            Utils.convertDateTimeToTheFormat(
                                                notes['created_at'] ?? ''),
                                            size: 12,
                                          ),
                                          const SizedBox(height: 5),
                                          Utils.getText(
                                            notes['note'] ?? '',
                                            weight: FontWeight.bold,
                                            size: 14,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.edit,
                                        size: 16, color: AppC.appColor),
                                    const SizedBox(width: 10),
                                    const Icon(Icons.delete_outline_sharp,
                                        size: 16, color: AppC.red),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Divider(
                                  color: Colors.grey
                                      .shade300, // Customize shade or color
                                  thickness: 1, // Thickness of the divider
                                  height: 1, // Space taken up by the divider
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (loading) Center(child: Utils.getProgressIndicator(context),),
            ],
          ),
        ),
      ),
    );
  }
}
