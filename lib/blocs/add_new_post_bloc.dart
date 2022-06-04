import 'dart:io';

import 'package:firebase_padc/data/models/authentication_model_impl.dart';
import 'package:flutter/material.dart';

import '../analytics/firebase_analytics_tracker.dart';
import '../data/models/authentication_model.dart';
import '../data/models/social_model.dart';
import '../data/models/social_model_impl.dart';
import '../data/vos/news_feed_vo.dart';
import '../data/vos/user_vo.dart';
import '../performance/firebase_performance_monitor.dart';
import '../remote_config/firebase_remote_config.dart';

class AddNewPostBloc extends ChangeNotifier {
  String newPostDescription = "";
  bool isAddNewPostError = false;
  bool isDisposed = false;
  bool isLoading = false;

  bool isInEditMode = false;
  String userName = "";
  String profilePicture = "";
  NewsFeedVO? mNewsFeed;

  File? chosenImageFile;

  UserVO? _loggedInUser;

  Color themeColor = Colors.black;

  final SocialModel _model = SocialModelImpl();
  final AuthenticationModel _authenticationModel = AuthenticationModelImpl();

  final FirebaseRemoteConfig _firebaseRemoteConfig = FirebaseRemoteConfig();

  AddNewPostBloc({int? newsFeedId}) {
    _loggedInUser = _authenticationModel.getLoggedInUser();
    if (newsFeedId != null) {
      isInEditMode = true;
      _prepopulateDataForEditMode(newsFeedId);
    } else {
      _prepopulateDataForAddNewPost();
    }
    _sendAnalyticsData(addNewPostScreenReached, null);
    //_startPerformanceMonitor();
    _getRemoteConfigAndChangeTheme();
  }

  void _prepopulateDataForAddNewPost() {
    userName = _loggedInUser?.userName ?? "";
    profilePicture =
        "https://shadowashspiritflame.files.wordpress.com/2016/01/sadness-inside-out.jpg";
    _notifySafely();
  }

  void _prepopulateDataForEditMode(int newsFeedId) {
    _model.getNewsFeedById(newsFeedId).listen((newsFeed) {
      userName = newsFeed.userName ?? "";
      profilePicture = newsFeed.profilePicture ?? "";
      newPostDescription = newsFeed.description ?? "";
      mNewsFeed = newsFeed;
      _notifySafely();
    });
  }

  void onImageChosen(File imageFile) {
    chosenImageFile = imageFile;
    _notifySafely();
  }

  void onTapDeleteImage() {
    chosenImageFile = null;
    _notifySafely();
  }

  void onNewPostTextChanged(String newPostDescription) {
    this.newPostDescription = newPostDescription;
  }

  Future onTapAddNewPost() {
    if (newPostDescription.isEmpty) {
      isAddNewPostError = true;
      _notifySafely();
      return Future.error("Error");
    } else {
      isLoading = true;
      _notifySafely();
      isAddNewPostError = false;
      if (isInEditMode) {
        return _editNewsFeedPost().then((value) {
          isLoading = false;
          _notifySafely();
          _sendAnalyticsData(
              editPostAction, {postId: mNewsFeed?.id.toString() ?? ""});
          //_stopPerformanceMonitor();
        });
      } else {
        return _createNewNewsFeedPost().then((value) {
          isLoading = false;
          _notifySafely();
          _sendAnalyticsData(addNewPostAction, null);
        });
      }
    }
  }

  void _sendAnalyticsData(String name, Map<String, String>? parameters) async {
    await FirebaseAnalyticsTracker().logEvent(name, parameters);
  }

  void _startPerformanceMonitor() {
    FirebasePerformanceMonitor().startTrace();
  }

  void _stopPerformanceMonitor() {
    FirebasePerformanceMonitor().stopTrace();
  }

  void _getRemoteConfigAndChangeTheme() {
    themeColor = _firebaseRemoteConfig.getThemeColorFromRemoteConfig();
    _notifySafely();
  }

  Future<dynamic> _editNewsFeedPost() {
    mNewsFeed?.description = newPostDescription;
    if (mNewsFeed != null) {
      return _model.editPost(mNewsFeed!, chosenImageFile);
    } else {
      return Future.error("Error");
    }
  }

  Future<void> _createNewNewsFeedPost() {
    return _model.addNewPost(newPostDescription, chosenImageFile);
  }

  void _notifySafely() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}
