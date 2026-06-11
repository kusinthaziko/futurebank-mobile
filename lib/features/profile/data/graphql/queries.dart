const String profileQuery = r'''
  query Profile {
    me {
      id full_name email kyc_level kyc_status
      financial_health_score avatar_url
    }
    financialHealthScore {
      score savings_consistency loan_repayment_rate
      challenge_completions account_age_days kyc_level
    }
  }
''';

const String myBadgesQuery = r'''
  query MyBadges {
    myBadges {
      badge_id name awarded_at
    }
  }
''';

const String updateProfileMutation = r'''
  mutation UpdateProfile($avatar_url: String) {
    updateProfile(avatar_url: $avatar_url) {
      id avatar_url
    }
  }
''';

const String updateSettingsMutation = r'''
  mutation UpdateSettings(
    $show_on_leaderboard: Boolean
    $public_profile: Boolean
    $notifications_enabled: Boolean
    $full_name: String
    $phone: String
  ) {
    updateProfile(
      show_on_leaderboard: $show_on_leaderboard
      public_profile: $public_profile
      notifications_enabled: $notifications_enabled
      full_name: $full_name
      phone: $phone
    ) {
      id full_name email show_on_leaderboard public_profile notifications_enabled
    }
  }
''';

const String changePasswordMutation = r'''
  mutation ChangePassword($old_password: String!, $new_password: String!) {
    changePassword(old_password: $old_password, new_password: $new_password)
  }
''';

const String revokeAllSessionsMutation = r'''
  mutation RevokeAllSessions {
    revokeAllSessions
  }
''';

const String mySessionsQuery = r'''
  query MySessions {
    mySessions {
      id device_fingerprint ip_address inserted_at expires_at
    }
  }
''';
