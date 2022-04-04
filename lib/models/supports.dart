class Support {
  final String id;
  final String type;
  final String value;

  Support({
    this.id = '',
    this.type = '',
    this.value ='',
    
  });

  Support.fromMap(Map snapshot, String id)
      : id = id,
        type = snapshot['type'] ?? '',
        value = snapshot['value'];
}

