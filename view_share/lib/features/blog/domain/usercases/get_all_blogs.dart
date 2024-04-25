import 'package:fpdart/fpdart.dart';
import 'package:view_share/core/error/failures.dart';
import 'package:view_share/core/usecase/usecase.dart';
import 'package:view_share/features/blog/domain/entities/blog.dart';
import 'package:view_share/features/blog/domain/repositories/blog_reploritory.dart';

class GetAllBlogs implements UseCase<List<Blog>, NoParms> {
  final BlogRepository blogRepository;

  GetAllBlogs({required this.blogRepository});

  @override
  Future<Either<Failure, List<Blog>>> call(NoParms params) async {
    return await blogRepository.getAllBlogs();
  }
}
