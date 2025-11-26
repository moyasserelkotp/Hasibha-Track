import '../../../../../shared/core/local/cache_helper.dart';
import 'onboarding_local_data_source.dart';


class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  @override
  Future<bool> saveOnboardingCompletion() async {
    return await CacheHelper.saveData(key: 'onBoardingSeen', value: true);
  }

  @override
  Future<bool> hasCompletedOnboarding() async {
    final result = CacheHelper.getData(key: 'onBoardingSeen');
    return result ?? false;
  }
}
