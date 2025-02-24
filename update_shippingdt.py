import pymysql
from pymysql.cursors import DictCursor
from datetime import datetime

# Connect to the database
def connect_to_database(username, password):
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
    except pymysql.MySQLError as e:
        print(f"Error: {e}")
        return None
# Function to fetch order details by Order ID
def fetch_order_details(connection, order_id):
    try:
        with connection.cursor(DictCursor) as cursor:
            cursor.execute("SELECT orderID, shipDate FROM Orders WHERE orderID = %s", (order_id,))
            order = cursor.fetchone()
            if order:
                return order
            else:
                print(f"Order ID {order_id} not found.")
                return None
    except pymysql.MySQLError as e:
        print(f"Error: {e}")
        return None

# Function to update shipping date for an order
def update_shipping_date(connection, order_id, new_shipping_date):
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

# Main program flow
def main():
    # Option for user to exit the application
    connection = None
    while not connection:
        print("\n*** Enter 'exit' to stop and close the application ***")
        username = input("Enter MySQL username: ")
        if username.lower() == "exit":
            print("\nConnection closed. Thank you!")
            return

        password = input("Enter MySQL password: ")
        if password.lower() == "exit":
            print("\nConnection closed. Thank you!")
            return

        # Connect to the database
        connection = connect_to_database(username, password)
        if not connection:
            print("\nFailed to connect to the database. Please try again.")

    # Get order ID and new shipping date from user input
    try:
        order_id = int(input("Enter the Order ID to update the shipping date: "))
        shipping_date_input = input("Enter the new shipping date (YYYY-MM-DD): ")
        new_shipping_date = datetime.strptime(shipping_date_input, "%Y-%m-%d").date()

        # Fetch and show data before updating shipping date
        order = fetch_order_details(connection, order_id)
        if order:
            print(f"\nBefore update - Order ID: {order['orderID']}, Shipping Date: {order['shipDate']}")

            # Update shipping date
            update_shipping_date(connection, order_id, new_shipping_date)

            # Fetch and show data after updating shipping date
            updated_order = fetch_order_details(connection, order_id)
            if updated_order:
                print(f"\nAfter update - Order ID: {updated_order['orderID']}, Shipping Date: {updated_order['shipDate']}")

    except ValueError as e:
        print(f"Invalid date format. Please use 'YYYY-MM-DD'. Error: {e}")
    finally:
        if connection.open:
            connection.close()
            print("\nConnection closed. Thank you!")

if __name__ == "__main__":
    main()