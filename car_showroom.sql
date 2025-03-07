-- Create the database
CREATE DATABASE IF NOT EXISTS car_showroom;
USE car_showroom;
-- Create the employee table
CREATE TABLE IF NOT EXISTS employee (
    userName VARCHAR(50) NOT NULL PRIMARY KEY,
    userPass VARCHAR(50) NOT NULL,
    userType ENUM('admin', 'employee') NOT NULL,
    fullName VARCHAR(100) NOT NULL,
    contact VARCHAR(15) NOT NULL CHECK (contact LIKE '+91%'),
    email VARCHAR(100) NOT NULL,
    status ENUM('Activated') NOT NULL
);
-- Create the car_details table
CREATE TABLE IF NOT EXISTS car_details (
    car_id INT PRIMARY KEY,
    model_name VARCHAR(255) NOT NULL,
    variant VARCHAR(255) NOT NULL,
    engine_spec VARCHAR(255) NOT NULL,
    engine_type VARCHAR(300) NOT NULL,
    power VARCHAR(255) NOT NULL,
    torque VARCHAR(255) NOT NULL,
    transmission VARCHAR(255) NOT NULL,
    fuel_efficiency VARCHAR(255) NOT NULL,
    price VARCHAR(255) NOT NULL,
    colour VARCHAR(500) NOT NULL,
    image VARCHAR(400),
    UNIQUE (model_name, variant) -- composite unique key
);

-- Create the inventory table
CREATE TABLE IF NOT EXISTS inventory (
    inventory_id INT  PRIMARY KEY,
    model_name VARCHAR(255) NOT NULL,
    variant VARCHAR(255) NOT NULL,
    stock_quantity INT,
    received_date DATE,
    sold_quantity INT,
    FOREIGN KEY (model_name, variant) REFERENCES car_details(model_name, variant) ON DELETE CASCADE
);

-- Create the monthly_sales table
CREATE TABLE IF NOT EXISTS monthly_sales (
    serial_no INT PRIMARY KEY,
    model_name VARCHAR(255) NOT NULL,
    sales_year INT,
    total_sales INT,
    FOREIGN KEY (model_name) REFERENCES car_details(model_name) ON DELETE CASCADE
);

-- Create the sales table
CREATE TABLE IF NOT EXISTS sales (
    sale_id INT PRIMARY KEY,
    customer_Id INT,
    customerName VARCHAR(100) NOT NULL,
    customerPhone VARCHAR(15) NOT NULL CHECK (customerPhone LIKE '+91%'),
    customerAddress TEXT NOT NULL,
    car_name VARCHAR(255) NOT NULL,
    car_model VARCHAR(255) NOT NULL,
    colour VARCHAR(500),
    sale_date DATE,
    amount DECIMAL(10, 2),
    payment_status ENUM('Paid', 'Pending'),
    payment_method ENUM('Credit Card', 'Cash', 'Online')
);
    
-- Insert sample data into the employee table
INSERT INTO employee (userName, userPass, userType, fullName, contact, email, status) VALUES
('admin1', 'password123', 'admin', 'John Doe', '+911234567890', 'john.doe@example.com', 'Activated'),
('employee1', 'password456', 'employee', 'Jane Smith', '+919876543210', 'jane.smith@example.com', 'Activated');


INSERT INTO car_details (car_id, model_name, variant, engine_spec, engine_type, power, torque, transmission, fuel_efficiency, price, colour, image) VALUES
(1, 'Tata Curvv', 'EV Base', '50 kWh battery', 'Electric', '197 bhp', '250 Nm', 'Automatic', '450 km/charge', '₹20,00,000', 'Signature Teal Blue, Flame Red', 'static/images1/curvv.jpg'),
(2, 'Tata Curvv', 'EV Long Range', '60 kWh battery', 'Electric', '230 bhp', '300 Nm', 'Automatic', '500 km/charge', '₹23,00,000', 'Arctic White, Pristine White, Daytona Grey', 'static/images1/curvv.jpg'),
(3, 'Tata Curvv', 'Petrol Turbo Base', '1.2L Turbocharged', 'Petrol', '120 bhp', '170 Nm', 'Manual', '18 km/l', '₹12,50,000', 'Fiery Red, Opera Blue', 'static/images1/curvv.jpg'),
(4, 'Tata Curvv', 'Petrol Turbo Top', '1.2L Turbocharged', 'Petrol', '120 bhp', '170 Nm', 'Automatic', '18 km/l', '₹14,00,000', 'Sunset Orange, Pure Grey', 'static/images1/curvv.jpg'),
(5, 'Tata Curvv', 'Diesel Turbo', '2.0L Turbocharged', 'Diesel', '150 bhp', '350 Nm', 'Automatic', '20 km/l', '₹16,50,000', 'Midnight Black, Gold Essence, Daytona Grey with Black Roof', 'static/images1/curvv.jpg'),
(6, 'Tata Punch', 'Pure MT', '1199 cc', 'Petrol', '87 bhp', '115 Nm @ 3250 rpm', 'Manual', '18.97 kmpl', '₹6.13 Lakh', 'Tornado Blue with White Roof, Orcus White', 'static/images/punch/pure-mt.png'),
(7, 'Tata Punch', 'Adventure MT', '1199 cc', 'Petrol', '87 bhp', '115 Nm @ 3250 rpm', 'Manual', '18.97 kmpl', '₹6.99 Lakh', 'Calypso Red with White Roof, Daytona Grey', 'static/images/punch/adventure-mt.png'),
(8, 'Tata Punch', 'Accomplished MT', '1199 cc', 'Petrol', '87 bhp', '115 Nm @ 3250 rpm', 'Manual', '18.97 kmpl', '₹7.85 Lakh', 'Tropical Mist, Calypso Red', 'static/images/punch/accomplished-mt.png'),
(9, 'Tata Punch', 'Creative MT', '1199 cc', 'Petrol', '87 bhp', '115 Nm @ 3250 rpm', 'Manual', '18.97 kmpl', '₹8.63 Lakh', 'Atomic Orange, Daytona Grey', 'static/images/punch/creative-mt.png'),
(10, 'Tata Punch', 'Creative AMT', '1199 cc', 'Petrol', '87 bhp', '115 Nm @ 3250 rpm', 'Automatic', '18.82 kmpl', '₹9.29 Lakh', 'Meteor Bronze, Daytona Grey with Black Roof', 'images/punch/creative-amt.png'),
(11, 'Tata Nexon', 'Smart (O)',' 1.2 Petrol 5MT', 'Petrol', '118 bhp', '170 Nm', 'Manual', '17.4 kmpl', '₹8.00 Lakh', 'Flame Red, Flame Red with White Roof, Calgary White', 'static/images1/nexon.jpg'),
(12, 'Tata Nexon', 'Pure', '1.2 Petrol 5MT', 'Petrol', '118 bhp', '170 Nm', 'Manual', '17.4 kmpl', '₹8.60 Lakh', 'Daytona Grey, Daytona Grey with White Roof, Pristine White', 'static/images1/nexon.jpg'),
(13, 'Tata Nexon', 'Creative', '1.2 Petrol 5MT', 'Petrol', '118 bhp', '170 Nm', 'Manual', '17.4 kmpl', '₹9.80 Lakh', 'Foliage Green, Creative Ocean with White Roof', 'static/images1/nexon.jpg'),
(14, 'Tata Nexon', 'Creative+', '1.2 Petrol 5MT', 'Petrol', '118 bhp', '170 Nm', 'Manual', '17.4 kmpl', '₹10.60 Lakh', 'Atlas Black, Creative Ocean, Fearless Purple', 'static/images1/nexon.jpg'),
(15, 'Tata Nexon', 'Fearless', '1.2 Petrol 5MT', 'Petrol', '118 bhp', '170 Nm', 'Manual', '17.4 kmpl', '₹11.70 Lakh', 'Intensi-Teal, Fearless Purple, Pure Grey', 'images1/nexon.jpg'),
(16, 'Tata Safari', 'Smart 2.0 Diesel 6MT', '1956 cc', 'Diesel', '168 bhp', '350 Nm @ 1750 rpm', 'Manual', '16.14 kmpl', '₹15.00 Lakh', 'Royal Blue, Cosmic Gold, Oberon Black', 'static/images/safari/smart-diesel-6mt.png'),
(17, 'Tata Safari', 'Pure 2.0 Diesel 6MT', '1956 cc', 'Diesel', '168 bhp', '350 Nm @ 1750 rpm', 'Manual', '16.14 kmpl', '₹16.00 Lakh', 'Orcus White, Galactic Sapphire, Stardust Ash', 'static/images/safari/pure-diesel-6mt.png'),
(18, 'Tata Safari', 'Adventure 2.0 Diesel 6MT', '1956 cc', 'Diesel', '168 bhp', '350 Nm @ 1750 rpm', 'Manual', '16.14 kmpl', '₹17.50 Lakh', 'Tropical Mist, Stellar Frost, Supernova Copper', 'static/images/safari/adventure-diesel-6mt.png'),
(19, 'Tata Safari', 'Accomplished 2.0 Diesel 6MT', '1956 cc', 'Diesel', '168 bhp', '350 Nm @ 1750 rpm', 'Manual', '16.14 kmpl', '₹19.00 Lakh', 'Daytona Grey, Lunar Slate, Cosmic Gold', 'static/images/safari/accomplished-diesel-6mt.png'),
(20, 'Tata Safari', 'Accomplished+ 2.0 Diesel 6AT', '1956 cc', 'Diesel', '168 bhp', '350 Nm @ 1750 rpm', 'Automatic', '14.08 kmpl', '₹20.50 Lakh', 'Oberon Black, Galactic Sapphire, Stellar Frost', 'static/images/safari/accomplished-plus-diesel-6at.png'),
(21, 'Tata Altroz', 'XE', '1.2L Revotron', 'Petrol', '86 bhp', '113 Nm', 'Manual', '19 km/l', '₹6,59,000', 'Arcade Grey, Downtown Red', 'static/images/altroz_xe.jpg'),
(22, 'Tata Altroz', 'XM+', '1.2L Revotron', 'Petrol', '86 bhp', '113 Nm', 'Manual', '19 km/l', '₹7,29,000', 'Opera Blue, Avenue White', 'static/images/altroz_xm_plus.jpg'),
(23, 'Tata Altroz', 'XT Turbo', '1.2L iTurbo', 'Petrol', '110 bhp', '140 Nm', 'Manual', '18 km/l', '₹8,99,000', 'Harbour Blue, Cosmo Dark', 'static/images/altroz_xt_turbo.jpg'),
(24, 'Tata Altroz', 'XZ+', '1.5L Revotorq', 'Diesel', '90 bhp', '200 Nm', 'Manual', '23 km/l', '₹10,29,000', 'High Street Gold, Atomic Orange with Black Roof', 'static/images/altroz_xz_plus.jpg'),
(25, 'Tata Altroz', 'DCA', '1.2L Revotron', 'Petrol', '86 bhp', '113 Nm', 'Automatic', '18.5 km/l', '₹9,10,000', 'Downtown Red, Avenue White With Black Roof', 'static/images/altroz_dca.jpg');
 

 INSERT INTO sales (sale_id, customer_Id, customerName, customerPhone, customerAddress, car_name, car_model, colour, sale_date, amount, payment_status, payment_method)
VALUES
(1, 101, 'Rahul Sharma', '+91-9876543210', '45, Green Avenue, Delhi', 'Tata Curvv', 'EV Base', 'Signature Teal Blue', '2024-12-20', 2000000.00, 'Paid', 'Online'),
(2, 102, 'Priya Verma', '+91-9123456789', '12, Whitefield, Bangalore', 'Tata Punch', 'Creative AMT', 'Meteor Bronze', '2024-12-22', 929000.00, 'Pending', 'Cash'),
(3, 103, 'Amit Gupta', '+91-9876543211', '34, Rose Lane, Mumbai', 'Tata Nexon', 'Fearless', 'Intensi-Teal', '2024-12-18', 1170000.00, 'Paid', 'Credit Card'),
(4, 104, 'Sneha Roy', '+91-8765432190', '78, Sunset Boulevard, Kolkata', 'Tata Safari', 'Accomplished+', 'Oberon Black', '2024-12-15', 2050000.00, 'Paid', 'Online'),
(5, 105, 'Rohan Singh', '+91-9988776655', '23, Green Park, Chandigarh', 'Tata Altroz', 'XT Turbo', 'Harbour Blue', '2024-12-19', 899000.00, 'Pending', 'Cash');
 select * from car_details;
 select * from monthly_sales;
SELECT model_name, variant
FROM car_details
WHERE model_name = 'Tata Curvv' AND variant = 'EV Base';

ALTER TABLE sales DROP FOREIGN KEY sales_ibfk_1;