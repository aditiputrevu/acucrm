DELIMITER $$
CREATE PROCEDURE CreateGiftSet(
    IN p_giftSetName VARCHAR(100),
    IN p_productIDs TEXT,
    IN p_discountPercentage FLOAT
)
BEGIN
    DECLARE totalPrice FLOAT DEFAULT 0;
    DECLARE discountedPrice FLOAT;
    DECLARE finished INT DEFAULT 0;
    DECLARE currentProductID INT;
    DECLARE currentPrice FLOAT;
    DECLARE newGiftSetID INT;

    DECLARE productCursor CURSOR FOR 
        SELECT productID, basePrice 
        FROM Product
        WHERE FIND_IN_SET(productID, p_productIDs) > 0 AND isAvailable = TRUE;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

    OPEN productCursor;

    read_loop: LOOP
        FETCH productCursor INTO currentProductID, currentPrice;
        IF finished THEN
            LEAVE read_loop;
        END IF;

        SET totalPrice = totalPrice + currentPrice;
    END LOOP;

    CLOSE productCursor;

    SET discountedPrice = totalPrice * (1 - p_discountPercentage / 100);

    INSERT INTO GiftSet (giftSetName, price)
    VALUES (p_giftSetName, discountedPrice);

    SET newGiftSetID = LAST_INSERT_ID();

    OPEN productCursor;

    read_loop: LOOP
        FETCH productCursor INTO currentProductID, currentPrice;
        IF finished THEN
            LEAVE read_loop;
        END IF;

        INSERT INTO GiftSet (giftSetID, productID)
        VALUES (newGiftSetID, currentProductID);
    END LOOP;

    CLOSE productCursor;
    SELECT newGiftSetID AS giftSetID, p_giftSetName AS giftSetName, discountedPrice AS finalPrice;
END$$
DELIMITER ;

DELIMITER //
CREATE PROCEDURE CampaignPerformanceDetails(IN campaignID INT)
BEGIN
    DECLARE totalRevenue FLOAT DEFAULT 0;
    DECLARE totalLeads INT DEFAULT 0;
    DECLARE totalPurchases INT DEFAULT 0;
    DECLARE conversionRate FLOAT DEFAULT 0;
    DECLARE usersPurchased TEXT DEFAULT NULL;
    DECLARE salesDetails TEXT DEFAULT NULL;

    SELECT 
        COALESCE(SUM(s.revenuePotential), 0), 
        COALESCE(COUNT(s.salesID), 0)
    INTO 
        totalRevenue, 
        totalLeads
    FROM Sales s
    WHERE s.campaignID = campaignID;

    SELECT 
        COALESCE(COUNT(s.salesID), 0)
    INTO 
        totalPurchases
    FROM Sales s
    WHERE s.campaignID = campaignID AND s.status = 'Closed';

    IF totalLeads > 0 THEN
        SET conversionRate = (totalPurchases / totalLeads) * 100;
    ELSE
        SET conversionRate = 0;
    END IF;

    SELECT 
        GROUP_CONCAT(DISTINCT c.email ORDER BY c.email SEPARATOR ', ')
    INTO 
        usersPurchased
    FROM Sales s
    JOIN Customer c ON s.customerID = c.customerID
    WHERE s.campaignID = campaignID AND s.status = 'Closed';

    SELECT 
        GROUP_CONCAT(CONCAT('SaleID: ', s.salesID, ' Revenue: $', s.revenuePotential) SEPARATOR '; ')
    INTO 
        salesDetails
    FROM Sales s
    WHERE s.campaignID = campaignID;

    SELECT 
        campaignID AS `Campaign ID`,
        totalRevenue AS `Total Revenue`,
        totalLeads AS `Total Leads`,
        totalPurchases AS `Total Purchases`,
        CONCAT(ROUND(conversionRate, 2), '%') AS `Conversion Rate`,
        IFNULL(usersPurchased, 'None') AS `Users Purchased`,
        IFNULL(salesDetails, 'No sales data available') AS `Sales Details`;
END //
DELIMITER ;


DELIMITER //
CREATE FUNCTION GetTicketDetails(ticketID INT) 
RETURNS VARCHAR(500)
DETERMINISTIC
BEGIN
    DECLARE ticketDetails VARCHAR(500);

    SELECT 
        CONCAT(
            'Ticket ID: ', ticketID, 
            ', Issue: ', COALESCE(issueDesc, 'N/A'), 
            ', Status: ', COALESCE(status, 'N/A'), 
            ', Priority: ', COALESCE(priority, 'N/A'), 
            ', Created On: ', COALESCE(creationDt, 'N/A'), 
            ', Resolved On: ', COALESCE(resolveDt, 'N/A')
        )
    INTO ticketDetails
    FROM SupportTicket
    WHERE SupportTicket.ticketID = ticketID;

    RETURN COALESCE(ticketDetails, 'No ticket found with the given ID');
END //
DELIMITER ;

