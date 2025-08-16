class Booking {
  final String id;
  final String serviceId;
  final String userId;
  final DateTime date;
  final String status;
  final String address;
  final String notes;
  final double price;

  Booking({
    required this.id,
    required this.serviceId,
    required this.userId,
    required this.date,
    required this.status,
    required this.address,
    required this.notes,
    required this.price,
  });
} 