const String socialQuery = r'''
  query Social($institutionId: ID!) {
    myGroups { id name status inviteCode poolAccountId }
    activeChallenges(institutionId: $institutionId) {
      id title description challengeType rewardPoints
      status endsAt participantCount
      targetValue currentProgress joined
    }
    leaderboard(institutionId: $institutionId, period: "all_time") {
      userId fullName score rank avatarUrl
    }
  }
''';

const String groupDetailQuery = r'''
  query GroupDetail($groupId: ID!) {
    groupDetail(id: $groupId) {
      id name status inviteCode poolAccountId
      poolBalance memberCount goal groupType
      topContributors { userId fullName totalContributed avatarUrl }
      recentActivity { userId fullName action amount createdAt }
    }
  }
''';

const String challengeDetailQuery = r'''
  query ChallengeDetail($challengeId: ID!) {
    challengeDetail(id: $challengeId) {
      id title description challengeType rewardPoints
      status endsAt participantCount targetValue
      currentProgress targetProgress joined
      leaderboard { userId fullName score rank avatarUrl }
    }
  }
''';

const String leaderboardQuery = r'''
  query Leaderboard($institutionId: ID!, $period: String) {
    leaderboard(institutionId: $institutionId, period: $period) {
      userId fullName score rank avatarUrl
    }
  }
''';

const String joinGroupMutation = r'''
  mutation JoinGroup($inviteCode: String!) {
    joinGroup(inviteCode: $inviteCode)
  }
''';

const String joinChallengeMutation = r'''
  mutation JoinChallenge($challengeId: ID!) {
    joinChallenge(challengeId: $challengeId)
  }
''';

const String createGroupMutation = r'''
  mutation CreateGroup($name: String!, $groupType: String, $isPublic: Boolean,
      $memberLimit: Int, $goal: String, $deadline: String, $rules: String) {
    createGroup(name: $name, groupType: $groupType, isPublic: $isPublic,
        memberLimit: $memberLimit, goal: $goal, deadline: $deadline, rules: $rules) {
      id name inviteCode
    }
  }
''';

const String contributeToGroupMutation = r'''
  mutation ContributeToGroup($groupId: ID!, $amount: String!) {
    contributeToGroup(groupId: $groupId, amount: $amount) {
      id poolBalance
    }
  }
''';
