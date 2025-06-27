import 'package:fairpytasker/main.dart';

class Str{
    static String get BASE_URL => flavor.baseUrl;
    static String get GOPORTAL_BASE_URL => flavor.portalUrl;
    static String get STORAGE_BASE_URL => flavor.storageUrl;
    static String get TASKER_STORAGE_BASE_URL => flavor.taskerStorageUrl;
    static String get LIST_BASE_URL => flavor.returnsUrl;
    static String get TODO_ATTACHMENTS_URL => flavor.attachmentUrl;

    static const String TURO_RESERV_URL = "https://turo.com/us/en/reservation/";
    static const String GETAROUND_RESERV_URL = "https://getaround.com/dashboard/rentals/";

  static const String loginPrefText = 'LoginPref';
  static const String userPermissionPrefText = 'UserPermissionPref';
  static const String userIdPrefText = 'UserIdPref';
  static const String hrmIdPrefText = 'HrmIdPref';
  static const String branchIdPrefText = 'BranchIDPref';
  static const String passwordPrefText = 'PasswordPref';
  static const String rolePrefText = 'RolePref';
  static const String radiusPrefText = 'RadiusPref';
  static const String namePrefText = 'NamePref';
  static const String emailPrefText = 'EmailPref';
  static const String frBearerToken = 'fr_bearerToken';
  static const String accessTokenPrefText = 'AccessTokenPref';
  static const String departmentIdPrefText = 'departmentIdPref';
  static const String userPrefText = 'userDataPref';

  static const String userPunchListRefresh = 'refresh_user_punch_list';

    static const String branchNamePrefText = 'BranchNamePref';
  static const String branchChange = 'branch_has_been_changed';
  static const String valueChange = 'api_value_has_been_changed';

  static const String appName = "FairPYTasker";
  // static const String addExpense = "Add Expenses";
  // static const String expenseList = "Expense List";
  // static const String tagList = "Tag List";
  static const String dashboard = "Dashboard";
  // static const String editExpense = "Edit Expenses";
  // static const String checkInternetConnectionAlert = 'Please check your internet connection.';
  static const String somethingWentWrong = "Something went wrong. Please try again.";
  static const String invalidInputs = "Invalid Inputs";
  static String createTaskAlertText(String value) => "$value is mandatory";
  static String createTodoAlertText(String value) => "$value is mandatory";
  static const String noResultFoundText = 'No result found';
  static const String yesText = 'Yes';
  static const String logout = 'Logout';
  static const String cancelText = 'Cancel';
  static const String alertText = 'Alert';
  static const String emailEmptyValidAlertText = 'Please enter valid Email';
  static const String confirmPasswordMismatchAlertText = 'Confirm Password is mismatching.';
  static const String passwordEmptyValidAlertText = 'Please enter Password of at least 5 characters';
  static const String checkInternetConnectionAlert = 'Please check your internet connection.';
  static const String yourMessageText = 'Your Message';
  static const String chatMessageEmptyAlert = 'Please enter the message to send';

  // PUSHER CLIENT
    /*for general chat : general-chat.{sender_id}.{receiver_id} for todo_ chat : private-chat.{todo_id}*/
  static const String apiKeyPusher = 'f16bb0457188c07c1015';
  static const String clusterKeyPusher = 'ap2';
  static const String generalChatEventPusher = 'general-chat';
  static const String privateChatEventPusher = 'private-chat';
  static String formGeneralChatPuKey(int senderId, int receiverId) => 'general-chat.{$senderId}.{$receiverId}';
  static String formPrivateChatPuKey(String todoId) => 'private-chat.{$todoId}';

  // user permissions
  static const String editExpensePermission = 'Edit-expense';

  //error image URL
    static const errorImage='https://media.wired.com/photos/5a0201b14834c514857a7ed7/master/pass/1217-WI-APHIST-01.jpg';

    static const List<int> platFormCheckIds = [268, 211, 209];

    static const List<int> cleanCarCheckIds = [209, 210]; // 30 IS NOT INCLUDED DUE TO IT'LL SHOW JUST ICON

    static const List<int> reqTaskManagerIds = [3,17,19,20,26,31,32];

    static const List<int> getAroundIds = [268, 177];

    static const List<int> unCompletedOdometer = [257, 268, 324];

    static const List<int> completedOdometer = [212, 210];

    static const List<String> todoEditExpense = ['Check In','Check Out','CheckOut Car Rental','Pickup Car Rental','Email Notofication Form','Refuel Car'];


    static const String noMatchFound = 'No data found. Please check your input and try again.';

    static const String todayToDo = "fetch_todos_for_today";

    static const String addToDoRefresh = "refresh_add";

    static const String editToDoRefresh = "refresh_edit";

    static const String refetchCate = "refresh_category";

    static const String refetchVendorLocation = "refresh_vendor_location";

    static const List<int> green = [209, 211];

    static const List<int> red = [212, 210];

    static const List<int> oilChangeCheckIds = [126, 294, 35];


}