import 'package:mocktail/mocktail.dart';
import 'package:app/features/transactions/data/repository.dart';
import 'package:app/features/accounts/data/models/account_models.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

final mockTx1 = TxModel(
  id: '1',
  reference: 'REF001',
  amount: '5000.00',
  transactionType: 'deposit',
  status: 'completed',
  insertedAt: '2024-01-15T10:00:00Z',
);

final mockTx2 = TxModel(
  id: '2',
  reference: 'REF002',
  amount: '2000.00',
  transactionType: 'withdrawal',
  status: 'completed',
  insertedAt: '2024-01-14T10:00:00Z',
);
