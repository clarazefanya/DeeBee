class ExerciseDbTables {
  // =========================
  // CREATE TABLES
  // =========================

  static const String createCustomersTable = '''
  CREATE TABLE customers (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    city TEXT NOT NULL,
    join_date TEXT NOT NULL
  );
  ''';

  static const String createProductsTable = '''
  CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    price INTEGER NOT NULL,
    stock INTEGER NOT NULL
  );
  ''';

  static const String createTransactionsTable = '''
  CREATE TABLE transactions (
    id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    transaction_date TEXT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
  );
  ''';

  // =========================
  // INSERT DUMMY DATA
  // =========================

  static List<String> dummyDataQueries = [
    // CUSTOMERS (12 data)
    '''
    INSERT INTO customers (id, name, city, join_date) VALUES
    (1, 'Andi Pratama', 'Bandung', '2025-01-10'),
    (2, 'Budi Santoso', 'Jakarta', '2025-02-12'),
    (3, 'Citra Lestari', 'Bogor', '2025-03-05'),
    (4, 'Dewi Anggraini', 'Bekasi', '2025-03-20'),
    (5, 'Eko Saputra', 'Depok', '2025-04-01'),
    (6, 'Fajar Nugroho', 'Bandung', '2025-04-10'),
    (7, 'Gita Maulida', 'Jakarta', '2025-05-02'),
    (8, 'Hendra Wijaya', 'Tangerang', '2025-05-18'),
    (9, 'Intan Permata', 'Bogor', '2025-06-01'),
    (10, 'Joko Susilo', 'Bekasi', '2025-06-15'),
    (11, 'Kirana Dewi', 'Depok', '2025-06-20'),
    (12, 'Lukman Hakim', 'Bandung', '2025-07-01');
    ''',

    // PRODUCTS (12 data)
    '''
    INSERT INTO products (id, name, category, price, stock) VALUES
    (1, 'Beras 5kg', 'Sembako', 75000, 50),
    (2, 'Gula 1kg', 'Sembako', 15000, 100),
    (3, 'Minyak Goreng 1L', 'Sembako', 18000, 80),
    (4, 'Indomie Goreng', 'Mie Instan', 3500, 200),
    (5, 'Indomie Kuah', 'Mie Instan', 3500, 200),
    (6, 'Sabun Mandi', 'Kebutuhan Rumah', 5000, 150),
    (7, 'Shampoo', 'Kebutuhan Rumah', 12000, 90),
    (8, 'Teh Celup', 'Minuman', 8000, 70),
    (9, 'Kopi Sachet', 'Minuman', 3000, 300),
    (10, 'Air Mineral', 'Minuman', 4000, 250),
    (11, 'Susu UHT', 'Minuman', 10000, 120),
    (12, 'Tissue', 'Kebutuhan Rumah', 7000, 110);
    ''',

    // TRANSACTIONS (15 data)
    '''
    INSERT INTO transactions (id, customer_id, product_id, quantity, transaction_date) VALUES
    (1, 1, 1, 1, '2025-07-01'),
    (2, 1, 4, 5, '2025-07-01'),
    (3, 2, 3, 2, '2025-07-02'),
    (4, 2, 9, 10, '2025-07-02'),
    (5, 3, 2, 3, '2025-07-03'),
    (6, 3, 10, 5, '2025-07-03'),
    (7, 4, 5, 4, '2025-07-04'),
    (8, 5, 6, 2, '2025-07-04'),
    (9, 6, 1, 1, '2025-07-05'),
    (10, 6, 7, 1, '2025-07-05'),
    (11, 7, 8, 3, '2025-07-06'),
    (12, 8, 11, 2, '2025-07-06'),
    (13, 9, 12, 4, '2025-07-07'),
    (14, 10, 4, 6, '2025-07-07'),
    (15, 11, 9, 15, '2025-07-08');
    ''',
  ];
}
