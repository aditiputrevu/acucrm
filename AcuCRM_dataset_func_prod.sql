-- Data Set and Procedures/Functions for Better Use of the Database
-- Note: The data entered in the tables is based on the best assumptions and does not represent any active source. 
-- Please treat the inputs as a mere representation of database functionality.

-- IndustryType
INSERT INTO IndustryType (industryID, industryName)
VALUES
(1, 'Technology'),
(2, 'Healthcare'),
(3, 'Retail'),
(4, 'Finance'),
(5, 'Education'),
(6, 'Real Estate'),
(7, 'Manufacturing'),
(8, 'Logistics'),
(9, 'Energy'),
(10, 'Entertainment');

-- Support Tickets
INSERT INTO SupportTicket (ticketID, issueDesc, status, creationDt, resolveDt, priority)
VALUES
(1, 'Issue with product delivery', 'Open', '2024-10-01', NULL, 'HIGH'),
(2, 'Billing error', 'Resolved', '2024-09-15', '2024-09-20', 'MEDIUM'),
(3, 'Technical glitch on website', 'In Progress', '2024-10-10', NULL, 'URGENT'),
(4, 'Refund request', 'Closed', '2024-08-05', NULL, 'LOW'),
(5, 'Account access issue', 'Resolved', '2024-10-15', '2024-10-18', 'HIGH');


-- Customers
INSERT INTO Customer (customerID, customerType, email, phone, ticketID)
VALUES
(1, 'Individual', 'john.doe@example.com', 1234567890, 3),
(2, 'Business', 'companyA@example.com', 9876543210, 5),
(3, 'Individual', 'jane.smith@example.com', 1112223333, 2),
(4, 'Business', 'companyB@example.com', 4445556666, 1),
(5, 'Individual', 'mark.jones@example.com', 7778889999, 4);

-- Individual Customers
INSERT INTO IndividualCustomer (customerID, customerName, age, streetName, city, state, zipCode)
VALUES
(1, 'Sophia Bennett', 30, '123 Elm Street', 'New York', 'NY', 10001),
(3, 'Liam Harper', 25, '456 Maple Avenue', 'San Francisco', 'CA', 94102),
(5, 'Isabella Mitchell', 40, '789 Oak Drive', 'Chicago', 'IL', 60603);

-- Business Customers
INSERT INTO BusinessCustomer (customerID, companyName, industryID, annualRevenue, corpOfficeAddress, corpOfficeZipCode)
VALUES
(2, 'TechCorp', 1, 5000000, '101 Tech Blvd, Austin', 73301),
(4, 'RetailWorld', 3, 3000000, '202 Commerce Way, Atlanta', 30301);

-- Sales Sources
INSERT INTO SalesSource (sourceID, sourceOrigin, SourceName)
VALUES
(1, 'Website','Shark Ninja'),
(2, 'Referral','Sienna Harris'),
(3, 'Social Media', 'Aditi Putrevu'),
(4, 'Email Campaign','Tesla'),
(5, 'In-Person', 'Harish Bokka');

-- Marketing Campaigns
INSERT INTO MarketingCampaign (campaignID, campaignName, startDt, endDt, campaignType, estimatedRevenuePotential)
VALUES
(1, 'Holiday Special', '2024-11-01', '2024-12-31', 'Seasonal', 100000),
(2, 'Back to School', '2024-08-01', '2024-09-15', 'Seasonal', 50000),
(3, 'Black Friday', '2024-11-24', '2024-11-28', 'Promotion', 200000),
(4, 'Christmas', '2024-12-24', '2024-12-31', 'Seasonal', 200000);

-- Populate ContactMethod Table
INSERT INTO ContactMethod (contactMethodID, contactMethod, sourceID,contactPhnNo,contactEmail) VALUES
(1, 'Email', 1,NULL,'abc@sharkninja.com'),
(2, 'Phone', 2,'8573357249',NULL),
(3, 'Phone', 3,'8574358629',NULL),
(4, 'Email', 4,NULL,'xyz@tesla.com'),
(5, 'Phone', 5,'3357468459',NULL);

-- Populate Sales Table
INSERT INTO Sales (salesID, customerID, sourceID, dateLeadCreated, contactMethodID, revenuePotential, status, conversionRate, campaignID) VALUES
(1, 1, 1, '2024-10-05', 1, 5000, 'Won', 0.85, 1),
(2, 2, 2, '2024-10-10', 2, 3000, 'Lost', 0.45, 2),
(3, 3, 3, '2024-11-15', 3, 7000, 'Pending', 0.60, 1);

-- Populate ProductCategory Table
INSERT INTO ProductCategory (categoryID, categoryName) VALUES
(1, 'Insulated Bottles'),
(2, 'Plastic Bottles'),
(3, 'Stainless Steel Bottles'),
(4, 'Kids Bottles'),
(5, 'Accessories');

-- Populate Product Table
INSERT INTO Product (productID, productName, SKU, categoryID, basePrice, isSeasonal, isAvailable, giftingOption) VALUES
(1, 'OWALA FreeSip Insulated Bottle 24oz', 1001, 1, 29.99, FALSE, TRUE, TRUE),
(2, 'OWALA Twist Plastic Bottle 22oz', 1002, 2, 14.99, FALSE, TRUE, TRUE),
(3, 'OWALA Flip Stainless Steel Bottle 32oz', 1003, 3, 39.99, FALSE, TRUE, TRUE),
(4, 'OWALA Kids Sip Bottle 12oz', 1004, 4, 19.99, TRUE, TRUE, TRUE),
(5, 'OWALA Carry Loop Accessory', 1005, 5, 4.99, FALSE, TRUE, FALSE),
(6, 'OWALA Straw Lid Replacement', 1006, 5, 5.99, FALSE, TRUE, FALSE),
(7, 'OWALA FreeSip Insulated Bottle 40oz', 1007, 1, 34.99, FALSE, TRUE, TRUE),
(8, 'OWALA Flip Stainless Steel Bottle 18oz', 1008, 3, 24.99, TRUE, TRUE, TRUE);

-- Populate GiftSet Table
INSERT INTO GiftSet (giftSetID, giftSetName, price, productID) VALUES
(1, 'OWALA Back-to-School Bundle', 39.99, 4),  -- Kids Sip Bottle 12oz
(2, 'OWALA Ultimate Hydration Kit', 59.99, 1), -- FreeSip Insulated Bottle 24oz
(3, 'OWALA Fitness Pack', 44.99, 3),           -- Flip Stainless Steel Bottle 32oz
(4, 'OWALA Traveler’s Bundle', 69.99, 7),      -- FreeSip Insulated Bottle 40oz
(5, 'OWALA Essentials Pack', 19.99, 5),        -- Carry Loop Accessory
(6, 'OWALA Holiday Gift Set', 64.99, 8),       -- Flip Stainless Steel Bottle 18oz
(7, 'OWALA Replacement Pack', 12.99, 6);       -- Straw Lid Replacement

-- Populate SupportTeam Table
INSERT INTO SupportTeam (employeeID, firstName, lastName, email) VALUES
(1, 'Alice', 'Johnson','johnson.alice@acucrm.com'),
(2, 'Bob', 'Smith','smith.bob@acucrm.com'),
(3, 'Charlie', 'Davis','davis.charlie@acucrm.com');

-- Populate Interaction Table
INSERT INTO Interaction (interactionID, dateOfInteraction, type, representativeID, notes, status, customerFeedback, customerRating, ticketID) VALUES
(1, '2024-11-01', 'Follow-up', 1, 'Customer satisfied with service.', 'ACTIVE', 'Great experience!', 5,1),
(2, '2024-11-05', 'Resolution', 2, 'Issue resolved quickly.', 'ACTIVE', 'Good resolution time.', 4,2);

-- Populate Orders Table
INSERT INTO Orders (orderID, orderDate, shipDate, status, totalAmount, shippingAddress, shippingZipCode, paymentMethod, customerID) VALUES
(1, '2024-10-01', '2024-10-05', 'ACTIVE', 749.99, '123 Elm St, Springfield', 12345, 'Credit Card', 1),
(2, '2024-10-10', '2024-10-15', 'ACTIVE', 319.99, '456 Oak St, Springfield', 12346, 'PayPal', 2);

-- Populate Promotion Table
INSERT INTO Promotion (promoID, promoName, discountRate) VALUES
(1, 'Holiday Sale', 15.0),
(2, 'Clearance Discount', 20.0);

-- Populate ProductPromotion Table
INSERT INTO ProductPromotion (promoID, productID, startDt, endDt, discountRate) VALUES
(1, 1, '2024-11-01', '2024-12-31', 15.0),
(2, 2, '2024-11-15', '2024-12-15', 20.0);


DELIMITER //

CREATE PROCEDURE SegmentCustomers(IN minAge INT, IN maxAge INT, IN minRevenue INT, IN campaignID INT)
BEGIN
    SELECT c.customerID, c.email, c.phone, ic.age, bc.annualRevenue, sc.campaignName
    FROM Customer c
    LEFT JOIN IndividualCustomer ic ON c.customerID = ic.customerID
    LEFT JOIN BusinessCustomer bc ON c.customerID = bc.customerID
    LEFT JOIN Sales s ON c.customerID = s.customerID
    LEFT JOIN MarketingCampaign sc ON s.campaignID = sc.campaignID
    WHERE (ic.age BETWEEN minAge AND maxAge OR bc.annualRevenue >= minRevenue)
    AND s.campaignID = campaignID;
END //

DELIMITER ;

DELIMITER //
CREATE PROCEDURE CreateSupportTicket(IN customerID INT, IN issueDesc TEXT, IN priority ENUM('LOW','MEDIUM','HIGH','URGENT'), IN assignedTo INT)
BEGIN
    DECLARE ticketID INT;
    
    INSERT INTO SupportTicket (issueDesc, status, creationDt, priority)
    VALUES (issueDesc, 'Open', CURDATE(), priority);
    
    SET ticketID = LAST_INSERT_ID();
    
    INSERT INTO Interaction (dateOfInteraction, type, representativeID, notes, status, ticketID)
    VALUES (CURDATE(), 'Initial', assignedTo, 'New issue reported.', 'ACTIVE', ticketID);
    
    UPDATE Customer
    SET ticketID = ticketID
    WHERE customerID = customerID;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE UpdateTicketStatus(IN ticketID INT, IN newStatus ENUM('Open', 'In Progress', 'Resolved', 'Closed'), IN resolutionNotes TEXT)
BEGIN
    UPDATE SupportTicket
    SET status = newStatus, resolveDt = CURDATE()
    WHERE ticketID = ticketID;

    INSERT INTO Interaction (dateOfInteraction, type, representativeID, notes, status, ticketID)
    VALUES (CURDATE(), 'Resolution', NULL, resolutionNotes, 'INACTIVE', ticketID);
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION CampaignPerformance(campaignID INT) 
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE totalRevenue FLOAT;
    DECLARE totalLeads INT;
    DECLARE conversionRate FLOAT;
    
    SELECT SUM(s.revenuePotential), COUNT(s.salesID)
    INTO totalRevenue, totalLeads
    FROM Sales s
    WHERE s.campaignID = campaignID;
    
    IF totalLeads > 0 THEN
        SET conversionRate = totalRevenue / totalLeads;
    ELSE
        SET conversionRate = 0;
    END IF;
    
    RETURN conversionRate;
END //
DELIMITER ;
drop function GetCustomerProfile
DELIMITER //
CREATE FUNCTION GetCustomerProfile(customerID INT) 
RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE profile TEXT;
    
    SELECT CONCAT('Customer Info: ', c.customerID, ', ', c.email, ', ', c.phone, 
                  ' | Orders: ', GROUP_CONCAT(o.orderID), 
                  ' | Tickets: ', GROUP_CONCAT(t.ticketID), 
                  ' | Interactions: ', GROUP_CONCAT(i.interactionID))
    INTO profile
    FROM Customer c
    LEFT JOIN Orders o ON c.customerID = o.customerID
    LEFT JOIN SupportTicket t ON t.ticketID = c.ticketID
    LEFT JOIN Interaction i ON t.ticketID = i.ticketID
    WHERE c.customerID = customerID;
    
    RETURN profile;
END //
DELIMITER ;

DELIMITER //

CREATE FUNCTION GetCustomerProfile(customerID INT) 
RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE profile TEXT;

    SELECT CONCAT('Customer Info: ', c.customerID, ', ', c.email, ', ', c.phone, 
                  ' | Orders: ', COALESCE(GROUP_CONCAT(DISTINCT o.orderID), 'None'), 
                  ' | Tickets: ', COALESCE(GROUP_CONCAT(DISTINCT t.ticketID), 'None'), 
                  ' | Interactions: ', COALESCE(GROUP_CONCAT(DISTINCT i.interactionID), 'None'))
    INTO profile
    FROM Customer c
    LEFT JOIN Orders o ON c.customerID = o.customerID
    LEFT JOIN SupportTicket t ON  t.ticketID = c.ticketID
    LEFT JOIN Interaction i ON t.ticketID = i.ticketID
    WHERE c.customerID = customerID
    GROUP BY c.customerID, c.email, c.phone; -- Added GROUP BY

    RETURN profile;
END //

DELIMITER ;

select GetCustomerProfile(1)

DELIMITER //
CREATE PROCEDURE AssignCustomerToCampaign(IN customerID INT, IN campaignID INT)
BEGIN
    DECLARE customerType VARCHAR(50);
    DECLARE annualRevenue INT;

    SELECT customerType, bc.annualRevenue
    INTO customerType, annualRevenue
    FROM Customer c
    LEFT JOIN BusinessCustomer bc ON c.customerID = bc.customerID
    WHERE c.customerID = customerID;
    
    IF customerType = 'Business' AND annualRevenue > 1000000 THEN
        INSERT INTO Sales (customerID, sourceID, dateLeadCreated, campaignID)
        VALUES (customerID, 1, CURDATE(), campaignID);
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE CalculateGiftSetCost(IN giftSetID INT)
BEGIN
    DECLARE totalCost FLOAT DEFAULT 0;
    DECLARE discountedCost FLOAT DEFAULT 0;

    -- Calculate the total cost of products in the specified gift set
    SELECT SUM(p.basePrice)
    INTO totalCost
    FROM Product p
    JOIN GiftSet gs ON p.productID = gs.productID
    WHERE gs.giftSetID = giftSetID;

    -- Apply a 10% discount to the total cost
    SET discountedCost = totalCost * 0.9;

    -- Update the price of the gift set based on the discounted cost
    UPDATE GiftSet
    SET price = discountedCost
    WHERE giftSetID = giftSetID;

    -- Return the discounted cost
    SELECT discountedCost AS GiftSetTotalCost;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE CalculateCartTotal(IN orderID INT)
BEGIN
    DECLARE totalAmount FLOAT DEFAULT 0;
    DECLARE itemCost FLOAT DEFAULT 0;
    DECLARE discountAmount FLOAT DEFAULT 0;

    -- Calculate the total cost of items in the order, including quantity and any discount on items
    DECLARE done INT DEFAULT FALSE;
    DECLARE cur CURSOR FOR
        SELECT i.quantity, p.basePrice, i.discountPrice
        FROM Items i
        JOIN Product p ON i.productID = p.productID
        WHERE i.orderID = orderID;

    -- Handler for cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    -- Loop through each item in the cart (order)
    read_loop: LOOP
        FETCH cur INTO itemCost, discountAmount;
        
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- If discount exists, apply it; otherwise, use base price
        SET itemCost = IF(discountAmount IS NOT NULL, discountAmount, itemCost);
        
        -- Update total amount by adding the cost of the current item (quantity * price)
        SET totalAmount = totalAmount + (itemCost * i.quantity);
    END LOOP;

    CLOSE cur;

    -- Update the total amount for the order
    UPDATE Orders
    SET totalAmount = totalAmount
    WHERE orderID = orderID;

    -- Return the total amount calculated
    SELECT totalAmount AS OrderTotalCost;
END //
DELIMITER ;