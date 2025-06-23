part of 'project_status_ui.dart';

class ProjectStatusList extends StatelessWidget {
  const ProjectStatusList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectStatusBloc, ProjectStatusStates>(builder: (context, state) => (context.watch<ProjectStatusBloc>().todosFiltered.isNotEmpty) ? Expanded(child: ListView.separated(
      separatorBuilder: (context, index) => 5.spMin.height,
      itemBuilder: (context, index) {
        var list = context.watch<ProjectStatusBloc>().todosFiltered;
        var model = list[index];
        return ProjectStatusListItem(model: model);
      }, itemCount: context.watch<ProjectStatusBloc>().todosFiltered.length,
    )) : const EmptyWidget(withExpand: true));
  }
}
