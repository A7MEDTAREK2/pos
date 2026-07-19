import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'modu_pos.db');

    _database = await openDatabase(
      path,
      version: 23, // ✅ رفعناها من 21 لـ 22 عشان جدول drivers
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

    return _database!;
  }

  Future<void> _onCreate(Database db, int version) async {
    // ===========================
    // Users
    // ===========================
    await db.execute('''
CREATE TABLE users(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  username TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL,
  phone TEXT,
  email TEXT,
  role TEXT NOT NULL DEFAULT 'Cashier',
  is_active INTEGER DEFAULT 1,
  can_manage_products INTEGER DEFAULT 1,
  can_manage_categories INTEGER DEFAULT 1,
  can_manage_customers INTEGER DEFAULT 1,
  can_manage_suppliers INTEGER DEFAULT 1,
  can_manage_inventory INTEGER DEFAULT 1,
  can_manage_reports INTEGER DEFAULT 1,
  can_manage_settings INTEGER DEFAULT 1,
  can_manage_users INTEGER DEFAULT 1,
  can_discount INTEGER DEFAULT 1,
  can_delete_invoice INTEGER DEFAULT 1,
  can_hold_orders INTEGER DEFAULT 1
)
''');

    await db.insert("users", {
      "name": "Admin",
      "username": "admin",
      "password": "123456",
      "phone": "",
      "email": "",
      "role": "Admin",
      "is_active": 1,
      "can_manage_products": 1,
      "can_manage_categories": 1,
      "can_manage_customers": 1,
      "can_manage_suppliers": 1,
      "can_manage_inventory": 1,
      "can_manage_reports": 1,
      "can_manage_settings": 1,
      "can_manage_users": 1,
      "can_discount": 1,
      "can_delete_invoice": 1,
      "can_hold_orders": 1,
    });

    // ===========================
    // Settings
    // ===========================
    await db.execute('''
CREATE TABLE settings(
id INTEGER PRIMARY KEY AUTOINCREMENT,
store_name TEXT NOT NULL,
phone TEXT,
address TEXT,
tax_number TEXT,
currency TEXT NOT NULL,
tax_percentage REAL DEFAULT 0,
language TEXT DEFAULT 'ar',
logo TEXT,
cashier_printer TEXT,
kitchen_printer TEXT,
paper_width INTEGER DEFAULT 80,
tax_enabled INTEGER DEFAULT 1,
auto_print_receipt INTEGER DEFAULT 0,
auto_print_kitchen INTEGER DEFAULT 1,
auto_open_drawer INTEGER DEFAULT 1,
show_logo INTEGER DEFAULT 1,
show_address INTEGER DEFAULT 1,
show_phone INTEGER DEFAULT 1,
show_tax_number INTEGER DEFAULT 0,
show_qr INTEGER DEFAULT 1,
footer_message TEXT DEFAULT ''
)
''');

    await db.insert('settings', {
      'store_name': 'My Store',
      'phone': '',
      'address': '',
      'tax_number': '',
      'currency': 'EGP',
      'tax_percentage': 0,
      'language': 'ar',
      'logo': '',
      'cashier_printer': '',
      'kitchen_printer': '',
      'paper_width': 80,
      'tax_enabled': 1,
      'auto_print_receipt': 0,
      'auto_print_kitchen': 1,
      'auto_open_drawer': 1,
      'show_logo': 1,
      'show_address': 1,
      'show_phone': 1,
      'show_tax_number': 0,
      'show_qr': 1,
      'footer_message': '',
    });

    // ===========================
    // Categories
    // ===========================
    await db.execute('''
CREATE TABLE categories(
id INTEGER PRIMARY KEY AUTOINCREMENT,
name TEXT NOT NULL
)
''');

    // ===========================
    // Products
    // ===========================
    await db.execute('''
CREATE TABLE products(
id INTEGER PRIMARY KEY AUTOINCREMENT,
barcode TEXT UNIQUE,
name TEXT NOT NULL,
cost_price REAL NOT NULL,
sell_price REAL NOT NULL,
quantity INTEGER NOT NULL DEFAULT 0,
category_id INTEGER,
image TEXT,
created_at TEXT NOT NULL,
FOREIGN KEY(category_id) REFERENCES categories(id)
)
''');

    // ===========================
    // Product Sizes
    // ===========================
    await db.execute('''
CREATE TABLE product_sizes(
id INTEGER PRIMARY KEY AUTOINCREMENT,
product_id INTEGER NOT NULL,
size_name TEXT NOT NULL,
price REAL NOT NULL,
FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE CASCADE
)
''');

    // ===========================
    // Customers
    // ===========================
    await db.execute('''
CREATE TABLE customers(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  phone TEXT NOT NULL UNIQUE,
  created_at TEXT NOT NULL
)
''');

    await db.execute('''
CREATE TABLE customer_addresses(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  customer_id INTEGER NOT NULL,
  title TEXT,
  area TEXT NOT NULL,
  address TEXT NOT NULL,
  notes TEXT,
  is_default INTEGER DEFAULT 0,
  created_at TEXT NOT NULL,
  FOREIGN KEY(customer_id)
  REFERENCES customers(id)
  ON DELETE CASCADE
)
''');

    // ===========================
    // Sales
    // ===========================
    await db.execute('''
CREATE TABLE sales(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  order_number INTEGER NOT NULL,
  customer_id INTEGER,
  customer_address_id INTEGER,
  customer_name TEXT,
  customer_phone TEXT,
  customer_address TEXT,
  driver_id INTEGER,
  driver_name TEXT,
  driver_phone TEXT,
  customer_area TEXT,
  user_id INTEGER,
  order_type INTEGER NOT NULL,
  subtotal REAL DEFAULT 0,
  discount REAL DEFAULT 0,
  tax REAL DEFAULT 0,
  delivery_fee REAL DEFAULT 0,
  total REAL NOT NULL,
  payment_method TEXT NOT NULL,
  delivery_status INTEGER DEFAULT 0,
  delivery_driver_id INTEGER,
  delivery_notes TEXT,
  delivery_time TEXT,
  created_at TEXT NOT NULL
)
''');

    // ===========================
    // Sale Items
    // ===========================
    await db.execute('''
CREATE TABLE sale_items(
id INTEGER PRIMARY KEY AUTOINCREMENT,
sale_id INTEGER NOT NULL,
product_id INTEGER NOT NULL,
product_name TEXT,
quantity INTEGER NOT NULL,
price REAL NOT NULL,
size_name TEXT,
total REAL
)
''');

    // ===========================
    // Holding Orders
    // ===========================
    await db.execute('''
CREATE TABLE holding_orders(
  id TEXT PRIMARY KEY,
  order_number INTEGER NOT NULL,
  customer_id INTEGER,
  customer_address_id INTEGER,
  user_id INTEGER,
  subtotal REAL DEFAULT 0,
  discount REAL DEFAULT 0,
  tax REAL DEFAULT 0,
  delivery_fee REAL DEFAULT 0,
  total REAL NOT NULL,
  payment_method TEXT DEFAULT 'Cash',
  order_type INTEGER NOT NULL,
  order_status INTEGER NOT NULL,
  table_number TEXT,
  customer_name TEXT,
  customer_phone TEXT,
  customer_address TEXT,
  driver_id INTEGER,
  driver_name TEXT,
  driver_phone TEXT,
  customer_area TEXT,
  delivery_status INTEGER DEFAULT 0,
  delivery_driver_id INTEGER,
  delivery_notes TEXT,
  delivery_time TEXT,
  created_at TEXT NOT NULL
)
''');

    // ===========================
    // Holding Order Items
    // ===========================
    await db.execute('''
CREATE TABLE holding_order_items(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  holding_order_id TEXT NOT NULL,
  product_id INTEGER NOT NULL,
  product_name TEXT NOT NULL,
  quantity INTEGER NOT NULL,
  price REAL NOT NULL,
  image TEXT,
  note TEXT,
  size_name TEXT,
  FOREIGN KEY(holding_order_id)
  REFERENCES holding_orders(id)
  ON DELETE CASCADE
)
''');

    // ===========================
    // ✅ [جديد] Drivers Table
    // ===========================
    await db.execute('''
CREATE TABLE drivers(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  phone TEXT,
  is_active INTEGER DEFAULT 1,
  created_at TEXT NOT NULL
)
''');
    await db.execute('''
CREATE TABLE print_queue(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  type TEXT NOT NULL,
  payload TEXT NOT NULL,
  status INTEGER NOT NULL DEFAULT 0,
  retry_count INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL,
  last_error TEXT
)
''');
  }

  // ===========================
  // دالة الـ Upgrade
  // ===========================
  Future<void> _onUpgrade(
      Database db,
      int oldVersion,
      int newVersion,
      ) async {
    if (oldVersion < 6) {
      await db.execute(
        'ALTER TABLE holding_orders ADD COLUMN customer_name TEXT',
      );
    }

    if (oldVersion < 7) {
      await db.execute(
        'ALTER TABLE holding_order_items ADD COLUMN image TEXT',
      );

      await db.execute(
        'ALTER TABLE holding_order_items ADD COLUMN note TEXT',
      );
    }

    if (oldVersion < 8) {
      await db.execute('''
CREATE TABLE product_sizes(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id INTEGER NOT NULL,
  size_name TEXT NOT NULL,
  price REAL NOT NULL,
  FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE CASCADE
)
''');

      await db.execute(
        'ALTER TABLE holding_order_items ADD COLUMN size_name TEXT',
      );

      await db.execute(
        'ALTER TABLE sale_items ADD COLUMN size_name TEXT',
      );
    }

    if (oldVersion < 9) {
      await db.execute(
        'ALTER TABLE customers ADD COLUMN address TEXT',
      );

      await db.execute(
        'ALTER TABLE customers ADD COLUMN area TEXT',
      );

      await db.execute(
        'ALTER TABLE customers ADD COLUMN notes TEXT',
      );

      await db.execute(
        'ALTER TABLE customers ADD COLUMN created_at TEXT',
      );
    }

    if (oldVersion < 10) {
      await db.execute('''
CREATE TABLE customer_addresses(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  customer_id INTEGER NOT NULL,
  title TEXT,
  area TEXT NOT NULL,
  address TEXT NOT NULL,
  notes TEXT,
  is_default INTEGER DEFAULT 0,
  created_at TEXT NOT NULL,
  FOREIGN KEY(customer_id)
  REFERENCES customers(id)
  ON DELETE CASCADE
)
''');

      await db.execute('''
CREATE TABLE print_queue (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  type TEXT NOT NULL,
  payload TEXT NOT NULL,
  status INTEGER NOT NULL DEFAULT 0,
  retry_count INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL,
  last_error TEXT
)
''');
      }

    if (oldVersion < 11) {
      await db.execute(
        'ALTER TABLE holding_orders ADD COLUMN customer_address_id INTEGER',
      );
    }

    if (oldVersion < 12) {
      await db.execute(
        'ALTER TABLE sales ADD COLUMN customer_name TEXT',
      );

      await db.execute(
        'ALTER TABLE sales ADD COLUMN customer_phone TEXT',
      );

      await db.execute(
        'ALTER TABLE sales ADD COLUMN order_type INTEGER DEFAULT 0',
      );

      await db.execute(
        'ALTER TABLE sales ADD COLUMN subtotal REAL DEFAULT 0',
      );

      await db.execute(
        'ALTER TABLE sales ADD COLUMN discount REAL DEFAULT 0',
      );

      await db.execute(
        'ALTER TABLE sales ADD COLUMN tax REAL DEFAULT 0',
      );

      await db.execute(
        'ALTER TABLE sales ADD COLUMN delivery_fee REAL DEFAULT 0',
      );

      await db.execute(
        'ALTER TABLE sale_items ADD COLUMN product_name TEXT',
      );

      await db.execute(
        'ALTER TABLE sale_items ADD COLUMN total REAL DEFAULT 0',
      );
    }

    if (oldVersion < 13) {
      await db.execute(
        'ALTER TABLE sale_items ADD COLUMN product_name TEXT',
      );

      await db.execute(
        'ALTER TABLE sale_items ADD COLUMN total REAL DEFAULT 0',
      );
    }

    if (oldVersion < 14) {
      await db.execute(
        'ALTER TABLE sales ADD COLUMN customer_address TEXT',
      );
    }

    if (oldVersion < 15) {
      await db.execute(
        'ALTER TABLE sales ADD COLUMN customer_address_id INTEGER',
      );
    }

    if (oldVersion < 16) {
      await db.execute(
        'ALTER TABLE holding_orders ADD COLUMN subtotal REAL DEFAULT 0',
      );

      await db.execute(
        'ALTER TABLE holding_orders ADD COLUMN discount REAL DEFAULT 0',
      );

      await db.execute(
        'ALTER TABLE holding_orders ADD COLUMN tax REAL DEFAULT 0',
      );

      await db.execute(
        'ALTER TABLE holding_orders ADD COLUMN delivery_fee REAL DEFAULT 0',
      );

      await db.execute(
        "ALTER TABLE holding_orders ADD COLUMN payment_method TEXT DEFAULT 'Cash'",
      );
    }

    if (oldVersion < 17) {
      await db.execute(
        'ALTER TABLE settings ADD COLUMN cashier_printer TEXT',
      );

      await db.execute(
        'ALTER TABLE settings ADD COLUMN kitchen_printer TEXT',
      );

      await db.execute(
        'ALTER TABLE settings ADD COLUMN paper_width INTEGER DEFAULT 80',
      );
    }

    if (oldVersion < 18) {
      await db.execute(
        'ALTER TABLE users ADD COLUMN is_active INTEGER DEFAULT 1',
      );

      await db.execute(
        'ALTER TABLE users ADD COLUMN can_manage_products INTEGER DEFAULT 1',
      );

      await db.execute(
        'ALTER TABLE users ADD COLUMN can_manage_categories INTEGER DEFAULT 1',
      );

      await db.execute(
        'ALTER TABLE users ADD COLUMN can_manage_customers INTEGER DEFAULT 1',
      );

      await db.execute(
        'ALTER TABLE users ADD COLUMN can_manage_suppliers INTEGER DEFAULT 1',
      );

      await db.execute(
        'ALTER TABLE users ADD COLUMN can_manage_inventory INTEGER DEFAULT 1',
      );

      await db.execute(
        'ALTER TABLE users ADD COLUMN can_manage_reports INTEGER DEFAULT 1',
      );

      await db.execute(
        'ALTER TABLE users ADD COLUMN can_manage_settings INTEGER DEFAULT 1',
      );

      await db.execute(
        'ALTER TABLE users ADD COLUMN can_manage_users INTEGER DEFAULT 1',
      );

      await db.execute(
        'ALTER TABLE users ADD COLUMN can_discount INTEGER DEFAULT 1',
      );

      await db.execute(
        'ALTER TABLE users ADD COLUMN can_delete_invoice INTEGER DEFAULT 1',
      );

      await db.execute(
        'ALTER TABLE users ADD COLUMN can_hold_orders INTEGER DEFAULT 1',
      );
    }

    if (oldVersion < 19) {
      await db.execute(
        "ALTER TABLE settings ADD COLUMN tax_enabled INTEGER DEFAULT 1",
      );

      await db.execute(
        "ALTER TABLE settings ADD COLUMN auto_print_receipt INTEGER DEFAULT 0",
      );

      await db.execute(
        "ALTER TABLE settings ADD COLUMN auto_print_kitchen INTEGER DEFAULT 1",
      );

      await db.execute(
        "ALTER TABLE settings ADD COLUMN auto_open_drawer INTEGER DEFAULT 1",
      );

      await db.execute(
        "ALTER TABLE settings ADD COLUMN show_logo INTEGER DEFAULT 1",
      );

      await db.execute(
        "ALTER TABLE settings ADD COLUMN show_address INTEGER DEFAULT 1",
      );

      await db.execute(
        "ALTER TABLE settings ADD COLUMN show_phone INTEGER DEFAULT 1",
      );

      await db.execute(
        "ALTER TABLE settings ADD COLUMN show_tax_number INTEGER DEFAULT 0",
      );

      await db.execute(
        "ALTER TABLE settings ADD COLUMN show_qr INTEGER DEFAULT 1",
      );

      await db.execute(
        "ALTER TABLE settings ADD COLUMN footer_message TEXT DEFAULT ''",
      );
    }

    if (oldVersion < 20) {
      await db.execute(
        "ALTER TABLE holding_orders ADD COLUMN delivery_status INTEGER DEFAULT 0",
      );

      await db.execute(
        "ALTER TABLE holding_orders ADD COLUMN delivery_driver_id INTEGER",
      );

      await db.execute(
        "ALTER TABLE holding_orders ADD COLUMN delivery_notes TEXT",
      );

      await db.execute(
        "ALTER TABLE holding_orders ADD COLUMN delivery_time TEXT",
      );

      await db.execute(
        "ALTER TABLE sales ADD COLUMN delivery_status INTEGER DEFAULT 0",
      );

      await db.execute(
        "ALTER TABLE sales ADD COLUMN delivery_driver_id INTEGER",
      );

      await db.execute(
        "ALTER TABLE sales ADD COLUMN delivery_notes TEXT",
      );

      await db.execute(
        "ALTER TABLE sales ADD COLUMN delivery_time TEXT",
      );
    }

    if (oldVersion < 21) {
      await db.execute(
        "ALTER TABLE holding_orders ADD COLUMN driver_id INTEGER",
      );
      await db.execute(
        "ALTER TABLE holding_orders ADD COLUMN driver_name TEXT",
      );
      await db.execute(
        "ALTER TABLE holding_orders ADD COLUMN driver_phone TEXT",
      );
      await db.execute(
        "ALTER TABLE holding_orders ADD COLUMN customer_area TEXT",
      );

      await db.execute(
        "ALTER TABLE sales ADD COLUMN driver_id INTEGER",
      );
      await db.execute(
        "ALTER TABLE sales ADD COLUMN driver_name TEXT",
      );
      await db.execute(
        "ALTER TABLE sales ADD COLUMN driver_phone TEXT",
      );
      await db.execute(
        "ALTER TABLE sales ADD COLUMN customer_area TEXT",
      );
    }

    // ===========================
    // ✅ [جديد] الترقية إلى الإصدار 22
    // ===========================
    if (oldVersion < 22) {
      // إنشاء جدول drivers
      await db.execute('''
CREATE TABLE IF NOT EXISTS drivers(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  phone TEXT,
  is_active INTEGER DEFAULT 1,
  created_at TEXT NOT NULL
)
''');

      // إضافة عمود driver_id إلى holding_orders إذا لم يكن موجوداً
      try {
        await db.execute(
          'ALTER TABLE holding_orders ADD COLUMN driver_id INTEGER',
        );
      } catch (e) {
        // العمود موجود بالفعل
      }

      // إضافة عمود driver_name إلى holding_orders إذا لم يكن موجوداً
      try {
        await db.execute(
          'ALTER TABLE holding_orders ADD COLUMN driver_name TEXT',
        );
      } catch (e) {
        // العمود موجود بالفعل
      }

      // إضافة عمود driver_name إلى sales إذا لم يكن موجوداً
      try {
        await db.execute(
          'ALTER TABLE sales ADD COLUMN driver_name TEXT',
        );
      } catch (e) {
        // العمود موجود بالفعل
      }
    }
    if (oldVersion < 23) {
      await db.execute('''
  CREATE TABLE print_queue (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    type TEXT NOT NULL,
    payload TEXT NOT NULL,
    status INTEGER NOT NULL DEFAULT 0,
    retry_count INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL,
    last_error TEXT
  )
  ''');
    }

  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }

  }


}