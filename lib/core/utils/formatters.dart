import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';

String formatMwk(Decimal amount) {
  final formatter = NumberFormat('#,##0.00', 'en_US');
  return 'MWK ${formatter.format(amount.toDouble())}';
}

String formatTimeAgo(DateTime date) {
  final now = DateTime.now();
  final diff = now.difference(date);

  if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
  if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';
  return '${(diff.inDays / 365).floor()}y ago';
}

String truncateDid(String did) {
  if (did.length <= 16) return did;
  final prefix = did.substring(0, did.length - 6);
  final suffix = did.substring(did.length - 4);
  return '$prefix****$suffix';
}

String obscureBalance(String balance) {
  return '\u2022\u2022\u2022\u2022\u2022\u2022';
}
