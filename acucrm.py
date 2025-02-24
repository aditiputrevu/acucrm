import pymysql
from pymysql.cursors import DictCursor
from prettytable import PrettyTable
from datetime import datetime

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

# Gift Set Related Functions
def get_available_products(connection):
    """Fetch available products from the Product table."""
    try:
        with connection.cursor(DictCursor) as cursor:
            cursor.execute("SELECT productID, productName, basePrice FROM Product WHERE isAvailable = TRUE;")
            products = cursor.fetchall()
            if products:
                table = PrettyTable(["ID", "Product Name", "Base Price"])
                for product in products:
                    table.add_row([product['productID'], product['productName'], f"${product['basePrice']:.2f}"])
                print("\nAvailable Products:")
                print(table)
            else:
                print("No available products found.")
            return products
    except pymysql.MySQLError as e:
        print(f"Error retrieving products: {e}")
        return []

def select_products(products):
    """Prompt the user to select products for the gift set."""
    selected_product_ids = []
    while True:
        try:
            print("\nAvailable Products:")
            table = PrettyTable(["No.", "Product Name", "Base Price"])
            for idx, product in enumerate(products, start=1):
                table.add_row([idx, product['productName'], f"${product['basePrice']:.2f}"])
            print(table)

            selected_indices = input("Enter the product numbers you want to include in the gift set (e.g., 1,2,3) or type 'back' to return to the menu: ")
            if selected_indices.lower() == 'back':
                return []

            selected_indices = selected_indices.split(',')
            selected_product_ids = [products[int(idx) - 1]['productID'] for idx in selected_indices if idx.strip().isdigit()]
            break
        except (ValueError, IndexError):
            print("Invalid input. Please try again.")
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
            
            # Commit the transaction
            connection.commit()
            
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
        connection.rollback()  # Roll back changes if any error occurs
        print(f"Error while creating gift set: {e}")

def delete_gift_set(connection):
    """Delete a gift set by its ID."""
    try:
        # Fetch and display all gift sets before deletion
        print("\n--- Gift Sets Available for Deletion ---")
        display_all_gift_sets(connection)

        # Prompt the user for the ID of the gift set to delete
        gift_set_id = input("Enter the Gift Set ID to delete (or type 'back' to return to the menu): ").strip()
        if gift_set_id.lower() == "back":
            return
        
        # Confirm deletion
        confirm = input(f"Are you sure you want to delete Gift Set ID {gift_set_id}? (yes/no): ").strip().lower()
        if confirm != "yes":
            print("Deletion canceled.")
            return

        # Perform the deletion
        with connection.cursor(DictCursor) as cursor:
            cursor.execute("DELETE FROM GiftSet WHERE giftSetID = %s;", (gift_set_id,))
            connection.commit()  # Commit the deletion

            if cursor.rowcount > 0:
                print(f"Gift Set ID {gift_set_id} has been successfully deleted.")
            else:
                print(f"No Gift Set found with ID {gift_set_id}.")
    except pymysql.MySQLError as e:
        connection.rollback()  # Roll back changes if any error occurs
        print(f"Error while deleting gift set: {e}")
    except ValueError:
        print("Invalid input. Please try again.")

def display_all_gift_sets(connection):
    """Fetch and display all gift sets."""
    try:
        with connection.cursor(DictCursor) as cursor:
            cursor.execute("SELECT giftSetID, giftSetName, price AS finalPrice FROM GiftSet;")
            gift_sets = cursor.fetchall()
            if gift_sets:
                table = PrettyTable(["Gift Set ID", "Gift Set Name", "Final Price"])
                for gift_set in gift_sets:
                    table.add_row([gift_set['giftSetID'], gift_set['giftSetName'], f"${gift_set['finalPrice']:.2f}"])
                print("\nAll Available Gift Sets:")
                print(table)
            else:
                print("No gift sets available.")
    except pymysql.MySQLError as e:
        print(f"Error retrieving gift sets: {e}")

# Order Related Functions
def fetch_order_details(connection, order_id):
    """Fetch and display order details by Order ID."""
    try:
        with connection.cursor(DictCursor) as cursor:
            cursor.execute("""
                SELECT o.orderID, o.shipDate, o.orderDate, c.customerName, 
                       p.productName, op.quantity, p.basePrice
                FROM Orders o
                JOIN OrderProduct op ON o.orderID = op.orderID
                JOIN Product p ON op.productID = p.productID
                JOIN Customer c ON o.customerID = c.customerID
                WHERE o.orderID = %s
            """, (order_id,))
            order_details = cursor.fetchall()
            
            if order_details:
                table = PrettyTable(["Order ID", "Order Date", "Ship Date", "Customer Name"])
                table.add_row([
                    order_details[0]['orderID'], 
                    order_details[0]['orderDate'], 
                    order_details[0]['shipDate'], 
                    order_details[0]['customerName']
                ])
                print("\nOrder Summary:")
                print(table)
                
                # Product Details Table
                product_table = PrettyTable(["Product Name", "Quantity", "Unit Price", "Total"])
                total_order_value = 0
                for detail in order_details:
                    product_total = detail['quantity'] * detail['basePrice']
                    total_order_value += product_total
                    product_table.add_row([
                        detail['productName'], 
                        detail['quantity'], 
                        f"${detail['basePrice']:.2f}", 
                        f"${product_total:.2f}"
                    ])
                print("\nOrder Products:")
                print(product_table)
                print(f"\nTotal Order Value: ${total_order_value:.2f}")
                
                return order_details[0]
            else:
                print(f"Order ID {order_id} not found.")
                return None
    except pymysql.MySQLError as e:
        print(f"Error: {e}")
        return None

def update_shipping_date(connection, order_id, new_shipping_date):
    """Update shipping date for an order."""
    try:
        with connection.cursor() as cursor:
            # Validate if the order exists
            cursor.execute("SELECT orderID FROM Orders WHERE orderID = %s", (order_id,))
            order = cursor.fetchone()
            if order:
                # Proceed to update the shipping date
                cursor.execute("""
                    UPDATE Orders
                    SET shipDate = %s
                    WHERE orderID = %s
                """, (new_shipping_date, order_id))
                connection.commit()
                print(f"Shipping date updated successfully for Order ID: {order_id}")
            else:
                print(f"Order ID {order_id} not found.")
    except pymysql.MySQLError as e:
        print(f"Error: {e}")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")

# Gift Set Submenu
def gift_set_menu(connection):
    """Submenu for Gift Set operations."""
    while True:
        print("\n--- Gift Set Menu ---")
        print("1. View Available Products")
        print("2. Create a New Gift Set")
        print("3. View All Gift Sets")
        print("4. Delete a Gift Set")
        print("5. Return to Main Menu")

        choice = input("Enter your choice: ")
        if choice == "1":
            get_available_products(connection)
        elif choice == "2":
            products = get_available_products(connection)
            if products:
                selected_product_ids = select_products(products)
                if selected_product_ids:
                    gift_set_name, discount_percentage = get_gift_set_details()
                    create_gift_set(connection, gift_set_name, selected_product_ids, discount_percentage)
        elif choice == "3":
            display_all_gift_sets(connection)
        elif choice == "4":
            delete_gift_set(connection)
        elif choice == "5":
            break
        else:
            print("Invalid choice. Please try again.")

# Order Details Submenu
def order_details_menu(connection):
    """Submenu for Order Details operations."""
    while True:
        print("\n--- Order Details Menu ---")
        print("1. View Order Details")
        print("2. Update Shipping Date")
        print("3. Return to Main Menu")

        choice = input("Enter your choice: ")
        if choice == "1":
            try:
                order_id = int(input("Enter the Order ID to view details: "))
                fetch_order_details(connection, order_id)
            except ValueError:
                print("Invalid Order ID. Please enter a valid number.")
        elif choice == "2":
            try:
                order_id = int(input("Enter the Order ID to update shipping date: "))
                
                # Fetch and show existing order details
                order = fetch_order_details(connection, order_id)
                
                if order:
                    shipping_date_input = input("Enter the new shipping date (YYYY-MM-DD): ")
                    try:
                        new_shipping_date = datetime.strptime(shipping_date_input, "%Y-%m-%d").date()
                        update_shipping_date(connection, order_id, new_shipping_date)
                        
                        # Fetch and show updated order details
                        fetch_order_details(connection, order_id)
                    except ValueError:
                        print("Invalid date format. Please use 'YYYY-MM-DD'.")
            except ValueError:
                print("Invalid Order ID. Please enter a valid number.")
        elif choice == "3":
            break
        else:
            print("Invalid choice. Please try again.")

# Main Menu
def main_menu(connection):
    print(r"""

__        __   _                                  
\ \      / /__| | ___ ___  _ __ ___   ___ 
 \ \ /\ / / _ \ |/ __/ _ \| '_ ` _ \ / _ \ 
  \ V  V /  __/ | (_| (_) | | | | | |  __/ 
   \_/\_/ \___|_|\___\___/|_| |_| |_|\___|   


                 _        
                | |_ ___  
                | __/ _ \ 
                | || (_) |
                 \__\___/ 
          
    _               ____ ____  __  __ 
   / \   ___ _   _ / ___|  _ \|  \/  |
  / _ \ / __| | | | |   | |_) | |\/| |
 / ___ \ (__| |_| | |___|  _ <| |  | |
/_/   \_\___|\__,_|\____|_| \_\_|  |_|

    🌐 Customer Relationship Management! 🌐

""")
    while True:
        print("\n--- Main Menu ---")
        print("1. View & Update GiftSet")
        print("2. View & Edit Order Details")
        print("3. Exit")

        choice = input("Enter your choice: ")
        if choice == "1":
            gift_set_menu(connection)
        elif choice == "2":
            order_details_menu(connection)
        elif choice == "3":
            print("Exiting... Thank you!")
            break
        else:
            print("Invalid choice. Please try again.")

# Main Program
if __name__ == "__main__":
    connection = None
    while not connection:
        print("\n*** Enter 'exit' if you wish to stop and close the application ***")
        username = input("\nEnter MySQL username: ")
        if username.lower() == "exit":
            print("\nConnection closed. Thank you!")
            break

        password = input("Enter MySQL password: ")
        if password.lower() == "exit":
            print("\nConnection closed. Thank you!")
            break

        connection = connect_to_database(username, password)
        if not connection:
            print("\nFailed to connect to the database. Please check your USERNAME and PASSWORD and try again.")
    
    if connection:
        try:
            main_menu(connection)
        finally:
            if connection and connection.open:
                connection.close()
                print("\nConnection closed. Thank you!")