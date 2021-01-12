import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../pages/foundation_members_pages/settings_pages/authorization_info_page.dart';
import '../../models/help_request.dart';
import '../../models/user.dart';
import '../../pages/foundation_members_pages/settings_pages/account.dart';
import '../../pages/foundation_members_pages/wards/wards_page.dart';
import '../../pages/foundation_members_pages/staff/staff_page.dart';
import '../../pages/foundation_members_pages/wards/foundation_wards_flow/foundation_ward_info_page.dart';
import '../../pages/foundation_members_pages/wards/foundation_wards_flow/help_request_info_page.dart';
import '../../pages/foundation_members_pages/staff/volunteers_flow/staff_info_page.dart';
import '../../pages/foundation_members_pages/staff/volunteers_flow/volunteering_request_info_page.dart';
import '../../pages/foundation_members_pages/settings_pages/account_info_page.dart';
import '../../pages/foundation_members_pages/admin_pages/admin_navigation.dart';
import '../../pages/foundation_members_pages/admin_pages/generate_admin_code/generate_admin_code_page.dart';
import '../../pages/foundation_members_pages/settings_pages/settings_page.dart';
import '../../pages/foundation_members_pages/volunteer_pages/volunteer_navigation.dart';
import '../../pages/guest_pages/new_help_request_page.dart';
import '../../pages/start_pages/registration/account_type_choice_page.dart';
import '../../pages/start_pages/authorization/authorization_page.dart';
import '../../pages/start_pages/registration/registration_page.dart';
import '../../pages/start_pages/start_page.dart';
import '../../enums/roles_enum.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Map<String, dynamic> args = settings.arguments;
    var page;
    switch (settings.name) {
      case '/':
        page = StartPage();
        break;
      case '/new_help_request':
        page = NewHelpRequest();
        break;
      case '/account_type_choice':
        page = AccountTypeChoicePage();
        break;
      case '/authorization':
        page = Authorization();
        break;
      case '/registration':
        if (args['accountRole'] != null && args['accountRole'] is Role) {
          page = Registration(
            accountRole: args['accountRole'],
          );
        }
        break;
      case '/account_info':
        if ((args['accountRole'] == null || args['accountRole'] is Role) &&
            args['title'] != null &&
            args['title'] is String) {
          page = AccountInfo(
            accountRole: args['accountRole'],
            title: args['title'],
          );
        }
        break;
      case '/staff_info':
        if (args['staff'] != null && args['staff'] is User) {
          page = StaffInfo(
            volunteer: args['staff'],
          );
        }
        break;
      case '/foundation_ward_info':
        if (args['help_request'] != null &&
            args['help_request'] is HelpRequest) {
          page = FoundationWardInfo(
            helpRequest: args['help_request'],
          );
        }
        break;
      case '/volunteering_request_info':
        if (args['volunteering_request'] != null &&
            args['volunteering_request'] is User) {
          page = VolunteeringRequestInfo(
            volunteer: args['volunteering_request'],
          );
        }
        break;
      case '/help_request_info':
        if (args['help_request'] != null &&
            args['help_request'] is HelpRequest) {
          page = HelpRequestInfo(
            helpRequest: args['help_request'],
          );
        }
        break;
      case '/volunteer_navigation':
        page = VolunteerNavigation();
        break;
      case '/admin_navigation':
        page = AdminNavigation();
        break;
      case '/staff':
        if (args['accountRole'] != null && args['accountRole'] is Role) {
          page = Staff(
            accountRole: args['accountRole'],
          );
        }
        break;
      case '/wards':
        page = Wards();
        break;
      case '/settings/account':
        page = Account();
        break;
      case '/settings/authorization_info':
        page = AuthorizationInfo();
        break;
      case '/settings':
        page = Settings();
        break;
      case '/settings/generate_admin_code':
        page = GenerateAdminCodePage();
        break;
      default:
        return _errorRoute();
    }
    return MaterialPageRoute(builder: (_) => page ?? StartPage());
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Error'),
          ),
          body: Center(
            child: Text('ERROR!'),
          ));
    });
  }
}
