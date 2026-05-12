enum MatchStatus {
  scheduled,
  live,
  halfTime,
  fullTime,
  postponed,
  cancelled,
  suspended,
  unknown,
}

class MatchStatusMapper {
  static MatchStatus fromRaw(String? raw) {
    switch (raw?.toLowerCase()) {
      case 'scheduled':
      case 'ns':
      case 'not_started':
        return MatchStatus.scheduled;
      case 'live':
      case 'in_progress':
        return MatchStatus.live;
      case 'ht':
      case 'half_time':
        return MatchStatus.halfTime;
      case 'ft':
      case 'finished':
      case 'full_time':
        return MatchStatus.fullTime;
      case 'postponed':
        return MatchStatus.postponed;
      case 'cancelled':
        return MatchStatus.cancelled;
      case 'suspended':
        return MatchStatus.suspended;
      default:
        return MatchStatus.unknown;
    }
  }
}

extension MatchStatusX on MatchStatus {
  String get label => switch (this) {
    MatchStatus.scheduled => '未开赛',
    MatchStatus.live => '直播中',
    MatchStatus.halfTime => '中场',
    MatchStatus.fullTime => '完场',
    MatchStatus.postponed => '延期',
    MatchStatus.cancelled => '取消',
    MatchStatus.suspended => '中断',
    MatchStatus.unknown => '未知',
  };

  bool get isLive => this == MatchStatus.live || this == MatchStatus.halfTime;
}
