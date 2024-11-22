import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/firestore.dart';
import 'package:skillborn/services/models.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> initializeUserData(User user) async {
    final userRef = _db.collection('users').doc(user.uid);

    // Check if the user document exists
    final doc = await userRef.get();
    if (!doc.exists) {
      // Set default data for a new user
      await userRef.set({
        'name': user.isAnonymous ? 'Guest' : user.displayName ?? 'User',
        'email': user.isAnonymous ? '' : user.email ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'settings': {
          'theme': 'light',
          'notificationsEnabled': true,
        }
      });

      // Initialize the tasks subcollection with default tasks
      await _initializeDefaultTasks(userRef);
      debugPrint('(auth.dart) Default data initialized for new user: ${user.uid}');
    } else {
      debugPrint('(auth.dart) User data already exists for: ${user.uid}');
    }
  }

  Future<void> _initializeDefaultTasks(DocumentReference userRef) async {
    List<Task> defaultTasks = [
      Task(
        id: Uuid().v4(),
        title: "Make a plan for today",
        note:
            "Taking a few minutes to plan for the day to boost productivity, reduces stress, and stay focused on what matters most.",
        skillExps: [],
        karma: 100,
        index: 0,
        isCompleted: false,
      ),
      Task(
        id: Uuid().v4(),
        title: "Do one thing that scares you",
        note:
            "Do something scary to build courage and resilience by pushing beyond your comfort zone.",
        karma: 100,
        index: 1,
        isCompleted: false,
      ),
      Task(
        id: Uuid().v4(),
        title: "Write down three things you are grateful for today",
        note:
            "Cultivates a positive mindset and improves mental resilience by focusing on what's good in life.",
        karma: 100,
        index: 2,
        isCompleted: false,
      ),
    ];
    await FirestoreService().setTasks(defaultTasks);
  }

  // Anonymous Firebase login
  Future<void> anonLogin() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await initializeUserData(user);
      }
    } on FirebaseAuthException {
      // handle error
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  // Google sign in
  Future<void> googleLogin() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(authCredential);
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await initializeUserData(user);
      }
    } on FirebaseAuthException {
      // handle error
    }
  }

  // Apple sign in
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  // Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    await FirebaseAuth.instance.signInWithCredential(oauthCredential);

    final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await initializeUserData(user);
      }
  }
}
