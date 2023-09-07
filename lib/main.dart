import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joyla/blocs/articles/article_bloc.dart';
import 'package:joyla/cubits/auth/auth_cubit.dart';
import 'package:joyla/cubits/profile/profile_cubit.dart';
import 'package:joyla/cubits/tab/tab_cubit.dart';
import 'package:joyla/cubits/user_data/user_data_cubit.dart';
import 'package:joyla/cubits/website_add/website_add_cubit.dart';
import 'package:joyla/cubits/website_fetch/website_fetch_cubit.dart';
import 'package:joyla/data/ServiceLocator.dart';
import 'package:joyla/data/local/storage_repository.dart';
import 'package:joyla/data/network/open_api_service.dart';
import 'package:joyla/data/network/secure_api_service.dart';
import 'package:joyla/data/repositories/article_repository.dart';
import 'package:joyla/data/repositories/auth_repository.dart';
import 'package:joyla/data/repositories/profile_repository.dart';
import 'package:joyla/data/repositories/website_repository.dart';
import 'package:joyla/presentation/app_routes.dart';
import 'package:joyla/utils/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await getSetup();

  await StorageRepository.getInstance();

  runApp(App());
}

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(
            openApiService: getIt.get<OpenApiService>(),
          ),
        ),
        RepositoryProvider(
          create: (context) =>
              ProfileRepository(apiService: getIt.get<SecureApiService>()),
        ),
        RepositoryProvider(
          create: (context) => WebsiteRepository(
            secureApiService: getIt.get<SecureApiService>(),
            openApiService: getIt.get<OpenApiService>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => ArticleRepository(
            secureApiService: getIt.get<SecureApiService>(),
            openApiService: getIt.get<OpenApiService>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
              create: (context) => ArticleBloc(
                  articleRepository: context.read<ArticleRepository>())),
          BlocProvider(create: (context) => TabCubit()),
          BlocProvider(create: (context) => UserDataCubit()),
          BlocProvider(
              create: (context) => ProfileCubit(
                  profileRepository: context.read<ProfileRepository>())),
          BlocProvider(
            create: (context) => WebsiteAddCubit(
                websiteRepository: context.read<WebsiteRepository>()),
          ),
          BlocProvider(
            create: (context) => WebsiteFetchCubit(
                websiteRepository: context.read<WebsiteRepository>()),
          ),
        ],
        child: const MyApp(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark,
          onGenerateRoute: AppRoutes.generateRoute,
          initialRoute: RouteNames.splashScreen,
        );
      },
    );
  }
}
