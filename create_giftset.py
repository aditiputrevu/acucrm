import pymysql
from pymysql.cursors import DictCursor

# Connect to the database
def connect_to_database(username, password):
    """Establish a connection to the MySQL database."""
    try:
        connection = pymysql.connect(
            host='localhost',
            user=username,
            password=password,
            database='AcuCRM'
        )
        if connection.open:
            print("\nConnection to MySQL database established successfully.")
        return connection
    except pymysql.OperationalError as e:
        print(f"Operational error: {e}")
    except pymysql.InternalError as e:
        print(f"Internal database error: {e}")
    except pymysql.MySQLError as e:
        print(f"MySQL error occurred: {e}")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
    return None

def get_available_products(connection):
    """Fetch available products from the Product table."""
    try:
        with connection.cursor(DictCursor) as cursor:
            cursor.execute("SELECT productID, productName, basePrice FROM Product WHERE isAvailable = TRUE;")
            products = cursor.fetchall()
            if products:
                print("\nAvailable Products:")
                for product in products:
                    print(f"ID: {product['productID']}, Name: {product['productName']}, Price: ${product['basePrice']:.2f}")
            else:
                print("No available products found.")
            return products
    except pymysql.MySQLError as e:
        print(f"Error retrieving products: {e}")
        return []

def select_products(products):
    """Prompt the user to select products for the gift set."""
    print("\nAvailable Products:")
    for idx, product in enumerate(products, start=1):
        print(f"{idx}. {product['productName']} (ID: {product['productID']}, Price: ${product['basePrice']:.2f})")

    selected_indices = input("Enter the product numbers you want to include in the gift set, separated by commas (e.g., 1,2,3): ")
    selected_indices = selected_indices.split(',')
    selected_product_ids = [products[int(idx) - 1]['productID'] for idx in selected_indices if idx.strip().isdigit()]
    return selected_product_ids

def get_gift_set_details():
    """Get the gift set name and discount percentage from the user."""
    gift_set_name = input("Enter the name of the gift set: ")
    while True:
        try:
            discount_percentage = float(input("Enter the discount percentage (0-100): "))
            if 0 <= discount_percentage <= 100:
                break
            else:
                print("Please enter a valid percentage between 0 and 100.")
        except ValueError:
            print("Invalid input. Please enter a numerical value.")
    return gift_set_name, discount_percentage

def create_gift_set(connection, gift_set_name, product_ids, discount_percentage):
    """Call the stored procedure to create a new gift set."""
    try:
        with connection.cursor(DictCursor) as cursor:
            product_ids_str = ','.join(map(str, product_ids))
            
            # Call the stored procedure
            cursor.callproc('CreateGiftSet', [gift_set_name, product_ids_str, discount_percentage])
            
            # Fetch the last inserted gift set ID
            cursor.execute("SELECT LAST_INSERT_ID() AS giftSetID;")
            result = cursor.fetchone()

            if result:
                print("\nGift Set Created Successfully!")
                print(f"Gift Set ID: {result['giftSetID']}")
                print(f"Gift Set Name: {gift_set_name}")
                print(f"Discount Percentage: {discount_percentage}")
                
                # Display all gift sets after creation
                display_all_gift_sets(connection)
            else:
                print("Gift set creation failed.")
    except pymysql.MySQLError as e:
        print(f"Error while creating gift set: {e}")

def display_all_gift_sets(connection):
    """Fetch and display all gift sets."""
    try:
        with connection.cursor(DictCursor) as cursor:
            cursor.execute("SELECT giftSetID, giftSetName, price AS finalPrice FROM GiftSet;")
            gift_sets = cursor.fetchall()
            if gift_sets:
                print("\nAll Available Gift Sets:")
                for gift_set in gift_sets:
                    print(f"ID: {gift_set['giftSetID']}, Name: {gift_set['giftSetName']}, Price: {gift_set['finalPrice']}%")
            else:
                print("No gift sets available.")
    except pymysql.MySQLError as e:
        print(f"Error retrieving gift sets: {e}")

def main():
    """Main function to run the script."""
    connection = None
    while not connection:
        print("\n*** Enter 'exit' if you wish to stop and close the application ***")
        username = input("\nEnter MySQL username: ")
        if username.lower() == "exit":
            print("\nConnection closed. Thank you!")
            return

        password = input("Enter MySQL password: ")
        if password.lower() == "exit":
            print("\nConnection closed. Thank you!")
            return

        connection = connect_to_database(username, password)
        if not connection:
            print("\nFailed to connect to the database. Please check your USERNAME and PASSWORD and try again.")

    try:
        # Fetch available products
        products = get_available_products(connection)
        if not products:
            print("No products available for the gift set.")
            return

        # Select products for the gift set
        selected_product_ids = select_products(products)
        if not selected_product_ids:
            print("No valid products selected. Exiting.")
            return

        # Get gift set details
        gift_set_name, discount_percentage = get_gift_set_details()

        # Create the gift set using the stored procedure
        create_gift_set(connection, gift_set_name, selected_product_ids, discount_percentage)

    except pymysql.MySQLError as e:
        print(f"Database error: {e}")
    finally:
        if connection and connection.open:
            connection.close()
            print("\nConnection closed. Thank you!")

if __name__ == "__main__":
    main()
