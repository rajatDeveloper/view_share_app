import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:view_share/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:view_share/core/common/widgets/header.dart';
import 'package:view_share/core/common/widgets/loader.dart';
import 'package:view_share/core/theme/app_color.dart';
import 'package:view_share/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:view_share/features/auth/presentation/pages/signup_page.dart';
import 'package:view_share/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:view_share/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:view_share/features/blog/presentation/widgets/blog_card.dart';
import 'package:view_share/utils/helpfull_functions.dart';

class BlogPage extends StatefulWidget {
  static const String tag = 'blog';
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();

    context.read<BlogBloc>().add(BlogFetchAllBlogs());
  }

  final supabase = sb.Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: <Widget>[
      //       const DrawerHeader(
      //         decoration: BoxDecoration(
      //           color: AppColor.gradient1,
      //         ),
      //         child: TopWidget(size: 50),
      //       ),
      //       ListTile(
      //         title: const Text('Developer'),
      //         onTap: () {
      //           // Update the state of the app
      //           // ...
      //           // Then close the drawer
      //           Navigator.pop(context);
      //         },
      //       ),
      //       ListTile(
      //         title: const Text('Item 2'),
      //         onTap: () {
      //           // Update the state of the app
      //           // ...
      //           // Then close the drawer
      //           Navigator.pop(context);
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      appBar: AppBar(
        title: const TopWidget(size: 30),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.add_circled),
            onPressed: () {
              Navigator.pushNamed(context, AddNewBlogPage.tag);
            },
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthNormal || state is AppUserInitial) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  SignUpPage.tag,
                  (route) => false,
                );
              }
            },
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                var res = await supabase.auth.signOut();
                context.read<AuthBloc>().add(AuthLogout());
              },
            ),
          )
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          if (state is BlogDisplaySuccess) {
            return ListView.builder(
                itemCount: state.blogs.length,
                itemBuilder: (context, index) {
                  return BlogCard(
                      blog: state.blogs[index],
                      color: index % 2 == 0
                          ? AppColor.gradient1
                          : AppColor.gradient2);
                });
          }

          return const Text("");
        },
      ),
    );
  }
}
