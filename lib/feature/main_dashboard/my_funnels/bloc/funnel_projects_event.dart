part of 'funnel_projects_bloc.dart';

@immutable
sealed class FunnelProjectsEvent {
  const FunnelProjectsEvent();
}

class GetFunnelsEvent extends FunnelProjectsEvent {}

class CreateFunnelEvent extends FunnelProjectsEvent {
  final String name;
  final String? description;

  const CreateFunnelEvent({required this.name, this.description});
}

class DeleteFunnelEvent extends FunnelProjectsEvent {
  final String id;

  const DeleteFunnelEvent({required this.id});
}

class UpdateFunnelEvent extends FunnelProjectsEvent {
  final String id;
  final String? name;
  final String? description;
  final int? pageCount;

  const UpdateFunnelEvent({
    required this.id,
    this.name,
    this.description,
    this.pageCount,
  });
}
