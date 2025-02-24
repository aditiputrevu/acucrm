#  ***AcuCRM: Your Ultimate Data Management Tool!*** 

Are you ready to transform how you manage and interact with your customer data? Meet **AcuCRM**, the Python-powered application that connects seamlessly to a MySQL server and makes CRM data management a breeze! Whether you're tracking sales, handling support tickets, or managing customer interactions, AcuCRM has got your back.

### What's inside the magic box? 🧙‍♂️
AcuCRM is your personal CRM assistant, built to handle the heavy lifting of managing customer data. With this app, you can:
- 🧑‍💼 Retrieve detailed customer data
- 🎟️ Manage and update support tickets
- 💰 Track sales and campaigns
- 📦 Handle product promotions and orders
... and a lot more fun features!

## 🚀 Features That’ll Blow Your Mind
- **💻 Database Connection**: Secure and smooth connection to your MySQL database with easy-to-follow prompts. Just enter your credentials and get started! If you're feeling adventurous, type `exit` anytime to bail out without drama.
  
- **👥 Customer Management**: Fetch detailed information about your customers—check out their support tickets, orders, and interactions in just a few clicks.

- **🎟️ Support Ticket Management**: View, create, and update support tickets easily. No more getting lost in a sea of tickets!

- **💵 Sales Tracking**: Get insights on sales, track revenue, analyze conversion rates, and see campaign performance at a glance. Perfect for the data-driven marketer!

- **🎁 Product & Promotion Management**: Quickly fetch product info, promotions, and special gift sets—everything you need for a stellar customer experience.

- **🛍️ Order Management**: Dive into your order data to see what products are flying off the shelves (and which ones need a little extra push).

- **⚠️ Error Handling Like a Pro**: No more crashing and burning—this app gracefully handles common database and user errors to keep things running smoothly.

## 🛠️ Prerequisites (Get Ready to Dive In!)

### ⚙️ Database Setup
To get started, you'll need a **MySQL database**. Here's what you need to do:
- Create the **AcuCRM** database and set up all the necessary tables.
- Import the provided **AcuCRM.sql** file to establish the schema and seed initial data. Trust us, it's like magic in the making!

### 🔑 MySQL User Privileges
- Ensure your MySQL user is privileged to access, modify, and query the **AcuCRM** database. Don't worry, we’ll guide you through it!

### 🧑‍💻 Database Credentials
The app connects to the database using these parameters:
- **Host**: Set to `localhost`. You can change this if you're working with a remote database server.
- **User**: Enter your actual MySQL username when prompted.
- **Password**: Keep your MySQL password safe and secure.
- **Database**: Set to `AcuCRM`.

## 🔥 Installation Steps (Let's Get It Rolling)
1. Clone the repo to your local machine with `git clone https://github.com/aditiputrevu/acucrm.git`.
2. Install the required Python packages: `pip install -r requirements.txt`.
3. Set up the MySQL database by importing the `AcuCRM.sql` file (this is the fun!).
4. Run the application: `python acucrm.py`.

## 🚀 How to Run the Application
Once the app runs, you’ll be prompted to enter your MySQL username and password. Once connected, you can manage everything CRM—from customer info to support tickets, sales data, and more!

### 🌟 Example Output
- See detailed customer profiles with their support tickets and interactions.
- View sales performance and customer order details.
- Manage product promotions and track campaign performance—all from one place!

## 🛠️ Troubleshooting (Don't Worry, We’ve Got Your Back!)
- **💥 Cannot Connect to Database**: Ensure the MySQL server is running and your credentials are correct. A simple check can save the day!
- **📂 Database Not Found**: Double-check that the **AcuCRM.sql** file was imported properly. It’s your database’s magic wand!
- **🚫 Invalid Input**: Enter valid menu choices or data when prompted. We promise it's not a trick question!

Don’t hesitate to check out the error messages or consult the logs for any issues.

## 🌍 Enjoy Using AcuCRM!

Thanks for checking out **AcuCRM**! We hope this tool helps you manage your CRM data with ease.

