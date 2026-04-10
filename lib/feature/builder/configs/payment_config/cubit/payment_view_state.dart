part of 'payment_view_cubit.dart';

final class PaymentViewState {
  final PaymentConfig config;

  const PaymentViewState({required this.config});

  factory PaymentViewState.initial(PaymentConfig config) => PaymentViewState(config: config);
}