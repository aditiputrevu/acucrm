CREATE DATABASE IF NOT EXISTS AcuCRM;
USE AcuCRM;
-- DROP DATABASE AcuCRM;

-- Industry Type Table
CREATE TABLE IndustryType (
    industryID INT PRIMARY KEY,
    industryName VARCHAR(50) NOT NULL
);

-- Support Ticket Table
CREATE TABLE SupportTicket (
    ticketID INT PRIMARY KEY AUTO_INCREMENT,
    issueDesc TEXT NOT NULL,
    status ENUM('Open', 'In Progress', 'Resolved', 'Closed') NOT NULL,
    creationDt DATE NOT NULL,
    resolveDt DATE,
    priority ENUM('LOW','MEDIUM','HIGH','URGENT')
);
-- Customer Table
CREATE TABLE Customer (
    customerID INT PRIMARY KEY,
    customerType ENUM('Individual', 'Business') NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone CHAR(10) NOT NULL UNIQUE,
    ticketID INT,
    FOREIGN KEY (ticketID) REFERENCES SupportTicket(ticketID) ON DELETE CASCADE ON UPDATE CASCADE
);
-- Individual Customer Table
CREATE TABLE IndividualCustomer (
    customerID INT PRIMARY KEY,
    customerName VARCHAR(20) NOT NULL,
    age INT,
    streetName VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    zipCode INT NOT NULL,
    FOREIGN KEY (customerID) REFERENCES Customer(customerID) ON DELETE CASCADE ON UPDATE CASCADE
);
-- Business Customer Table
CREATE TABLE BusinessCustomer (
    customerID INT PRIMARY KEY,
    companyName VARCHAR(100) NOT NULL,
    industryID INT,
    annualRevenue INT,
    corpOfficeAddress VARCHAR(200) NOT NULL,
    corpOfficeZipCode INT NOT NULL,
    FOREIGN KEY (customerID) REFERENCES Customer(customerID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (industryID) REFERENCES IndustryType(industryID) ON DELETE CASCADE ON UPDATE CASCADE
);
-- Sales Source Table
CREATE TABLE SalesSource (
    sourceID INT PRIMARY KEY AUTO_INCREMENT,
    sourceOrigin VARCHAR(50) NOT NULL,
    sourceName VARCHAR(100) NOT NULL
);

-- Contact Method Table
CREATE TABLE ContactMethod (
    contactMethodID INT PRIMARY KEY AUTO_INCREMENT,
    contactMethod VARCHAR(50) NOT NULL,
    sourceID INT,
    contactPhnNo CHAR(10),
    contactEmail vARCHAR(50),
    FOREIGN KEY (sourceID) REFERENCES SalesSource(sourceID) ON DELETE CASCADE ON UPDATE CASCADE
);
-- Marketing Campaign Table
CREATE TABLE MarketingCampaign (
    campaignID INT PRIMARY KEY AUTO_INCREMENT,
    campaignName VARCHAR(100) NOT NULL,
    startDt DATE NOT NULL,
    endDt DATE NOT NULL,
    campaignType VARCHAR(50) NOT NULL,
    estimatedRevenuePotential INT
);
-- Sales Table
CREATE TABLE Sales (
    salesID INT PRIMARY KEY AUTO_INCREMENT,
    customerID INT NOT NULL,
    sourceID INT NOT NULL,
    dateLeadCreated DATE NOT NULL,
    contactMethodID INT,
    revenuePotential INT,
    status VARCHAR(20),
    conversionRate FLOAT,
    campaignID INT,
    FOREIGN KEY (customerID) REFERENCES Customer(customerID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (sourceID) REFERENCES SalesSource(sourceID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (contactMethodID) REFERENCES ContactMethod(contactMethodID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (campaignID) REFERENCES MarketingCampaign(campaignID) ON DELETE CASCADE ON UPDATE CASCADE
);
-- Product Category Table
CREATE TABLE ProductCategory (
    categoryID INT PRIMARY KEY AUTO_INCREMENT,
    categoryName VARCHAR(50) NOT NULL
);
-- Product Table
CREATE TABLE Product (
    productID INT PRIMARY KEY,
    productName VARCHAR(100) NOT NULL UNIQUE,
    SKU INT NOT NULL,
    categoryID INT NOT NULL,
    basePrice FLOAT NOT NULL,
    isSeasonal BOOLEAN NOT NULL,
    isAvailable BOOLEAN NOT NULL,
    giftingOption BOOLEAN NOT NULL,
    FOREIGN KEY (categoryID) REFERENCES ProductCategory(categoryID) ON DELETE CASCADE ON UPDATE CASCADE
);
-- Gift Set Table (Specialized Combination of Products)
CREATE TABLE GiftSet (
    giftSetID INT PRIMARY KEY AUTO_INCREMENT,
    giftSetName VARCHAR(100) NOT NULL,
    price FLOAT NOT NULL,
    productID INT,
    FOREIGN KEY (productID) REFERENCES Product(productID) ON DELETE CASCADE ON UPDATE CASCADE
);
-- Support Team Table
CREATE TABLE SupportTeam (
    employeeID INT PRIMARY KEY,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL
);

-- Interaction Table
CREATE TABLE Interaction (
    interactionID INT PRIMARY KEY AUTO_INCREMENT,
    dateOfInteraction DATE NOT NULL,
    type VARCHAR(50),
    representativeID INT,
    notes TEXT NOT NULL,
    status ENUM('ACTIVE','INACTIVE','PENDING','ARCHIEVED'),
    customerFeedback TEXT,
    customerRating INT,
    ticketID INT,
    FOREIGN KEY (representativeID) REFERENCES SupportTeam(employeeID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ticketID) REFERENCES SupportTicket(ticketID) ON DELETE CASCADE ON UPDATE CASCADE
);
-- Orders Table
CREATE TABLE Orders (
    orderID INT PRIMARY KEY,
    orderDate DATE NOT NULL,
    shipDate DATE,
    status ENUM('ACTIVE', 'INACTIVE', 'PENDING', 'ARCHIVED') NOT NULL,
    totalAmount FLOAT NOT NULL,
    shippingAddress VARCHAR(200) NOT NULL,
    shippingZipCode INT,
    paymentMethod VARCHAR(50),
    customerID INT,
    FOREIGN KEY (customerID) REFERENCES Customer(customerID) ON DELETE CASCADE ON UPDATE CASCADE
);
-- Items Table (Products in Orders)
CREATE TABLE Items (
    itemID INT PRIMARY KEY AUTO_INCREMENT,
    orderID INT NOT NULL,
    productID INT NOT NULL,
    quantity INT NOT NULL,
    cartValue FLOAT,
    FOREIGN KEY (orderID) REFERENCES Orders(orderID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (productID) REFERENCES Product(productID) ON DELETE CASCADE ON UPDATE CASCADE
);
-- Promotion Table
CREATE TABLE Promotion (
    promoID INT PRIMARY KEY,
    promoName VARCHAR(50) NOT NULL,
    discountRate FLOAT NOT NULL
);

-- Product Promotion Mapping Table
CREATE TABLE ProductPromotion (
    promoID INT,
    productID INT,
    startDt DATE NOT NULL,
    endDt DATE NOT NULL,
    discountRate FLOAT,
    PRIMARY KEY (promoID, productID),
    FOREIGN KEY (promoID) REFERENCES Promotion(promoID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (productID) REFERENCES Product(productID) ON DELETE CASCADE ON UPDATE CASCADE
);



