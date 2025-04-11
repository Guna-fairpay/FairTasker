import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/ViewPrivateRental/Bloc/private_rental_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/ViewPrivateRental/Bloc/private_rental_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/Private%20Rental/ViewPrivateRental/Bloc/private_rental_bloc.dart';
import 'package:fairpytasker/Component/custom_compact_search_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class PrivateRentalSearchView extends StatelessWidget {
  const PrivateRentalSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrivateRentalBloc, PrivateRentalState>(builder: (context, state) => Expanded(
      flex: 3,
      child: CompactSearchView(controller: context.read<PrivateRentalBloc>().searchController,
        onChanged: (value) => context.read<PrivateRentalBloc>().add(SearchPrivateRentalEvent(value)),
      ),
    ));
  }
}
