import sqlite3
import json
import os

def create_db():
    json_path = os.path.join(os.path.dirname(__file__), '..', 'frontend', 'products.json')
    db_path = os.path.join(os.path.dirname(__file__), 'products.db')
    
    with open(json_path, 'r', encoding='utf-8') as f:
        products = json.load(f)
        
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS products (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            price TEXT NOT NULL,
            description TEXT NOT NULL,
            categoryId TEXT NOT NULL,
            subcategory TEXT NOT NULL,
            isNew BOOLEAN NOT NULL DEFAULT 0,
            isSale BOOLEAN NOT NULL DEFAULT 0
        )
    ''')
    
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS product_images (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            product_id TEXT NOT NULL,
            image_url TEXT NOT NULL,
            image_order INTEGER NOT NULL,
            FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
        )
    ''')
    

    cursor.execute('''
        CREATE TABLE IF NOT EXISTS product_sizes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            product_id TEXT NOT NULL,
            size_name TEXT NOT NULL,
            quantity INTEGER NOT NULL DEFAULT 0,
            price TEXT,
            FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
        )
    ''')
    
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS product_reviews (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            product_id TEXT NOT NULL,
            review_id TEXT NOT NULL,
            user_name TEXT NOT NULL,
            rating REAL NOT NULL,
            comment TEXT NOT NULL,
            review_date TEXT NOT NULL,
            FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
        )
    ''')
    
    cursor.execute('DELETE FROM product_reviews')
    cursor.execute('DELETE FROM product_sizes')
    cursor.execute('DELETE FROM product_images')
    cursor.execute('DELETE FROM products')
    
    # Insert Data
    for p in products:
        cursor.execute('''
            INSERT INTO products (id, title, price, description, categoryId, subcategory, isNew, isSale)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        ''', (p['id'], p['title'], p['price'], p['description'], p['categoryId'], p['subcategory'], p.get('isNew', False), p.get('isSale', False)))
        
        # Insert Images
        for idx, img in enumerate(p.get('images', [])):
            cursor.execute('''
                INSERT INTO product_images (product_id, image_url, image_order)
                VALUES (?, ?, ?)
            ''', (p['id'], img, idx))
            
        # Insert Sizes
        inventory = p.get('inventory', {})
        size_prices = p.get('sizePrices') or {}
        for size_name, qty in inventory.items():
            size_price = size_prices.get(size_name)
            cursor.execute('''
                INSERT INTO product_sizes (product_id, size_name, quantity, price)
                VALUES (?, ?, ?, ?)
            ''', (p['id'], size_name, qty, size_price))
            
        # Insert Reviews
        for r in p.get('reviews', []):
            cursor.execute('''
                INSERT INTO product_reviews (product_id, review_id, user_name, rating, comment, review_date)
                VALUES (?, ?, ?, ?, ?, ?)
            ''', (p['id'], r['id'], r['userName'], r['rating'], r['comment'], r['date']))
            
    conn.commit()
    conn.close()
    print("products.db created successfully with normalized tables!")

if __name__ == '__main__':
    create_db()
