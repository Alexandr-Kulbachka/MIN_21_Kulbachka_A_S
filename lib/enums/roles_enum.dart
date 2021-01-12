enum Role { admin, volunteer }

extension RoleExtension on Role {
  String get title {
    switch (this) {
      case Role.admin:
        return 'admin';
      case Role.volunteer:
        return 'volunteer';
      default:
        return null;
    }
  }
}

Role roleFromString(String value) {
  switch (value) {
    case 'admin':
      return Role.admin;
    case 'volunteer':
      return Role.volunteer;
    default:
      return null;
  }
}
