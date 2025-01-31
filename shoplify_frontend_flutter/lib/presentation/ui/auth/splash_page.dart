import 'package:flutter/material.dart';
import 'package:shoplify/core/constants/constant.dart';
import 'package:shoplify/core/network/dio_client.dart';
import 'package:shoplify/data/source/secure_storage_data_source.dart';
import 'package:shoplify/data/source/shared_pref_service_impl.dart';
import 'package:shoplify/presentation/resources/routes_manager.dart';
import 'package:shoplify/presentation/service_locator.dart';
import 'package:shoplify/presentation/widgets/loading_widget.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    checkAccessToken();
    super.initState();
  }

  void checkAccessToken() async {
    final sharedPref = SharePrefImpl();
    await sharedPref.init();

    final secureStorage = SecureServiceImpl();
    await secureStorage.init();

    final result = await sl<SecureStorageDataSource>().read(
      Constant.accessToken,
    );
    result.fold((error) {
      checkHasDoneOnboarding();
    }, (data) {
      if (data != null) {
        sl<DioClient>().setAuthToken(data);
        goto(context, Routes.bottomNav);
      } else {
        checkHasDoneOnboarding();
      }
    });
  }

  void checkHasDoneOnboarding() async {
    final result =
        await sl<SharedPrefDataSource>().readBool(Constant.doneOnboarding);
    result.fold((error) {}, (data) {
      if (data == true) {
        goto(context, Routes.loginPage);
      } else {
        goto(context, Routes.onboardingPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: LoadingWidget(),
      ),
    );
  }
}
