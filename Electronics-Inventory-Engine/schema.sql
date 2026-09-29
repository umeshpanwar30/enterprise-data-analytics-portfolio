-- LEVEL 1: CLEANING AND INITIALIZING B2B WAREHOUSE SCHEMA
DROP TABLE IF EXISTS supply_orders CASCADE;
DROP TABLE IF EXISTS electronics_inventory CASCADE;

-- 1. CORE ELECTRONICS INVENTORY CATALOG
CREATE TABLE electronics_inventory (
    item_id SERIAL PRIMARY KEY,
    part_number VARCHAR(50) UNIQUE NOT NULL,
    product_name VARCHAR(150) NOT NULL,
    brand VARCHAR(50) NOT NULL,
    cost_price DECIMAL(10, 2) NOT NULL,
    retail_price DECIMAL(10, 2) NOT NULL CHECK (retail_price >= cost_price),
    current_stock INT NOT NULL CHECK (current_stock >= 0),
    safety_stock_level INT NOT NULL CHECK (safety_stock_level >= 0)
);

-- 2. SUPPLY CHAIN TRACKING (B2B Re-orders from Suppliers)
CREATE TABLE supply_orders (
    supply_order_id SERIAL PRIMARY KEY,
    item_id INT REFERENCES electronics_inventory(item_id) ON DELETE CASCADE,
    supplier_name VARCHAR(100) NOT NULL,
    quantity_ordered INT NOT NULL CHECK (quantity_ordered > 0),
    order_date DATE NOT NULL,
    delivery_date DATE, 
    shipping_cost DECIMAL(10, 2) NOT NULL DEFAULT 0.00
);
-- 1. Populating High-Value Electronics Catalog
INSERT INTO electronics_inventory (part_number, product_name, brand, cost_price, retail_price, current_stock, safety_stock_level) VALUES
('X-PRO-15', 'Core i9 Pro Laptop 15inch', 'Dell', 800.00, 1499.00, 15, 5),
('AI-GPU-24', 'Tensor Processing Unit 24GB', 'NVIDIA', 1200.00, 2450.00, 2, 6),    -- CRITICAL: Stock below safety level!
('4K-MON-27', 'Ultra-Wide 4K IPS Monitor', 'LG', 150.00, 320.00, 45, 10),
('NVME-2TB', 'High-Speed Gen5 NVMe SSD', 'Samsung', 70.00, 160.00, 8, 12),     -- CRITICAL: Stock below safety level!
('WK-CHAIR-1', 'Ergonomic Developer Mesh Chair', 'Herman Miller', 450.00, 899.00, 12, 4);

-- 2. Populating B2B Supply Chain Shipment Logs
INSERT INTO supply_orders (item_id, supplier_name, quantity_ordered, order_date, delivery_date, shipping_cost) VALUES
(1, 'Dell Europe Logistics', 20, '2026-08-01', '2026-08-05', 150.00), 
(2, 'NVIDIA Global Supply', 10, '2026-09-10', NULL, 300.00),          
(3, 'LG UK Distribution', 50, '2026-08-15', '2026-08-22', 200.00),    
(4, 'Samsung Components Ltd', 40, '2026-09-15', NULL, 50.00);        
