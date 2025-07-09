part of '../tasker_create_todo.dart';

void _listenNavigation(BuildContext context, AddToDoState state) async {
  if (state is LoadingState) {
    if (!EasyLoading.isShow) EasyLoading.show();
  } else {
    if ((state is! CompletedState) && (EasyLoading.isShow)) EasyLoading.dismiss();
    switch(state) {
      case SuccessState(): Toaster.showSuccess(state.message); break;
      case ErrorState(): Toaster.showError(state.message); break;
      case NewPartState(): context.push(PartsMainUI(title: state.message)); break;
      case NewSupplyState(): context.push(SuppliesMainUI(title: state.message)); break;
      case OpenLinkState(): Utils.openURL(state.link); break;
      case CleanTaskReassignState(): RecleanDialog.show(context, model: state.model, isSaveEvent: false, onPressed: ({isSaveEvent, reasonFiles, reasonMessage}) => context.read<AddToDoBloc>().add(ReassignEvent(isSaveEvent: isSaveEvent, reasonFiles: reasonFiles, reasonMessage: reasonMessage))); break;
      case CompletedState(): context.pop(); break;
      case OilChangeTaskExistState(): {
        final result = await OilChangeTaskExistDialog.show(context, model: state.model);
        if (result ?? false) context.read<AddToDoBloc>().add(DeleteTodoEvent(state.model));
      } break;
    }
  }
}