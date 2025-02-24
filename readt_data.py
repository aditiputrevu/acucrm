import pymysql
from pymysql.cursors import DictCursor

# Function to establish connection
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
        print(f"MySQL error occurred: {e}")
    return None

# Fetch Support Tickets
def fetch_support_tickets(connection):
    try:
        with connection.cursor(DictCursor) as cursor:
            cursor.execute("SELECT * FROM SupportTicket;")
            tickets = cursor.fetchall()
            if tickets:
                print("\nSupport Tickets:")
                for ticket in tickets:
                    print(f"ID: {ticket['ticketID']}, Issue: {ticket['issueDesc']}, "
                          f"Status: {ticket['status']}, Priority: {ticket['priority']}, "
                          f"Created: {ticket['creationDt']}, Resolved: {ticket['resolveDt']}")
            else:
                print("No support tickets found.")
    except pymysql.MySQLError as e:
        print(f"Error fetching support tickets: {e}")

# Fetch Products
def fetch_products(connection):
    try:
        with connection.cursor(DictCursor) as cursor:
            cursor.execute("SELECT productID, productName, SKU, basePrice, isAvailable FROM Product;")
            products = cursor.fetchall()
            if products:
                print("\nProducts:")
                for product in products:
                    availability = "Available" if product['isAvailable'] else "Unavailable"
                    print(f"ID: {product['productID']}, Name: {product['productName']}, "
                          f"SKU: {product['SKU']}, Price: ${product['basePrice']:.2f}, Availability: {availability}")
            else:
                print("No products found.")
    except pymysql.MySQLError as e:
        print(f"Error fetching products: {e}")

# Fetch Customers
def fetch_customers(connection):
    try:
        with connection.cursor(DictCursor) as cursor:
            cursor.execute("""
                SELECT C.customerID, C.customerType, C.email, C.phone, IC.customerName, IC.city, BC.companyName 
                FROM Customer C
                LEFT JOIN IndividualCustomer IC ON C.customerID = IC.customerID
                LEFT JOIN BusinessCustomer BC ON C.customerID = BC.customerID;
            """)
            customers = cursor.fetchall()
            if customers:
                print("\nCustomers:")
                for customer in customers:
                    if customer['customerType'] == 'Individual':
                        print(f"ID: {customer['customerID']}, Type: {customer['customerType']}, "
                              f"Name: {customer['customerName']}, City: {customer['city']}, "
                              f"Email: {customer['email']}, Phone: {customer['phone']}")
                    elif customer['customerType'] == 'Business':
                        print(f"ID: {customer['customerID']}, Type: {customer['customerType']}, "
                              f"Company: {customer['companyName']}, "
                              f"Email: {customer['email']}, Phone: {customer['phone']}")
            else:
                print("No customers found.")
    except pymysql.MySQLError as e:
        print(f"Error fetching customer data: {e}")

# Menu Display
def display_menu():
    print("\n--- Menu ---")
    print("1. View Support Tickets")
    print("2. View Products")
    print("3. View Customer Information")
    print("4. Exit")

# Main function
def main():
    connection = None
    while not connection:
        print("\n*** Enter 'exit' to stop and close the application ***")
        username = input("Enter MySQL username: ")
        if username.lower() == "exit":
            print("\nExiting the application. Goodbye!")
            return

        password = input("Enter MySQL password: ")
        if password.lower() == "exit":
            print("\nExiting the application. Goodbye!")
            return

        connection = connect_to_database(username, password)
        if not connection:
            print("\nFailed to connect to the database. Please try again.")

    while True:
        display_menu()
        choice = input("Enter your choice: ")

        if choice == '1':
            fetch_support_tickets(connection)
        elif choice == '2':
            fetch_products(connection)
        elif choice == '3':
            fetch_customers(connection)
        elif choice == '4':
            print("\nClosing the connection. Goodbye!")
            if connection.open:
                connection.close()
            break
        else:
            print("Invalid choice. Please select a valid option.")

if __name__ == "__main__":
    main()
