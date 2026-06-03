const String socialQuery = r'''
  query Social($institutionId: ID!) {
    myGroups { id name status invite_code pool_account_id }
    activeChallenges(institutionId: $institutionId) {
      id title challenge_type reward_points status ends_at
    }
    leaderboard(institutionId: $institutionId) {
      user_id full_name score rank
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
  mutation CreateGroup($name: String!, $groupType: String, $isPublic: Boolean) {
    createGroup(name: $name, group_type: $groupType, is_public: $isPublic) {
      id name invite_code
    }
  }
''';
