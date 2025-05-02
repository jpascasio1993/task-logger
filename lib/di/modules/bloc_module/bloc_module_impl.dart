import 'package:injectable/injectable.dart';
import 'package:task_logger/di/modules/bloc_module/bloc_module.dart';
import 'package:task_logger/domain/repositories/api_health_repository.dart';
import 'package:task_logger/domain/usecases/task/create_tasks.dart';
import 'package:task_logger/domain/usecases/task/delete_tasks.dart';
import 'package:task_logger/domain/usecases/task/get_tasks.dart';
import 'package:task_logger/domain/usecases/task/sync_local_tasks.dart';
import 'package:task_logger/domain/usecases/task/sync_remote_tasks.dart';
import 'package:task_logger/domain/usecases/task/update_tasks.dart';
import 'package:task_logger/domain/usecases/task/watch_tasks.dart';
import 'package:task_logger/features/bloc/app_state_bloc/app_state_bloc.dart';
import 'package:task_logger/features/bloc/dashboard_task_bloc/dashboard_task_bloc.dart';
import 'package:task_logger/features/bloc/form_task_view_state_bloc/form_task_view_state_bloc.dart';
import 'package:task_logger/features/bloc/new_task_bloc/new_task_bloc.dart';
import 'package:task_logger/features/bloc/update_task_bloc/update_task_bloc.dart';

@module
abstract class BlocModuleImpl implements BlocModule {
  @factoryMethod
  @override
  AppStateBloc appStateBloc(ApiHealthRepository apiHealthRepository) {
    return AppStateBloc(apiHealthRepository);
  }

  @factoryMethod
  @override
  DashboardTaskBloc taskBloc(
      GetTasks getTasks,
      DeleteTasks deleteTasks,
      WatchTasks watchTasks,
      SyncLocalTasks syncLocalTasks,
      SyncRemoteTasks syncRemoteTasks) {
    return DashboardTaskBloc(
        getTasks, deleteTasks, watchTasks, syncLocalTasks, syncRemoteTasks);
  }

  @factoryMethod
  @override
  NewTaskBloc newTaskBloc(CreateTasks createTasks) {
    return NewTaskBloc(createTasks);
  }

  @factoryMethod
  @override
  FormTaskViewStateBloc get newTaskViewStateBloc {
    return FormTaskViewStateBloc();
  }

  @factoryMethod
  @override
  UpdateTaskBloc updateTaskBloc(UpdateTasks updateTasks) {
    return UpdateTaskBloc(updateTasks);
  }
}
