import 'package:flutter/widgets.dart';
import 'package:view_share/features/auth/presentation/pages/signin_page.dart';
import 'package:view_share/features/auth/presentation/pages/signup_page.dart';
import 'package:view_share/features/blog/domain/entities/blog.dart';
import 'package:view_share/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:view_share/features/blog/presentation/pages/blog_page.dart';
import 'package:view_share/features/blog/presentation/pages/blog_viewer_page.dart';

Map<String, Widget Function(BuildContext)> getAppRoutes() {
  Map<String, Widget Function(BuildContext)> appRoutes = {
    //  AgentListScreen.routeName: (context) {
    //       var args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    //       var listData = args['listData'] as List<AgentModel>;
    //       var caseModel = args['caseModel'] as CaseModel;

    //       return AgentListScreen(
    //         agents: listData,
    //         caseModel: caseModel,
    //       );
    //     },

    AddNewBlogPage.tag: (context) => const AddNewBlogPage(),
    SignUpPage.tag: (context) => const SignUpPage(),
    SignInPage.tag: (context) => const SignInPage(),
    BlogPage.tag: (context) => const BlogPage(),
    BlogViewerPage.tag: (context) {
      var args = ModalRoute.of(context)!.settings.arguments as Blog;

      return BlogViewerPage(blog: args);
    }
  };
  return appRoutes;
}
