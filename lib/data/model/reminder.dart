enum ReminderStatus { pending, done, upcoming, missed, snoozed }

class Reminder {
  final String id;
  final String title;
  final String? titleFil;
  final String time;
  final String status; // 'pending', 'done', 'upcoming', 'missed'
  final String iconName;
  final int tintColor;
  final int iconColor;
  final String date;

  Reminder({
    required this.id,
    required this.title,
    this.titleFil,
    required this.time,
    required this.status,
    required this.iconName,
    required this.tintColor,
    required this.iconColor,
    required this.date,
  });

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'] as String,
      title: map['title'] as String,
      titleFil: map['titleFil'] as String?,
      time: map['time'] as String,
      status: map['status'] as String,
      iconName: map['iconName'] as String,
      tintColor: map['tintColor'] as int,
      iconColor: map['iconColor'] as int,
      date: map['date'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'titleFil': titleFil,
      'time': time,
      'status': status,
      'iconName': iconName,
      'tintColor': tintColor,
      'iconColor': iconColor,
      'date': date,
    };
  }
}
