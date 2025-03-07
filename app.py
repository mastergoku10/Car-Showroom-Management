from flask import Flask, render_template, request, redirect, url_for, flash, session
import pymysql as db

app = Flask(__name__)
app.secret_key = "your_secret_key"

# Database Connection
def get_db_connection():
    return db.connect(host="127.0.0.1", user="root", password="Mysql@1001", database="car_showroom")

# Routes
@app.route('/')
def index():
    return render_template("index.html")

@app.route('/login')
def login():
    return render_template("login.html")

@app.route('/create_user', methods=['GET', 'POST'])
def create_user():
    if request.method == 'POST':
        userName = request.form['username']
        fullName = request.form['fullName']
        email = request.form['email']
        userPass = request.form['password']
        userType = request.form['userType']
        contact = request.form['contact']  # Changed from 'contact' to 'phone'
        
        conn = get_db_connection()
        cur = conn.cursor()
        qry = "INSERT INTO employee (userName, fullName, email, userPass, userType, contact) VALUES (%s, %s, %s, %s, %s, %s)"
        cur.execute(qry, (userName, fullName, email, userPass, userType, contact))
        conn.commit()
        conn.close()
        
        flash("User created successfully", "success")
        return redirect(url_for("view_employees"))
    return render_template("create_user.html")

@app.route('/authenticate', methods=['POST'])
def authenticate():
    userName = request.form['username']
    userPass = request.form['password']
    userType = request.form['usertype']
    conn = get_db_connection()
    cur = conn.cursor()
    qry = "SELECT * FROM employee WHERE userName=%s AND userPass=%s AND userType=%s"
    cur.execute(qry, (userName, userPass, userType))
    user = cur.fetchone()
    conn.close()
    if user:
        session['user'] = userName
        session['user_type'] = userType
        if userType == "admin":
            return redirect(url_for("admin_dashboard"))
        elif userType == "employee":
            return redirect(url_for("employee_dashboard"))
    else:
        flash("Invalid login credentials", "danger")
        return redirect(url_for("login"))

@app.route('/admin_dashboard')
def admin_dashboard():
    if 'user' in session and session['user_type'] == 'admin':
        return render_template("admin_dashboard.html")
    else:
        flash("Unauthorized access", "danger")
        return redirect(url_for("login"))

@app.route('/employee_dashboard')
def employee_dashboard():
    if 'user' in session and session['user_type'] == 'employee':
        return render_template("employee_dashboard.html")
    else:
        flash("Unauthorized access", "danger")
        return redirect(url_for("login"))

@app.route('/delete_user/<userName>', methods=['POST'])
def delete_user(userName):
    conn = get_db_connection()
    cur = conn.cursor()
    qry = "DELETE FROM employee WHERE userName = %s"
    cur.execute(qry, (userName,))
    conn.commit()
    conn.close()
    flash("User deleted successfully", "success")
    return redirect(url_for("view_employees"))

@app.route('/view_employees')
def view_employees():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT * FROM employee")
    employees = cur.fetchall()
    conn.close()
    return render_template("view_employees.html", employees=employees)


@app.route('/view_car_details')
def view_car_details():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT * FROM car_details")
    cars = cur.fetchall()
    cur.execute("SELECT DISTINCT model_name FROM car_details")
    models = [row[0] for row in cur.fetchall()]
    cur.execute("SELECT DISTINCT variant FROM car_details")
    variants = [row[0] for row in cur.fetchall()]
    conn.close()
    return render_template("view_car_details.html", cars=cars, models=models, variants=variants)

@app.route('/view_inventory')
def view_inventory():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT * FROM inventory")
    inventory = cur.fetchall()
    conn.close()
    return render_template("view_inventory.html", inventory=inventory)

@app.route('/view_sales')
def view_sales():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT sale_id, car_name, car_model, colour, customer_Id, sale_date, amount, payment_status, payment_method, customerName, customerPhone, customerAddress FROM sales")
    sales = cur.fetchall()
    conn.close()
    return render_template("view_sales.html", sales=sales)


@app.route('/add_car', methods=["GET", "POST"])
def add_car():
    if request.method == "POST":
        car_id = request.form['car_id']
        model_name = request.form['model_name']
        variant = request.form['variant']
        engine_type = request.form['engine_type']
        engine_spec = request.form['engine_spec']
        power = request.form['power']
        torque = request.form['torque']
        transmission = request.form['transmission']
        fuel_efficiency = request.form['fuel_efficiency']
        price = request.form['price']
        colour = request.form['colour']
        image = request.form['image']

        conn = get_db_connection()
        cur = conn.cursor()
        qry = "INSERT INTO car_details VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
        cur.execute(qry, (car_id, model_name, variant, engine_type, engine_spec, power, torque, transmission, fuel_efficiency, price, colour, image))
        conn.commit()
        conn.close()
        flash("Car added successfully", "success")
        return render_template("add_car.html")  # Stay on the same page
    return render_template("add_car.html")

@app.route('/add_inventory', methods=["GET", "POST"])
def add_inventory():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT DISTINCT model_name FROM car_details")
    models = [row[0] for row in cur.fetchall()]
    cur.execute("SELECT DISTINCT variant FROM car_details")
    variants = [row[0] for row in cur.fetchall()]
    conn.close()
    
    if request.method == "POST":
        inventory_id = request.form['inventory_id']
        model_name = request.form['model_name']
        variant = request.form['variant']
        stock_quantity = request.form['stock_quantity']
        received_date = request.form['received_date']
        sold_quantity = request.form['sold_quantity']

        conn = get_db_connection()
        cur = conn.cursor()
        qry = "INSERT INTO inventory (inventory_id, model_name, variant, stock_quantity, received_date, sold_quantity) VALUES (%s, %s, %s, %s, %s, %s)"
        cur.execute(qry, (inventory_id, model_name, variant, stock_quantity, received_date, sold_quantity))
        conn.commit()
        conn.close()
        flash("Inventory added successfully", "success")
        return render_template("add_inventory.html", models=models, variants=variants)  # Stay on the same page
    return render_template("add_inventory.html", models=models, variants=variants)

@app.route('/add_sales', methods=["GET", "POST"])
def add_sales():
    if request.method == "POST":
        sale_id = request.form['sale_id']
        car_name = request.form['car_name']
        car_model = request.form['car_model']
        colour = request.form['colour']
        customer_id = request.form['customer_id']
        sale_date = request.form['sale_date']
        amount = request.form['amount']
        payment_status = request.form['payment_status']
        payment_method = request.form['payment_method']
        customer_name = request.form['customer_name']
        customer_phone = request.form['customer_phone']
        customer_address = request.form['customer_address']

        conn = get_db_connection()
        cur = conn.cursor()
        qry = "INSERT INTO sales (sale_id, car_name, car_model, colour, customer_Id, sale_date, amount, payment_status, payment_method, customerName, customerPhone, customerAddress) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
        cur.execute(qry, (sale_id, car_name, car_model, colour, customer_id, sale_date, amount, payment_status, payment_method, customer_name, customer_phone, customer_address))
        conn.commit()
        conn.close()
        flash("Sale added successfully", "success")
        return redirect(url_for('view_sales'))
    return render_template("add_sales.html")  

@app.route('/get_car_models')
def get_car_models():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT DISTINCT model_name FROM car_details")
    models = [row[0] for row in cur.fetchall()]
    conn.close()
    return {"models": models}

@app.route('/get_car_variants/<model_name>')
def get_car_variants(model_name):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT DISTINCT variant FROM car_details WHERE model_name = %s", (model_name,))
    variants = [row[0] for row in cur.fetchall()]
    conn.close()
    return {"variants": variants}

@app.route('/get_car_colours/<model_name>')
def get_car_colours(model_name):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT DISTINCT colour FROM car_details WHERE model_name = %s", (model_name,))
    colours = [row[0] for row in cur.fetchall()]
    conn.close()
    return {"colours": colours}

@app.route('/add_monthly_sales', methods=["GET", "POST"])
def add_monthly_sales():
    if request.method == "POST":
        serial_no = request.form['serial_no']
        model_name = request.form['model_name']
        sales_year = request.form['sales_year']
        total_sales = request.form['total_sales']

        conn = get_db_connection()
        cur = conn.cursor()
        qry = "INSERT INTO monthly_sales (serial_no, model_name, sales_year, total_sales) VALUES (%s, %s, %s, %s)"
        cur.execute(qry, (serial_no, model_name, sales_year, total_sales))
        conn.commit()
        conn.close()
        flash("Monthly sales record added successfully", "success")
        return render_template("add_monthly_sales.html")  # Stay on the same page
    return render_template("add_monthly_sales.html")

@app.route('/view_monthly_sales')
def view_monthly_sales():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT * FROM monthly_sales")
    monthly_sales = cur.fetchall()
    conn.close()
    return render_template("view_monthly_sales.html", monthly_sales=monthly_sales)

@app.route('/logout')
def logout():
    session.pop('user', None)
    session.pop('user_type', None)
    return redirect(url_for("login"))

if __name__ == '__main__':
    print("WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.")
    app.run(debug=True)