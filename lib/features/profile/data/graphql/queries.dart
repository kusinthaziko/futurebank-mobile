const String profileQuery = r'''
  query Profile {
    me {
      id full_name email kyc_level kyc_status
      financial_health_score blockchain_did avatar_url
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
