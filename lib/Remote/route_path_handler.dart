part of 'route_handler.dart';

mixin Paths {

  String get _login => "login";

  String get _logout => "logout";

  String get _getBearerToken => "getBearerToken";

  String get _getVehicleSearchHistory => "get-vehicle-search-history";

  String get _editToDoApi => "edit-todo";

  String get _updateToDoApi => "update-todo";

  String get _resourcesApi => "getresources";

  String get _groupPersonApi => "group-person";

  String get _completeToDoApi => "complete-todo";

  String get _deleteToDoApi => "delete-todo";

  String get _vehicleCategoriesApi => "vehicle_status/categories";

  String get _vehicleStatusApi => "vehicleStatusApi";

  String get _getCohortsApi => "getCohortsData";

  String get _turoVehiclesList => "getTuroVehiclesList";

  String get _generateInvoiceApi => "generate-invoice";

  String get _updateExpense => "expenses_update";

  String get _expenses => "expenses";

  String get _deleteVehicles => "delete-vehicles";

  String get _getVehicleExpense => "getVehicleExpenses";

  String get _deleteExpenseImage => "expense_attachment";

  String get _deleteExpenseTodo => "delete-expense-todo";

  String get _miscellaneousVehicles => "vehicle_config/miscellaneous_vehicles";

  String get _saveNote => "vehicle_status/save_note/";

  String get _createStatusToDo => "create-status-todo";

  String get _users => "user-list";

  String get _vehicleStatusCheck => "vehicle_status_checklist_api/";

  String get _updateStatusToDo => "update-status-todo";

  String get _getFilter => "getFilter";

  String get _saveFilter => "saveFilter";

  String get _expenseApprove => "expense-approval";

  String get _locations => "locations";

  String get _location_address => "location_address";

  String get _getBranch => "getBranch";

  String get _vendors => "vendors";

  String get _vendorTypes => "vendor-types";

  String get _vendorImageDelete => "vendor-image-delete";

  String get _vehiclePartsList => "vehicle-parts-list";

  String get _vehicleSupplies => "vehicle-supplies";

  String get _taskCategoryGroup => "taskCategoryGroup";

  String get _getToDoList => "todo-data";

  String get _groupVehicle => "group-vehicle";

  String get _activeVehicles => "active_vehicles";

  String get _saveBouncieVehicle => "save-bouncie-vehicle";

  String get _taskExpenseData => "task-expenses-data";

  String get _getWorkingHoursByUser => "getWorkingHourByUser";

  String get _userPunchList => "userPunchList";

  String get _expensesCategory => "expenses_category";

  String get _paymentType => "payment-methods";

  String get _getTodoDetails => "get-todo-details";

  String get _getPersonExpense => "ajaxPersonExpense";

  String get _getEmployeeList => "employeeList";

  String get _personExpenseApproval => "person-expense-approval";

  String get _editPersonExpense => "editPersonExpense";

  String get _personExpense => "personExpenses";

  String get _personExpenseAdd => "storePersonExpense";

  String get _updatePersonExpense => "updatePersonExpense";

  String get _personExpenseAttachment => "person_expense_attachment";

  String get _personExpenseHistory => "ajaxPersonExpense";

  String get _expenseCategories => "expenseCategories";

  String get _changeToDoByGroup => "change-todo-by-group";

  String get _swapToDo => "swap-todo";

  String get _getPreviousOdometer => "getPreviousOdometer";

  String get _getTodoOdometer => "getTodoOdometer";

  String get _addTodoOdometer => "addTodoOdometer";

  String get _addTodo => "add-todo";

  String get _relatedToDos => "related-todos";

  String get _expenseLogs => "expenseLogs";

  String get _deleteTodoImage => "deleteTodoImage";

  String get _vehiclesApi => "vehiclesApi";

  String get _editVehicleExpenseDetails => "filter?vin";

  String get _privateRentalVehiclesList => "private_rental_vehicles_list";

  String get _privateRentalCustomersList => "private_rental_customers_list";

  String get _getEditPrivateRental => "private_rental_edit";

  String get _addPrivateRental => "private_rental_assign";

  String get _editPrivateRental => "private_rental_update";

  String get _vehicleImages => "vehicle_images";

  String get _feedback => "feedback";

  String get _getVoiceTextList => "getVoiceTextList";

  String get _vehicleNotesHistory => "vehicle_notes_history";

  String get _updateNote => "vehicle_status/update_note/";

  String get _deleteNote => "vehicle_status/delete_note/";

  String get _vehicleConfig => "vehicle_config/categories";

  String get _vehicleConfigCheckList => "vehicle_config/checklist";

  String get _vehicleStatusCheckList => "vehicle_status_checklist_api";

  String get _createChecklistTodo => "create-checklist-todo";

  String get _vehicleStatusChecklist => "vehicle_status/checklist";

  String get _vehicleStatusUpdate => "vehicleStatusUpdate";

  String get _saveAudio => "save-audio";

  String get _checklistReorder => "vehicle_config/checklist_reorder";

  String get _notes => "notes";

  String get _updateNoteStatus => "updateNoteStatus";

  String get _addNoteItem => "addNoteItem";

  String get _updateNoteItem => "updateNoteItem";

  String get _removeNoteItem => "removeNoteItem";

  String get _saveWorkingHour => "saveWorkingHour";

  String get _updateWorkingHour => "updateWorkingHour";

  String get _getTaskCategory => "taskCategory";

  String get _deleteTaskCategory => "deleteTaskCategory";

  String get _addTaskCategory => "addTaskCategory";

  String get _updateTaskCategory => "updateTaskCategory";

  String get _deleteRecurringTodo => "delete-recurring-todo";

  String get _toDoDataRange => "todo-data-range";

  String get _employeeActiveHours => "employeeActiveHours";

  String get _employeeHistoryCount => "employeeHistoryCount";

  String get _employeeWorkHours => "employeeWorkHours";

  String get _importTuroVehicles => "importTuroVehicles";

  String get _uploadTodo => "upload-todo";

  String get _getOdometerValue => "get-vehicle-data";

  String get _deleteVehicleParts => "delete-vehicle-parts";

  String get _deleteSupplies => "delete-supplies";

  String get _getBillList => "bill-list";

  String get _deleteBill => "delete-bill";

  String get _addBill => "upload-bill";

  String get _editBill => "update-bill";

  String get _updateBillStatus => "updataBillStatus";

  String get _getEditBill => "edit-bill";

  String get _deleteBillImage => "delete-bill-image";

  String get _getMaintenanceCheckList => "getMaintanceCheckList";

  String get _addEmployee => "employeeAdd";

  String get _updateEmployee => "updateUser";

  String get _addUser => "addUser";

  String get _todo => "todo";

  String get _swapNoteItems => "swapNoteItems";

  String get _swapNotes => "swapNotes";

  String get _setDefaultVehicleConfig => "setDefaultVehicleConfig";

  String get _getVehicleHistory => "get-vehicle-history";

  String get _getUserList => "userList";

  String get _deleteUser => "deleteUser";

  String get _getRoles => "getroles";

  String get _getDepartments => "getdepartments";

  String get _getEditUser => "editUser";

  String get _deleteTodoNoteAttachment => "deleteTodoNoteAttachment";

  String get _deleteTodoMileageAttachment => "deleteTodoMileageAttachment";

  String get _getCheckList => "getCheckList";

  String get _getPrivateRentalCheck => "getPrivateRentalCheck";

  String get _storeExpenseTemp => "storeExpenseTemp";

  String get _updateExpenseTemp => "updateExpenseTemp";

  String get _update_expense => "update-expense";

  String get _editExpenseTemp => "editExpenseTemp";

  String get _cumulativeCost => "cumulative_cost";

  String get _vehicleStatusUpdateApi => "vehicleStatusUpdateApi";

  String get _todoEmailCount => "todoEmailCount";

  String get _logs => "logs";

  String get _deleteLogAttachment => "delete-log-attachment";

  String get _updateLogs => "update-logs";

  String get _getCompletedTodo => "getCompletedTodo";

  String get _leaveList => "leaveList";

  String get _leaveTypeList => "leaveTypeList";

  String get _addLeave => "addLeave";

  String get _updateLeave => "updateLeave";

  String get _leaveApprove => "leaveApprove";

  String get _tollExport => "toll-export";

  String get _getWorkingHours => "getWorkingHours";

  String get _employeeTaskCount => "employeeTaskCount";

  String get _editComments => "edit-comments";

  String get _employeeTaskHistory => "employeeTaskHistory";

  String get _getConfiguration => "getConfiguration";

  String get _addConfiguration => "add-configuration";

  String get _updateConfiguration => "update-configuration";

  String get _deleteConfiguration => "delete-configuration";

  String get _checkInOutMaster => "checkinout-master";

  String get _checkOilChangeTask => "checkOilChangeTask";

  String get _fairTechSupportTask => "getFairtechSupportTask";

  String get _getProjectStatus => "getProjectStatus";

  String get _getEodReports => "getEodReports";

  String get _getFairTechProjects => "getFairtechProjects";

  String get _getEmployeeHistoryByTask => "employeeHistoryByTask";

  String get _getOtherExpense => "ajaxOtherExpense";

  String get _addOtherExpense => "storeOtherExpense";

  String get _updateOtherExpense => "updateOtherExpense";

  String get _getSharedNotes => "products";

  String get _updateProductsStatus => "updateProductsStatus";

  String get _updateProductsItem => "updateProductsItem";

  String get _addProductsItem => "addProductsItem";

  String get _removeProductsItem => "removeProductsItem";

  String get _swapProductsItems => "swapProductsItems";

  String get _privateRentalEditCustomer => "private_rental_edit_customer";

  String get _privateRentalDeleteCustomer => "private_rental_delete_customer";

  String get _privateRentalStoreCustomer => "private_rental_store_customer";

  String get _privateRentalUpdateCustomer => "private_rental_update_customer";

  String get _getToDoModList => "todo-data-mod";

  String get _findCheckInHours => "findCheckInHours";

  String get _checkCleanCarTask => "checkCleanCarTask";

  String get _swapProducts => "swapProducts";

  String get _getBouncieVehicle => "getBouncieVehicle";

  String get _getCode => "get-code";

  String get _getBouncieToken => "getBouncieToken";

  String get _getDepartmentList => "departmentList";

  String get _getUsers => "getUsers";

  String get _getEditDepartment => "editDepartment";

  String get _updateDepartment => "updateDepartment";

  String get _addDepartment => "addDepartment";

  String get _deleteDepartment => "deleteDepartment";

  String get _getPermissionList => "permissionList";

  String get _getEditPermission => "editPermission";

  String get _addPermission => "addPermission";

  String get _updatePermission => "updatePermission";

  String get _deletePermission => "deletePermission";

  String get _roleList => "roleList";

  String get _editRole => "editRole";

  String get _editUserRole => "editUserRole";

  String get _updateUserRole => "updateRole";

  String get _addUserRole => "addRole";

  String get _deleteRole => "deleteRole;";

  String get _vehicleExpenses => "vehilceExpenses";

  String get _getApproveTask => "getApproveTask";

  String get _approveTodo => "approveTodo";

  String get _getBouncies => "getBouncies";

  String get _checkInOut => "checkInOut";
}