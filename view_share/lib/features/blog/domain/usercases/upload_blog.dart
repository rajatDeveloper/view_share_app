import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:view_share/core/error/failures.dart';
import 'package:view_share/core/usecase/usecase.dart';
import 'package:view_share/features/blog/domain/entities/blog.dart';
import 'package:view_share/features/blog/domain/repositories/blog_reploritory.dart';

class UploadBlog implements UseCase<Blog, UploadBlogParms> {
  final BlogRepository blogRepository;

  UploadBlog({required this.blogRepository});
  @override
  Future<Either<Failure, Blog>> call(UploadBlogParms params) async {
    return await blogRepository.uploadBlog(
      image: params.image,
      title: params.title,
      content: params.content,
      posterId: params.posterId,
      topics: params.topics,
    );
  }
}

class UploadBlogParms {
  final File image;
  final String title;
  final String content;
  final String posterId;
  final List<String> topics;

  UploadBlogParms({
    required this.image,
    required this.title,
    required this.content,
    required this.posterId,
    required this.topics,
  });
}
