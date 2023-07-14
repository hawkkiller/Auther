import 'package:auther/src/common/database/database.dart';

Object $decodeDriftRemoteException(DriftRemoteException driftRemoteException) {
  Object remoteCause = driftRemoteException.remoteCause;
  while (remoteCause is DriftRemoteException) {
    remoteCause = remoteCause.remoteCause;
  }

  return remoteCause;
}
