import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siren_app/core/common/widgets/loader.dart';
import 'package:siren_app/core/theme/app_pallete.dart';
import 'package:siren_app/core/utils/show_snackbar.dart';
import 'package:siren_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:siren_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:siren_app/features/blog/presentation/pages/maps_page.dart';
import 'package:siren_app/features/blog/presentation/pages/help_page.dart';
import 'package:siren_app/features/blog/presentation/pages/news_page.dart';
import 'package:siren_app/features/blog/presentation/widgets/blog_card.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const BlogPage());
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  // 0 = Home, 1 = Map, 2 = Help, 3 = News
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Fetch blogs when the screen starts
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
  }

  String _titleForIndex(int index) {
    switch (index) {
      case 1:
        return 'Community Map';
      case 2:
        return 'Help & Support';
      case 3:
        return 'Monroe Local News';
      case 0:
      default:
        return 'Siren App';
    }
  }

  Widget _bodyForIndex(int index) {
    switch (index) {
      case 1:
        return const MapsPage();
      case 2:
        return const HelpPage();
      case 3:
        return const NewsPage();
      case 0:
      default:
        // Your original blog list
        return BlocConsumer<BlogBloc, BlogState>(
          listener: (context, state) {
            if (state is BlogFailure) {
              showSnackBar(context, state.error);
            }
          },
          builder: (context, state) {
            if (state is BlogLoading) {
              return const Loader();
            }
            if (state is BlogsDisplaySuccess) {
              return ListView.builder(
                itemCount: state.blogs.length,
                itemBuilder: (context, index) {
                  final blog = state.blogs[index];
                  return BlogCard(
                    blog: blog,
                    color: index % 3 == 0
                        ? AppPallete.gradient1
                        : index % 3 == 1
                            ? AppPallete.gradient2
                            : AppPallete.gradient3,
                  );
                },
              );
            }
            return const SizedBox();
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ Title changes based on selected tab
      appBar: AppBar(
        title: Text(_titleForIndex(_currentIndex)),
        actions: [
          if (_currentIndex == 0) // Only show add button on Home/Blog tab
            IconButton(
              onPressed: () {
                Navigator.push(context, AddNewBlogPage.route());
              },
              icon: const Icon(CupertinoIcons.add_circled),
            ),
        ],
      ),

      // ✅ Body switches between Blog / Map / Help / News
      body: _bodyForIndex(_currentIndex),

      // ✅ Bottom navigation is always visible
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent_outlined),
            label: 'Help',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_outlined),
            label: 'News',
          ),
        ],
      ),
    );
  }
}
