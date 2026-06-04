const String socialQuery = r'''
  query Social($institutionId: ID!) {
    myGroups { id name status invite_code pool_account_id }
    activeChallenges(institutionId: $institutionId) {
      id title description challenge_type reward_points
      status ends_at participant_count
      target_value current_progress joined
    }
    leaderboard(institutionId: $institutionId, period: "all_time") {
      user_id full_name score rank avatar_url
    }
  }
''';

const String groupDetailQuery = r'''
  query GroupDetail($groupId: ID!) {
    groupDetail(id: $groupId) {
      id name status invite_code pool_account_id
      pool_balance member_count goal group_type
      top_contributors { user_id full_name total_contributed avatar_url }
      recent_activity { user_id full_name action amount created_at }
    }
  }
''';

const String challengeDetailQuery = r'''
  query ChallengeDetail($challengeId: ID!) {
    challengeDetail(id: $challengeId) {
      id title description challenge_type reward_points
      status ends_at participant_count target_value
      current_progress target_progress joined
      leaderboard { user_id full_name score rank avatar_url }
    }
  }
''';

const String leaderboardQuery = r'''
  query Leaderboard($institutionId: ID!, $period: String) {
    leaderboard(institutionId: $institutionId, period: $period) {
      user_id full_name score rank avatar_url
    }
  }
''';

const String joinGroupMutation = r'''
  mutation JoinGroup($inviteCode: String!) {
    joinGroup(invite_code: $inviteCode)
  }
''';

const String joinChallengeMutation = r'''
  mutation JoinChallenge($challengeId: ID!) {
    joinChallenge(challenge_id: $challengeId)
  }
''';

const String createGroupMutation = r'''
  mutation CreateGroup($name: String!, $groupType: String, $isPublic: Boolean,
      $memberLimit: Int, $goal: String, $deadline: String, $rules: String) {
    createGroup(name: $name, group_type: $groupType, is_public: $isPublic,
        member_limit: $memberLimit, goal: $goal, deadline: $deadline, rules: $rules) {
      id name invite_code
    }
  }
''';

const String contributeToGroupMutation = r'''
  mutation ContributeToGroup($groupId: ID!, $amount: String!) {
    contributeToGroup(group_id: $groupId, amount: $amount) {
      id pool_balance
    }
  }
''';
