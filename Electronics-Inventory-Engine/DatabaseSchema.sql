-- 1. CLEANING EXISTING SCHEMAS TO PREVENT STRUCTURAL COLLISIONS
DROP TABLE IF EXISTS public.supply_orders CASCADE;
DROP TABLE IF EXISTS public.electronics_inventory CASCADE;

-- 2. CORE ELECTRONICS INVENTORY CATALOG TABLE
CREATE TABLE public.electronics_inventory (
    item_id SERIAL PRIMARY KEY,
    part_number VARCHAR(50) UNIQUE NOT NULL,
    product_name VARCHAR(150) NOT NULL,
    brand VARCHAR(50) NOT NULL,
    cost_price DECIMAL(10, 2) NOT NULL,
    retail_price DECIMAL(10, 2) NOT NULL CHECK (retail_price >= cost_price),
    current_stock INT NOT NULL CHECK (current_stock >= 0),
    safety_stock_level INT NOT NULL CHECK (safety_stock_level >= 0)
);

-- 3. B2B SUPPLY CHAIN TRACKING (B2B Re-orders from Suppliers)
CREATE TABLE public.supply_orders (
    supply_order_id SERIAL PRIMARY KEY,
    item_id INT REFERENCES public.electronics_inventory(item_id) ON DELETE CASCADE,
    supplier_name VARCHAR(100) NOT NULL,
    quantity_ordered INT NOT NULL CHECK (quantity_ordered > 0),
    order_date DATE NOT NULL,
    delivery_date DATE,
    shipping_cost DECIMAL(10, 2) NOT NULL DEFAULT 0.00
);

-- 4. HEAVY INDUSTRIAL WAREHOUSE PRODUCTS
INSERT INTO public.electronics_inventory (part_number, product_name, brand, cost_price, retail_price, current_stock, safety_stock_level) VALUES
('X-PRO-15', 'Core i9 Pro Laptop 15inch', 'Dell', 800.00, 1499.00, 15, 5),
('AI-GPU-24', 'Tensor Processing Unit 24GB', 'NVIDIA', 1200.00, 2450.00, 2, 6),
('4K-MON-27', 'Ultra-Wide 4K IPS Monitor', 'LG', 150.00, 320.00, 45, 10),
('NVME-2TB', 'High-Speed Gen5 NVMe SSD', 'Samsung', 70.00, 160.00, 8, 12),
('WK-CHAIR-1', 'Ergonomic Developer Mesh Chair', 'Herman Miller', 450.00, 899.00, 12, 4),
('MAC-M3-MAX', 'MacBook Pro 16 M3 Max', 'Apple', 1800.00, 3299.00, 22, 8),
('AMD-EPYC-64', 'EPYC 64-Core Server CPU', 'AMD', 950.00, 1850.00, 4, 5),
('ROG-OLED-32', 'ROG Swift 32inch OLED Monitor', 'ASUS', 400.00, 899.00, 14, 4),
('DDR5-64GB', 'Dominator 64GB DDR5 RAM Kit', 'Corsair', 90.00, 210.00, 65, 15),
('NAS-STOR-8', '8-Bay Cloud Storage Array', 'Synology', 350.00, 720.00, 3, 6),
('RTX-4090-O', 'GeForce RTX 4090 OC 24GB', 'ASUS', 1100.00, 1999.00, 1, 4),
('THUNDER-DK', 'Thunderbolt 4 Enterprise Dock', 'CalDigit', 120.00, 280.00, 30, 8),
('KEY-MECH-MX', 'MX Mechanical Wireless Keyboard', 'Logitech', 65.00, 145.00, 80, 20),
('MOUSE-MX-M3', 'MX Master 3S Wireless Mouse', 'Logitech', 40.00, 95.00, 110, 25),
('RACK-UPS-3K', 'Smart-UPS 3000VA Rackmount', 'APC', 550.00, 1150.00, 5, 5),
('INT-XEON-32', 'Xeon Scalable 32-Core Processor', 'Intel', 750.00, 1450.00, 18, 5),
('SSD-SAT-4TB', 'Enterprise 4TB SATA SSD', 'Crucial', 110.00, 240.00, 40, 10),
('NET-SW-48P', 'Managed 48-Port PoE Switch', 'Cisco', 600.00, 1299.00, 6, 8),
('WIFI-AP-6E', 'Wi-Fi 6E Enterprise Access Point', 'Ubiquiti', 140.00, 299.00, 25, 6),
('SER-RACK-42', '42U Server Rack Enclosure', 'Tripp Lite', 450.00, 950.00, 8, 2),
('GPU-A100-80', 'A100 Tensor Core GPU 80GB', 'NVIDIA', 4500.00, 8900.00, 0, 3),
('LAP-THINK-P', 'ThinkPad P1 Gen 6 Workstation', 'Lenovo', 1400.00, 2599.00, 11, 4),
('MON-STUDIO', 'Studio Display 27inch 5K', 'Apple', 900.00, 1499.00, 7, 3),
('NVME-4TB-E', 'Enterprise Gen5 4TB NVMe', 'Kioxia', 180.00, 380.00, 50, 12),
('DESK-SIT-ST', 'Motorised Sit-Stand Corner Desk', 'Fully', 380.00, 750.00, 15, 4),
('HEAD-ANC-70', 'Enterprise ANC Wireless Headset', 'Jabra', 110.00, 249.00, 90, 15),
('CAM-CONF-4K', '4K PTZ Conference Room Camera', 'Poly', 450.00, 999.00, 4, 5),
('NAS-DISK-16', '16TB Enterprise NAS Hard Drive', 'Seagate', 190.00, 340.00, 140, 30),
('CBL-CAT6-1K', 'Cat6 Bulk Cable Spool 1000ft', 'Belkin', 55.00, 120.00, 200, 40),
('SF-TRANS-10', '10G SFP+ SR Optic Transceiver', 'StarTech', 25.00, 60.00, 350, 50);

-- 5. Populating B2B Supply Chain Shipment Logs
INSERT INTO public.supply_orders (item_id, supplier_name, quantity_ordered, order_date, delivery_date, shipping_cost) VALUES
(1, 'Dell Europe Logistics', 20, '2026-08-01', '2026-08-05', 150.00),
(2, 'NVIDIA Global Supply', 10, '2026-09-10', NULL, 300.00),
(3, 'LG UK Distribution', 50, '2026-08-15', '2026-08-22', 200.00),
(4, 'Samsung Components Ltd', 40, '2026-09-15', NULL, 50.00),
(6, 'Apple Direct UK', 15, '2026-07-10', '2026-07-14', 400.00),
(7, 'AMD Supply Logistics', 12, '2026-09-18', NULL, 180.00),
(10, 'Synology Global Dist', 8, '2026-08-20', '2026-08-29', 120.00),
(11, 'ASUS UK Freight Services', 15, '2026-09-22', NULL, 250.00),
(15, 'APC Power Distribution', 5, '2026-09-01', '2026-09-06', 350.00),
(16, 'Intel UK Distribution', 30, '2026-09-05', '2026-09-10', 190.00),
(17, 'Crucial Euro Warehouse', 100, '2026-09-25', NULL, 80.00),
(18, 'Cisco UK Systems Ltd', 10, '2026-09-12', '2026-09-21', 450.00),
(21, 'NVIDIA Global Supply', 5, '2026-10-01', NULL, 600.00),
(22, 'Lenovo UK Freight', 20, '2026-08-18', '2026-08-24', 280.00),
(26, 'Jabra Direct Logistics', 50, '2026-09-10', '2026-09-15', 100.00),
(27, 'Poly Conference Hub', 10, '2026-10-05', NULL, 150.00),
(28, 'Seagate Global Supply', 200, '2026-09-02', '2026-09-09', 500.00);
