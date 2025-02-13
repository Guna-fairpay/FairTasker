
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Parts/bloc/parts_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Parts/event/parts_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../Utilities/Utils.dart';
import '../../../../Utilities/appC.dart';
import '../state/parts_state.dart';

class PartView extends StatelessWidget {
  const PartView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PartsBloc>(
      create: (context) => PartsBloc()..add(const GetPartsDataList()),
      child: BlocListener<PartsBloc, PartsState>(
        listener: (context, state) {
          state.isLoading ? EasyLoading.show() : EasyLoading.dismiss();
          },
        child: BlocBuilder<PartsBloc, PartsState>(builder: (context, state) {
          return Scaffold(
            backgroundColor: AppC.white,
            appBar: AppBar(
              title: const Text("Parts"),
              backgroundColor: AppC.appColor,
              automaticallyImplyLeading: false,
              foregroundColor: Colors.white,
              actions: [
                IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: ()=>Navigator.pop(context))
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 15),
              child: Column(
                children: [
                  Row(spacing: 10,
                    children: [
                      Expanded(
                        child: Utils.getSearchBarUI(
                            () {},
                            (value) =>
                                context.read<PartsBloc>().add(SearchPartsEvent(value)),
                            state.searchController),
                      ),
                      Utils.getAddFilledButton('Add', () =>
                          context.read<PartsBloc>().add(const AddPartsEvent('','',8,))),
                    ],
                  ),
                  Expanded(
                    child: ListView.separated(
                       itemCount: state.filteredResponse.length,
                      itemBuilder: (context, index) {
                        final part = state.filteredResponse[index];
                        return ListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                          minVerticalPadding: 0,
                          title: Utils.getText(
                            part['name'] ?? '',
                            weight: FontWeight.bold,
                            overFlow: TextOverflow.ellipsis,
                          ),
                          trailing: const Icon(
                            Icons.delete_outline,
                            color: AppC.redAccent,),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => const Divider(
                      color: Colors.grey,
                      thickness: 0.5,),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
