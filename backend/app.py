from flask import Flask, request, jsonify
from flask_cors import CORS
import sqlite3
import uuid
from datetime import datetime

app = Flask(__name__)
CORS(app, resources={r"/*": {
    "origins": "*",
    "methods": ["GET", "POST", "OPTIONS"],
    "allow_headers": ["Content-Type", "Authorization"]
}}) 

def get_db_connection():
    conn = sqlite3.connect('users.db')
    conn.row_factory = sqlite3.Row
    return conn

def get_products_db_connection():
    conn = sqlite3.connect('products.db')
    conn.row_factory = sqlite3.Row
    return conn

@app.route('/signup', methods=['POST'])
def signup():
    data = request.get_json()
    if not data or not data.get('name') or not data.get('email') or not data.get('password'):
        return jsonify({'error': 'Missing required fields: name, email, password'}), 400
    
    name = data['name']
    email = data['email']
    password = data['password']

    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("INSERT INTO users (name, email, password, cart_data) VALUES (?, ?, ?, '[]')", (name, email, password))
        conn.commit()
        user_id = cursor.lastrowid
        return jsonify({'message': 'User created successfully', 'id': user_id, 'name': name}), 201
    except sqlite3.IntegrityError:
        return jsonify({'error': 'Email already exists'}), 409
    finally:
        conn.close()

@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    if not data or not data.get('email') or not data.get('password'):
        return jsonify({'error': 'Missing required fields: email, password'}), 400

    email = data['email']
    password = data['password']

    conn = get_db_connection()
    user = conn.execute("SELECT * FROM users WHERE email = ? AND password = ?", (email, password)).fetchone()
    conn.close()

    if user:
        cart_data = user['cart_data'] if 'cart_data' in user.keys() else '[]'
        return jsonify({
            'message': 'Login successful', 
            'id': user['id'], 
            'name': user['name'],
            'cart_data': cart_data
        }), 200
    else:
        return jsonify({'error': 'Invalid credentials'}), 401

@app.route('/update_cart', methods=['POST'])
def update_cart():
    data = request.get_json()
    if not data or 'id' not in data or 'cart_data' not in data:
        return jsonify({'error': 'Missing required fields: id, cart_data'}), 400

    user_id = data['id']
    cart_data = data['cart_data'] # This should be a JSON string of the cart items

    conn = get_db_connection()
    try:
        conn.execute("UPDATE users SET cart_data = ? WHERE id = ?", (cart_data, user_id))
        conn.commit()
        return jsonify({'message': 'Cart updated successfully'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

@app.route('/products', methods=['GET'])
def get_products():
    conn = get_products_db_connection()
    cursor = conn.cursor()
    
    products_db = cursor.execute("SELECT * FROM products").fetchall()
    
    products_list = []
    for p in products_db:
        p_dict = dict(p)
        prod_id = p_dict['id']
        
        # Images
        images_db = cursor.execute("SELECT image_url FROM product_images WHERE product_id = ? ORDER BY image_order", (prod_id,)).fetchall()
        p_dict['images'] = [row['image_url'] for row in images_db]
        
        # Sizes and Pricing
        sizes_db = cursor.execute("SELECT size_name, quantity, price FROM product_sizes WHERE product_id = ?", (prod_id,)).fetchall()
        inventory = {}
        sizePrices = {}
        for row in sizes_db:
            inventory[row['size_name']] = row['quantity']
            if row['price'] is not None:
                sizePrices[row['size_name']] = row['price']
                
        p_dict['inventory'] = inventory
        if sizePrices:
            p_dict['sizePrices'] = sizePrices
        else:
            p_dict['sizePrices'] = None
            
        # Reviews
        reviews_db = cursor.execute("SELECT review_id as id, user_name as userName, rating, comment, review_date as date FROM product_reviews WHERE product_id = ?", (prod_id,)).fetchall()
        p_dict['reviews'] = [dict(r) for r in reviews_db]
        
        # Convert bools properly
        p_dict['isNew'] = bool(p_dict['isNew'])
        p_dict['isSale'] = bool(p_dict['isSale'])
        
        products_list.append(p_dict)
        
    conn.close()
    return jsonify(products_list), 200

@app.route('/add_review', methods=['POST'])
def add_review():
    data = request.get_json()
    
    if not data or not data.get('product_id') or not data.get('user_name') or not data.get('rating') or not data.get('comment'):
        return jsonify({'error': 'Missing required fields'}), 400
        
    product_id = data['product_id']
    user_name = data['user_name']
    rating = float(data['rating'])
    comment = data['comment']
    
    review_id = str(uuid.uuid4())
    review_date = datetime.now().isoformat()

    conn = get_products_db_connection()
    cursor = conn.cursor()
    
    try:
        cursor.execute('''
            INSERT INTO product_reviews (product_id, review_id, user_name, rating, comment, review_date)
            VALUES (?, ?, ?, ?, ?, ?)
        ''', (product_id, review_id, user_name, rating, comment, review_date))
        conn.commit()
        return jsonify({'message': 'Review added successfully!', 'review_id': review_id}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

@app.route('/get_reviews/<product_id>', methods=['GET'])
def get_reviews(product_id):
    conn = get_products_db_connection()
    cursor = conn.cursor()
    try:
        reviews_db = cursor.execute("SELECT review_id as id, user_name as userName, rating, comment, review_date as date FROM product_reviews WHERE product_id = ? ORDER BY review_date DESC", (product_id,)).fetchall()
        reviews = [dict(r) for r in reviews_db]
        return jsonify(reviews), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

if __name__ == '__main__':
    app.run(debug=True, port=5000, host='0.0.0.0')
