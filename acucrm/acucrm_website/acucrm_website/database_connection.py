import pymysql
import getpass
import os
import sys
from django.conf import settings

# Function to test the database connection
def test_database_connection(username, password, database, host, port):
    try:
        # Attempt to establish a connection using pymysql
        conn = pymysql.connect(
            host=host,
            user=username,
            password=password,
            database=database,
            port=int(port)
        )
        conn.close()  # Close the connection if successful
        return True
    except pymysql.MySQLError as e:
        print(f"Error: {e}")
        return False

# Prompt the user for credentials
def get_database_credentials():
    # Retry until successful connection or exit
    while True:
        DB_USERNAME = input("Enter MySQL username: ")
        DB_PASSWORD = getpass.getpass("Enter MySQL password: ")  # Hidden input for password
        DB_NAME = input("Enter the database name (default 'AcuCRM'): ") or 'AcuCRM'
        DB_HOST = input("Enter MySQL host (default 'localhost'): ") or 'localhost'
        DB_PORT = input("Enter MySQL port (default '3306'): ") or '3306'

        # Test the connection
        if test_database_connection(DB_USERNAME, DB_PASSWORD, DB_NAME, DB_HOST, DB_PORT):
            print("\nConnection successful!")
            return DB_USERNAME, DB_PASSWORD, DB_NAME, DB_HOST, DB_PORT
        else:
            print("\nConnection failed. Please check your credentials and try again.")
            retry = input("\nDo you want to retry? (y/n): ").lower()
            if retry != 'y':
                print("\nExiting... Please check your MySQL configuration.")
                sys.exit()  # Exit if the user doesn't want to retry

# Get the database credentials from the user
DB_USERNAME, DB_PASSWORD, DB_NAME, DB_HOST, DB_PORT = get_database_credentials()

# Now configure the DATABASES setting with the provided credentials
os.environ['DB_USERNAME'] = DB_USERNAME
os.environ['DB_PASSWORD'] = DB_PASSWORD
os.environ['DB_NAME'] = DB_NAME
os.environ['DB_HOST'] = DB_HOST
os.environ['DB_PORT'] = DB_PORT

print("\nConfiguration complete. Proceeding with Django setup...")