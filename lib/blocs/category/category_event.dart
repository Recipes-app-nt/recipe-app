part of 'category_bloc.dart';

sealed class CategoryEvent {}

final class GetCategory extends CategoryEvent {}

final class ErrorEvent extends CategoryEvent {}
