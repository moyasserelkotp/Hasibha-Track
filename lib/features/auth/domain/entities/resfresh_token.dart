import 'package:equatable/equatable.dart';

class RefreshToken extends Equatable {
  
  final String? access;
  final String? refresh;


  const RefreshToken({
    required this.access,
    required this.refresh,
  });
  
  @override
  List<Object?> get props => [
    access, refresh, ];
}
