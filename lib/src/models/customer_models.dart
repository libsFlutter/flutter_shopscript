import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_models.freezed.dart';
part 'customer_models.g.dart';

/// Customer model
@freezed
class Customer with _$Customer {
  const factory Customer({
    required int id,
    required String email,
    String? firstName,
    String? lastName,
    String? phone,
    DateTime? birthDate,
    @Default([]) List<Address> addresses,
    int? defaultShippingAddressId,
    int? defaultBillingAddressId,
    DateTime? createdAt,
    DateTime? modifiedAt,
    @Default({}) Map<String, dynamic> meta,
  }) = _Customer;

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
}

/// Customer address
@freezed
class Address with _$Address {
  const factory Address({
    int? id,
    String? firstName,
    String? lastName,
    String? company,
    required String street,
    String? street2,
    required String city,
    required String region,
    required String postcode,
    required String country,
    String? phone,
    @Default(false) bool isDefaultShipping,
    @Default(false) bool isDefaultBilling,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}

/// Customer registration request
@freezed
class CustomerRegistrationRequest with _$CustomerRegistrationRequest {
  const factory CustomerRegistrationRequest({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
    String? phone,
  }) = _CustomerRegistrationRequest;

  factory CustomerRegistrationRequest.fromJson(Map<String, dynamic> json) =>
      _$CustomerRegistrationRequestFromJson(json);
}

/// Customer update request
@freezed
class CustomerUpdateRequest with _$CustomerUpdateRequest {
  const factory CustomerUpdateRequest({
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    DateTime? birthDate,
  }) = _CustomerUpdateRequest;

  factory CustomerUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$CustomerUpdateRequestFromJson(json);
}

/// Password change request
@freezed
class PasswordChangeRequest with _$PasswordChangeRequest {
  const factory PasswordChangeRequest({
    required String currentPassword,
    required String newPassword,
  }) = _PasswordChangeRequest;

  factory PasswordChangeRequest.fromJson(Map<String, dynamic> json) =>
      _$PasswordChangeRequestFromJson(json);
}

/// Password reset request
@freezed
class PasswordResetRequest with _$PasswordResetRequest {
  const factory PasswordResetRequest({required String email}) =
      _PasswordResetRequest;

  factory PasswordResetRequest.fromJson(Map<String, dynamic> json) =>
      _$PasswordResetRequestFromJson(json);
}
