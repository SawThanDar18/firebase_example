import 'package:flutter/foundation.dart';

import '../data/models/social_model.dart';
import '../data/models/social_model_impl.dart';
import '../data/vos/news_feed_vo.dart';

class NewsFeedBloc extends ChangeNotifier {
  List<NewsFeedVO>? newsFeed;

  final SocialModel _mSocialModel = SocialModelImpl();

  bool isDisposed = false;

  NewsFeedBloc() {
    _mSocialModel.getNewsFeed().listen((newsFeedList) {
      newsFeed = newsFeedList;
      if (!isDisposed) {
        notifyListeners();
      }
    });
  }

  void onTapDeletePost(int postId) async {
    await _mSocialModel.deletePost(postId);
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}
