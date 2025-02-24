# ***AcuCRM Data Management Application***

This Python application connects to a MySQL server on your local system and provides functionalities to manage and retrieve customer relationship management (CRM) data. The application interacts with the **AcuCRM** database, enabling users to fetch, analyze, and manipulate data related to customers, support tickets, sales, products, and more.

## Programming Language Used
- Python

## Database Used
- MySQL

## Features
- **Database Connection**: Prompts for MySQL username and password to securely establish a connection to the database. Users can enter `exit` to safely terminate the application if they choose not to proceed.
- **Customer Management**: Displays customer details and related information like tickets, orders, or interactions.
- **Support Ticket Management**: View, create, or update support ticket information for customers.
- **Sales Tracking**: Retrieve and display sales data, including associated campaigns, revenue, and conversion rates.
- **Product and Promotion Management**: Fetch data about products, gift sets, and associated promotions.
- **Order Management**: Manage and analyze customer orders and the items purchased.
- **Error Handling**: Handles common database and user errors gracefully.

## Prerequisites

### Database Setup
- Ensure that the **AcuCRM** database is created with all the tables and relationships defined.
- Import the provided **AcuCRM.sql** file to set up the database schema and seed initial data if required.

### MySQL User Privileges
- Ensure the MySQL user has sufficient privileges to access, modify, and query the **AcuCRM** database.

### Database Credentials
The application uses the following parameters to connect to the database:
- **Host**: Set to `localhost`. Change this if using a remote database server.
- **User**: The MySQL username. Enter your actual username when prompted.
- **Password**: The MySQL password. Enter your actual password when prompted.
- **Database**: Set to `AcuCRM`.

## Installation Steps
1. Clone the repository to your local machine.
2. Install required Python packages: `pip install -r requirements.txt`
3. Set up the MySQL database by importing the `AcuCRM.sql` file.
4. Run the application by executing `python acucrm.py`.

## How to Run the Application
After starting the application, it will prompt you for your MySQL username and password. Follow the on-screen instructions to manage and query CRM data.

### Example Output
- Customer details
- Support ticket information
- Sales and product data

## Troubleshooting

- **Cannot Connect to Database**: Verify that the MySQL server is running and your credentials are correct.
- **Database Not Found**: Ensure the **AcuCRM.sql** file is imported correctly.
- **Invalid Input**: Enter valid menu choices or data where required.

For any issues, refer to the error message displayed or consult the application's logs.
