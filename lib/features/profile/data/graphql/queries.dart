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
  mutation UpdateProfile($avatar_url: String!) {
    updateProfile(avatar_url: $avatar_url) {
      id avatar_url
    }
  }
''';
