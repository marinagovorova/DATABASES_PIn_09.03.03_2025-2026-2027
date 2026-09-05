SET search_path TO wholesale;

CREATE TABLE manufacturers (
    manufacturer_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    manufacturer_name VARCHAR(100) NOT NULL UNIQUE,
    manufacturer_inn VARCHAR(12) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    country VARCHAR(50) NOT NULL,
    address VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,

    CONSTRAINT chk_manufacturers_inn
        CHECK (manufacturer_inn ~ '^[0-9]{10}$' OR manufacturer_inn ~ '^[0-9]{12}$'),

    CONSTRAINT chk_manufacturers_email
        CHECK (email LIKE '%@%'),

    CONSTRAINT chk_manufacturers_phone
        CHECK (phone ~ '^\+7\([0-9]{3}\)[0-9]{3}-[0-9]{2}-[0-9]{2}$')
);

CREATE TABLE customers (
    customer_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    customer_inn VARCHAR(12) NOT NULL UNIQUE,

    CONSTRAINT chk_customers_phone
        CHECK (phone ~ '^\+7\([0-9]{3}\)[0-9]{3}-[0-9]{2}-[0-9]{2}$'),

    CONSTRAINT chk_customers_email
        CHECK (email LIKE '%@%'),

    CONSTRAINT chk_customers_inn
        CHECK (customer_inn ~ '^[0-9]{10}$' OR customer_inn ~ '^[0-9]{12}$')
);

CREATE TABLE positions (
    position_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    position_name VARCHAR(100) NOT NULL UNIQUE,
    duties VARCHAR(255) NOT NULL,
    salary NUMERIC(12,2) NOT NULL,

    CONSTRAINT chk_positions_salary
        CHECK (salary >= 0)
);

CREATE TABLE measurement_units (
    unit_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    unit_name VARCHAR(50) NOT NULL UNIQUE,
    unit_symbol VARCHAR(10) NOT NULL UNIQUE
);

CREATE TABLE employees (
    employee_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    personnel_number INTEGER NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    passport_data VARCHAR(50) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    position_id INTEGER NOT NULL,

    CONSTRAINT chk_employees_phone
        CHECK (phone ~ '^\+7\([0-9]{3}\)[0-9]{3}-[0-9]{2}-[0-9]{2}$'),

    CONSTRAINT chk_employees_email
        CHECK (email LIKE '%@%'),

    CONSTRAINT fk_employees_positions
        FOREIGN KEY (position_id)
        REFERENCES positions(position_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE contracts (
    contract_number VARCHAR(20) PRIMARY KEY,
    contract_date DATE NOT NULL,
    position_id INTEGER NOT NULL,
    contract_type VARCHAR(50) NOT NULL,
    validity_period INTEGER NOT NULL,
    contract_kind VARCHAR(50) NOT NULL,
    employee_id INTEGER NOT NULL,

    CONSTRAINT chk_contracts_validity_period
        CHECK (validity_period > 0),

    CONSTRAINT chk_contracts_type
        CHECK (contract_type IN ('Supply', 'Sale', 'Mixed')),

    CONSTRAINT chk_contracts_kind
        CHECK (contract_kind IN ('One-time', 'Long-term')),

    CONSTRAINT fk_contracts_positions
        FOREIGN KEY (position_id)
        REFERENCES positions(position_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_contracts_employees
        FOREIGN KEY (employee_id)
        REFERENCES employees(employee_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE suppliers (
    supplier_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL UNIQUE,
    address VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,

    CONSTRAINT chk_suppliers_phone
        CHECK (phone ~ '^\+7\([0-9]{3}\)[0-9]{3}-[0-9]{2}-[0-9]{2}$'),

    CONSTRAINT chk_suppliers_email
        CHECK (email LIKE '%@%')
);

CREATE TABLE products (
    product_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    manufacturer_id INTEGER NOT NULL,
    unit_id INTEGER NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    product_description VARCHAR(255) NOT NULL,
    product_category VARCHAR(50) NOT NULL,

    CONSTRAINT uq_products_name_manufacturer
        UNIQUE (product_name, manufacturer_id),

    CONSTRAINT fk_products_manufacturers
        FOREIGN KEY (manufacturer_id)
        REFERENCES manufacturers(manufacturer_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_products_measurement_units
        FOREIGN KEY (unit_id)
        REFERENCES measurement_units(unit_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE supplies (
    supply_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    supplier_id INTEGER NOT NULL,
    contract_number VARCHAR(20) NOT NULL,
    invoice_id INTEGER,
    supply_date DATE NOT NULL,
    status VARCHAR(30) NOT NULL,
    description VARCHAR(255) NOT NULL,
    waybill_number VARCHAR(20) NOT NULL UNIQUE,
    actual_supply_date DATE,

    CONSTRAINT chk_supplies_status
        CHECK (status IN ('Planned', 'In transit', 'Received', 'Cancelled')),

    CONSTRAINT chk_supplies_actual_date
        CHECK (actual_supply_date IS NULL OR actual_supply_date >= supply_date),

    CONSTRAINT fk_supplies_suppliers
        FOREIGN KEY (supplier_id)
        REFERENCES suppliers(supplier_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_supplies_contracts
        FOREIGN KEY (contract_number)
        REFERENCES contracts(contract_number)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE supply_items (
    supply_item_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    supply_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    batch_number VARCHAR(20) NOT NULL,
    supplied_quantity NUMERIC(12,3) NOT NULL,
    purchase_unit_price NUMERIC(12,2) NOT NULL,
    remaining_stock_quantity NUMERIC(12,3) NOT NULL,

    CONSTRAINT uq_supply_items_batch
        UNIQUE (supply_id, product_id, batch_number),

    CONSTRAINT chk_supply_items_quantity
        CHECK (supplied_quantity > 0),

    CONSTRAINT chk_supply_items_price
        CHECK (purchase_unit_price > 0),

    CONSTRAINT chk_supply_items_remaining_stock
        CHECK (remaining_stock_quantity >= 0 AND remaining_stock_quantity <= supplied_quantity),

    CONSTRAINT fk_supply_items_supplies
        FOREIGN KEY (supply_id)
        REFERENCES supplies(supply_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_supply_items_products
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE orders (
    order_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_status VARCHAR(30) NOT NULL,
    customer_id INTEGER NOT NULL,
    contract_number VARCHAR(20) NOT NULL,
    order_date DATE NOT NULL,

    CONSTRAINT chk_orders_status
        CHECK (order_status IN ('Created', 'Paid', 'Assembled', 'Picked up', 'Cancelled')),

    CONSTRAINT fk_orders_customers
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_orders_contracts
        FOREIGN KEY (contract_number)
        REFERENCES contracts(contract_number)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE order_items (
    order_item_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    supply_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    batch_number VARCHAR(20) NOT NULL,
    ordered_quantity NUMERIC(12,3) NOT NULL,
    sale_unit_price NUMERIC(12,2) NOT NULL,

    CONSTRAINT chk_order_items_quantity
        CHECK (ordered_quantity > 0),

    CONSTRAINT chk_order_items_sale_price
        CHECK (sale_unit_price > 0),

    CONSTRAINT fk_order_items_supplies
        FOREIGN KEY (supply_id)
        REFERENCES supplies(supply_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_order_items_products
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE supply_invoices (
    invoice_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    supply_id INTEGER NOT NULL UNIQUE,
    invoice_amount NUMERIC(12,2) NOT NULL,
    invoice_status VARCHAR(30) NOT NULL,
    creation_date DATE NOT NULL,
    payment_date DATE,

    CONSTRAINT chk_supply_invoices_amount
        CHECK (invoice_amount > 0),

    CONSTRAINT chk_supply_invoices_status
        CHECK (invoice_status IN ('Created', 'Paid', 'Overdue', 'Cancelled')),

    CONSTRAINT chk_supply_invoices_payment_date
        CHECK (payment_date IS NULL OR payment_date >= creation_date),

    CONSTRAINT fk_supply_invoices_supplies
        FOREIGN KEY (supply_id)
        REFERENCES supplies(supply_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

ALTER TABLE supplies
ADD CONSTRAINT fk_supplies_supply_invoices
FOREIGN KEY (invoice_id)
REFERENCES supply_invoices(invoice_id)
ON UPDATE CASCADE
ON DELETE SET NULL;

CREATE TABLE order_invoices (
    invoice_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id INTEGER NOT NULL UNIQUE,
    invoice_amount NUMERIC(12,2) NOT NULL,
    invoice_status VARCHAR(30) NOT NULL,
    creation_date DATE NOT NULL,
    payment_date DATE,

    CONSTRAINT chk_order_invoices_amount
        CHECK (invoice_amount > 0),

    CONSTRAINT chk_order_invoices_status
        CHECK (invoice_status IN ('Created', 'Paid', 'Overdue', 'Cancelled')),

    CONSTRAINT chk_order_invoices_payment_date
        CHECK (payment_date IS NULL OR payment_date >= creation_date),

    CONSTRAINT fk_order_invoices_orders
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

COMMENT ON TABLE manufacturers IS 'Manufacturers of products';
COMMENT ON TABLE customers IS 'Customers purchasing products from the wholesale base';
COMMENT ON TABLE positions IS 'Employee positions';
COMMENT ON TABLE measurement_units IS 'Product measurement units';
COMMENT ON TABLE employees IS 'Employees of the wholesale base';
COMMENT ON TABLE contracts IS 'Contracts used for supplies and sales';
COMMENT ON TABLE suppliers IS 'Supplier companies';
COMMENT ON TABLE products IS 'Products purchased and sold by the wholesale base';
COMMENT ON TABLE supplies IS 'Product supplies to the wholesale base';
COMMENT ON TABLE supply_items IS 'Products and batches included in supplies';
COMMENT ON TABLE orders IS 'Customer orders';
COMMENT ON TABLE order_items IS 'Products included in customer orders';
COMMENT ON TABLE supply_invoices IS 'Invoices related to supplies';
COMMENT ON TABLE order_invoices IS 'Invoices related to customer orders';