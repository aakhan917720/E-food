import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../models/customer/user_profile_model.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserProfileModel>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<UserProfileModel> {
  UserNotifier() : super(UserProfileModel.empty());

  // FIREBASE GATEWAY BLUEPRINT:
  // This provider syncs with Firestore users collection
  // Document path: users/{userId}
  // Listens to real-time updates via snapshotStream

  void updateProfileName(String newName) {
    state = state.copyWith(name: newName);
    // FIREBASE GATEWAY BLUEPRINT:
    // await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(userId)
    //     .update({'name': newName});
  }

  void setRoleState(String role) {
    state = state.copyWith(userRole: role);
    // FIREBASE GATEWAY BLUEPRINT:
    // Update Firestore user document with role
  }

  void setUserProfile(UserProfileModel profile) {
    state = profile;
  }

  void resetUser() {
    state = UserProfileModel.empty();
    // FIREBASE GATEWAY BLUEPRINT:
    // Clear local cache and unsubscribe from Firestore listeners
  }

// FIREBASE GATEWAY BLUEPRINT:
// Method to fetch user from Firestore by ID
// Future<void> fetchUser(String userId) async {
//   final doc = await FirebaseFirestore.instance
//       .collection('users')
//       .doc(userId)
//       .get();
//   if (doc.exists) {
//     state = UserProfileModel.fromMap(doc.data()!);
//   }
// }
}