class UserModel {
  final int? id;
  final String name;
  final String username;
  final String password;
  final String? phone;
  final String? email;
  final String? role;
  final bool isActive;
  final bool canManageProducts;
  final bool canManageCategories;
  final bool canManageCustomers;
  final bool canManageSuppliers;
  final bool canManageInventory;
  final bool canManageReports;
  final bool canManageSettings;
  final bool canManageUsers;
  final bool canDiscount;
  final bool canDeleteInvoice;
  final bool canHoldOrders;
  final String? createdAt;

  UserModel({
    this.id,
    required this.name,
    required this.username,
    required this.password,
    this.phone,
    this.email,
    this.role,
    this.isActive = true,
    this.canManageProducts = false,
    this.canManageCategories = false,
    this.canManageCustomers = false,
    this.canManageSuppliers = false,
    this.canManageInventory = false,
    this.canManageReports = false,
    this.canManageSettings = false,
    this.canManageUsers = false,
    this.canDiscount = false,
    this.canDeleteInvoice = false,
    this.canHoldOrders = false,
    this.createdAt,
  });

  UserModel copyWith({
    int? id,
    String? name,
    String? username,
    String? password,
    String? phone,
    String? email,
    String? role,
    bool? isActive,
    bool? canManageProducts,
    bool? canManageCategories,
    bool? canManageCustomers,
    bool? canManageSuppliers,
    bool? canManageInventory,
    bool? canManageReports,
    bool? canManageSettings,
    bool? canManageUsers,
    bool? canDiscount,
    bool? canDeleteInvoice,
    bool? canHoldOrders,
    String? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      canManageProducts: canManageProducts ?? this.canManageProducts,
      canManageCategories: canManageCategories ?? this.canManageCategories,
      canManageCustomers: canManageCustomers ?? this.canManageCustomers,
      canManageSuppliers: canManageSuppliers ?? this.canManageSuppliers,
      canManageInventory: canManageInventory ?? this.canManageInventory,
      canManageReports: canManageReports ?? this.canManageReports,
      canManageSettings: canManageSettings ?? this.canManageSettings,
      canManageUsers: canManageUsers ?? this.canManageUsers,
      canDiscount: canDiscount ?? this.canDiscount,
      canDeleteInvoice: canDeleteInvoice ?? this.canDeleteInvoice,
      canHoldOrders: canHoldOrders ?? this.canHoldOrders,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {

    return {
      'id': id,
      'name': name,
      'username': username,
      'password': password,
      'phone': phone,
      'email': email,
      'role': role,
      'is_active': isActive ? 1 : 0,

      'can_manage_products': canManageProducts ? 1 : 0,
      'can_manage_categories': canManageCategories ? 1 : 0,
      'can_manage_customers': canManageCustomers ? 1 : 0,
      'can_manage_suppliers': canManageSuppliers ? 1 : 0,
      'can_manage_inventory': canManageInventory ? 1 : 0,
      'can_manage_reports': canManageReports ? 1 : 0,
      'can_manage_settings': canManageSettings ? 1 : 0,
      'can_manage_users': canManageUsers ? 1 : 0,

      'can_discount': canDiscount ? 1 : 0,
      'can_delete_invoice': canDeleteInvoice ? 1 : 0,
      'can_hold_orders': canHoldOrders ? 1 : 0,
    };
  }



  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      phone: map['phone'],
      email: map['email'],
      role: map['role'],
      isActive: map['is_active'] == 1,

      canManageProducts: map['can_manage_products'] == 1,
      canManageCategories: map['can_manage_categories'] == 1,
      canManageCustomers: map['can_manage_customers'] == 1,
      canManageSuppliers: map['can_manage_suppliers'] == 1,
      canManageInventory: map['can_manage_inventory'] == 1,
      canManageReports: map['can_manage_reports'] == 1,
      canManageSettings: map['can_manage_settings'] == 1,
      canManageUsers: map['can_manage_users'] == 1,

      canDiscount: map['can_discount'] == 1,
      canDeleteInvoice: map['can_delete_invoice'] == 1,
      canHoldOrders: map['can_hold_orders'] == 1,
    );
  }
}