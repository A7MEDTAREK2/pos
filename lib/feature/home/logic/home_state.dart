import '../data/model/home_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}
class HomeSuccess extends HomeState {
  final HomeMetricsModel metrics;
  HomeSuccess(this.metrics);
}
class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}