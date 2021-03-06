import 'package:firebase_padc/pages/text_recognition_page.dart';
import 'package:firebase_padc/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blocs/news_feed_bloc.dart';
import '../resources/dimens.dart';
import '../viewitems/news_feed_item_view.dart';
import 'add_new_post_page.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NewsFeedBloc(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Container(
            margin: const EdgeInsets.only(
              left: MARGIN_MEDIUM,
            ),
            child: const Text(
              "Social",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: TEXT_HEADING_1X,
                color: Colors.black,
              ),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () =>
                  navigateToScreen(context, const TextRecognitionPage()),
              child: Container(
                margin: const EdgeInsets.only(
                  right: MARGIN_LARGE,
                ),
                child: const Icon(
                  Icons.face_outlined,
                  color: Colors.grey,
                  size: MARGIN_LARGE,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.only(
                  right: MARGIN_LARGE,
                ),
                child: const Icon(
                  Icons.search,
                  color: Colors.grey,
                  size: MARGIN_LARGE,
                ),
              ),
            ),
            Consumer<NewsFeedBloc>(
              builder: (context, bloc, child) => GestureDetector(
                onTap: () {
                  bloc.onTapLogout().then(
                      (_) => navigateToScreen(context, const LoginPage()));
                },
                child: Container(
                  margin: const EdgeInsets.only(
                    right: MARGIN_LARGE,
                  ),
                  child: const Icon(
                    Icons.logout,
                    color: Colors.red,
                    size: MARGIN_LARGE,
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            navigateToScreen(context, const AddNewPostPage());
            //FirebaseCrashlytics.instance.crash();
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Consumer<NewsFeedBloc>(
            builder: (context, bloc, child) => ListView.separated(
              padding: const EdgeInsets.symmetric(
                vertical: MARGIN_LARGE,
                horizontal: MARGIN_LARGE,
              ),
              itemBuilder: (context, index) {
                return NewsFeedItemView(
                  mNewsFeed: bloc.newsFeed?[index],
                  onTapDelete: (newsFeedId) {
                    bloc.onTapDeletePost(newsFeedId);
                  },
                  onTapEdit: (newsFeedId) {
                    Future.delayed(const Duration(milliseconds: 1000))
                        .then((value) {
                      navigateToScreen(
                          context,
                          AddNewPostPage(
                            newsFeedId: newsFeedId,
                          ));
                    });
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: MARGIN_XLARGE,
                );
              },
              itemCount: bloc.newsFeed?.length ?? 0,
            ),
          ),
        ),
      ),
    );
  }
}
