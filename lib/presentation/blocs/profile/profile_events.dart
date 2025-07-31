import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileLoadRequested extends ProfileEvent {
  const ProfileLoadRequested();
}

class ProfileFollowRequested extends ProfileEvent {
  const ProfileFollowRequested();
}

class ProfileMessageRequested extends ProfileEvent {
  const ProfileMessageRequested();
} 