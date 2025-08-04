part of 'role_view_main_ui.dart';

class RoleTabViewUI extends StatelessWidget {
  const RoleTabViewUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoleViewBloc, RoleViewState>(
      builder: (context, state) {
        return (state is LoadingState) ? Container() : SafeArea(
          minimum: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppC.grey, width: 0.5)
            ),
            child: Padding(
              padding: 10.spMin.padding,
              child: Column(
                spacing: 10.spMin,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      SuccessButton(
                        icon: Icons.add,
                        text: "Add",
                        onPressed: () =>context.read<RoleViewBloc>().add(AddEditEvent(isRoleEdit: false, isUserEdit: false)),
                      ),
                      const Spacer(flex: 1),
                      Expanded(
                        flex: 6,
                        child: CompactSearchView(
                          controller: context.read<RoleViewBloc>().searchController,
                          onChanged: (value) => context.read<RoleViewBloc>().add(SearchEvent(value)),
                        ),
                      )
                    ],
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(width: Num.borderWidthButton,color: AppC.borderColor))
                    ),
                    child:  Row(
                      children: [
                        CustomTabButton(
                          buttonText: 'Role',
                          value: 1,
                          selectedValue: context.watch<RoleViewBloc>().selectedTabValue,
                          onPressed: (v)=> context.read<RoleViewBloc>().add(TabEvent(v)),
                          ),
                        CustomTabButton(
                          buttonText: 'Users',
                          value: 2,
                          selectedValue: context.watch<RoleViewBloc>().selectedTabValue,
                          onPressed: (v)=> context.read<RoleViewBloc>().add(TabEvent(v)),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children:[
                        switch(context.watch<RoleViewBloc>().selectedTabValue){
                          1 => const RoleListUI(),
                          2 => const UsersListUI(),
                          _ => const Placeholder(color: Colors.brown,)
                        },
                      ],
                    ),
                  ),
                  CompactPagination(
                    currentPage: context.watch<RoleViewBloc>().currentIndex,
                    totalPages: (context.watch<RoleViewBloc>().totalCount / context.watch<RoleViewBloc>().itemsPerPage).ceil(),
                    onPageChanged: (value) => context.read<RoleViewBloc>().add(PaginationEvent(value)),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
