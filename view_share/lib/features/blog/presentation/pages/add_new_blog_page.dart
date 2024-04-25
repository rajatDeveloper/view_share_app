import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:view_share/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:view_share/core/common/widgets/loader.dart';
import 'package:view_share/core/consts/constants.dart';
import 'package:view_share/core/theme/app_color.dart';
import 'package:view_share/core/utils/pick_image.dart';
import 'package:view_share/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:view_share/features/blog/presentation/pages/blog_page.dart';
import 'package:view_share/features/blog/presentation/widgets/blog_editor.dart';
import 'package:view_share/utils/helpfull_functions.dart';

class AddNewBlogPage extends StatefulWidget {
  static const String tag = "AddNew";
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  List<String> selectedTopics = [];
  File? image;
  final formKey = GlobalKey<FormState>();

  void selectImage() async {
    final selectedImage = await pickImage();
    if (selectedImage != null) {
      image = selectedImage;
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  void uploadBlog() {
    final posterId =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
    context.read<BlogBloc>().add(BlogUpload(
          posterId: posterId,
          image: image!,
          title: titleController.text.trim(),
          content: contentController.text.trim(),
          topics: selectedTopics,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add New Blog'),
          actions: [
            IconButton(
              icon: const Icon(Icons.done),
              onPressed: () {
                if (formKey.currentState!.validate() &&
                    selectedTopics.isNotEmpty &&
                    image != null) {
                  uploadBlog();
                }
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<BlogBloc, BlogState>(
            listener: (context, state) {
              if (state is BlogFailure) {
                showSnackBar(context, state.error);
              } else if (state is BlogUploadSuccess) {
                showSnackBar(context, 'Blog Added Successfully');

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  BlogPage.tag,
                  (route) => false,
                );
              }
            },
            builder: (context, state) {
              if (state is BlogLoading) {
                return const Loader();
              }
              return SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      image != null
                          ? GestureDetector(
                              onTap: selectImage,
                              child: SizedBox(
                                  height: 160,
                                  width: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      image!,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                            )
                          : GestureDetector(
                              onTap: selectImage,
                              child: DottedBorder(
                                color: AppColor.borderColor,
                                strokeWidth: 2,
                                radius: const Radius.circular(12),
                                child: SizedBox(
                                  height: 150,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Icon(
                                        Icons.add_a_photo,
                                        size: 40,
                                      ),
                                      Text(
                                        'Select your image',
                                        style: TextStyle(
                                            fontSize: getFontSize(
                                                18, getDeviceWidth(context))),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(
                        height: getDeviceHeight(context) * 0.02,
                      ),
                      //list of cat
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: Constants.topics
                              .map((e) => Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (selectedTopics.contains(e)) {
                                          selectedTopics.remove(e);
                                        } else {
                                          selectedTopics.add(e);
                                        }
                                        setState(() {});
                                      },
                                      child: Chip(
                                          color: selectedTopics.contains(e)
                                              ? const MaterialStatePropertyAll(
                                                  AppColor.gradient1)
                                              : const MaterialStatePropertyAll(
                                                  AppColor.backgroundColor),
                                          side: const BorderSide(
                                              color: AppColor.borderColor),
                                          label: Text(e)),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                      SizedBox(
                        height: getDeviceHeight(context) * 0.02,
                      ),
                      BlogEditor(
                          controller: titleController, hintText: 'Blog Title'),
                      SizedBox(
                        height: getDeviceHeight(context) * 0.01,
                      ),
                      BlogEditor(
                          controller: contentController,
                          hintText: 'Blog Content')
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}
