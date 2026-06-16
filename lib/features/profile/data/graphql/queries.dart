const String profileQuery = r'''
  query Profile {
    me {
      id fullName email kycLevel kycStatus
      financialHealthScore avatarUrl
    }
    financialHealthScore {
      score savingsConsistency loanRepaymentRate
      challengeCompletions accountAgeDays kycLevel
    }
  }
''';

const String myBadgesQuery = r'''
  query MyBadges {
    myBadges {
      badgeId name awardedAt
    }
  }
''';

const String updateProfileMutation = r'''
  mutation UpdateProfile($avatarUrl: String) {
    updateProfile(avatarUrl: $avatarUrl) {
      id avatarUrl
    }
  }
''';

const String updateSettingsMutation = r'''
  mutation UpdateSettings(
    $showOnLeaderboard: Boolean
    $publicProfile: Boolean
    $notificationsEnabled: Boolean
    $blurBalanceEnabled: Boolean
    $fullName: String
    $phone: String
  ) {
    updateProfile(
      showOnLeaderboard: $showOnLeaderboard
      publicProfile: $publicProfile
      notificationsEnabled: $notificationsEnabled
      blurBalanceEnabled: $blurBalanceEnabled
      fullName: $fullName
      phone: $phone
    ) {
      id fullName email showOnLeaderboard publicProfile
      notificationsEnabled blurBalanceEnabled
    }
  }
''';

const String changePasswordMutation = r'''
  mutation ChangePassword($oldPassword: String!, $newPassword: String!) {
    changePassword(oldPassword: $oldPassword, newPassword: $newPassword)
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
      id deviceFingerprint ipAddress insertedAt expiresAt
    }
  }
''';
