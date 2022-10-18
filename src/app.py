from http import client
from flask import Flask, request
import pymysql.cursors
import json
import os
import boto3
from prometheus_flask_exporter import PrometheusMetrics

app = Flask(__name__)
metrics = PrometheusMetrics(app)

# static information as metric
metrics.info('app_info', 'Application info', version='1.0.3')

# Load Secrets from Secret Manager
client =boto3.client('secretsmanager', region_name='eu-central-1')
response = client.get_secret_value(SecretId ='database/MySQL')
secret_dict = json.loads(response['SecretString'])

# Init Database
# Set default values: #default_db_ip = '34.159.3.127' #default_db_user = 'pexon-training' #default_db_password = 'pexon-training2022!' #default_db_name = 'books' #
def sql_connect():
    db_charset = 'utf8mb4'
    db_connection = pymysql.connect(
    host=secret_dict['DB_IP'],                #os.environ.get('DB_HOST',default_db_ip),
    user=secret_dict['DB_USER'],              #os.environ.get('DB_USER',default_db_user),
    password=secret_dict['DB_PASSWORD'],      #os.environ.get('DB_PASSWORD', default_db_password),
    db=secret_dict['DB_NAME'],                #os.environ.get('DB_NAME',default_db_name),
    charset=db_charset,
    cursorclass=pymysql.cursors.DictCursor
    )
    db_cursor = db_connection.cursor()
    return db_connection,db_cursor

def exit_handler(db_connection,db_cursor):
    db_cursor.close()
    db_connection.close()

def db_get(sql):
    db_connection,db_cursor=sql_connect()
    db_cursor.execute(sql)
    result=db_cursor.fetchall()
    exit_handler(db_connection,db_cursor)
    return result

def db_post(sql, values):
    db_connection,db_cursor=sql_connect()
    db_cursor.execute(sql, values)
    db_connection.commit()
    result=db_cursor.fetchall()
    exit_handler(db_connection,db_cursor)
    return result

def db_get_id(sql, id):
    db_connection,db_cursor=sql_connect()
    db_cursor.execute(sql, id)
    result=db_cursor.fetchall()
    exit_handler(db_connection,db_cursor)
    return result

def db_get_year(sql, year):
    db_connection,db_cursor=sql_connect()
    db_cursor.execute(sql, year)
    result=db_cursor.fetchall()
    exit_handler(db_connection,db_cursor)
    return result

def db_delete(sql, id):
    db_connection,db_cursor=sql_connect()
    db_cursor.execute(sql, id)
    db_connection.commit()
    result=db_cursor.fetchall()
    exit_handler(db_connection,db_cursor)
    return result

# Index Route
@app.route('/', methods=['GET', 'POST'])
# @metrics.do_not_track()
def index():
    return 'Willkommen bei: BooksBetter'

# route to see all available books or add one to thee db
@app.route('/api/v1/book', methods=['GET', 'POST'])
def books():
    result = None
    if request.method == 'GET':
        sql = 'SELECT * FROM books'
        result = db_get(sql)  
    if request.method == 'POST':
        body = request.json
        sql = 'INSERT INTO books (title, year_written, author) VALUES (%s, %s, %s)'
        result = db_post(sql, (body['title'], body['year_written'], body['author']))
    return json.dumps(result)

#route to get book by id
@app.route('/api/v1/book/<int:id>', methods=['GET'])
def book_id(id):
    sql = 'SELECT * FROM books WHERE id=%s'
    result = db_get_id(sql, id)
    return json.dumps(result)

#route to get book by year
@app.route('/api/v1/book/year/<int:year>', methods=['GET'])
def book_year(year):
    sql = 'SELECT * FROM books WHERE year_written= %s'
    result = db_get_year(sql, year)
    return json.dumps(result)

#route to remove a book
@app.route('/api/v1/book/<int:id>', methods = ['DELETE'])
def remove_book(id):
    sql = 'DELETE FROM books WHERE id=%s'
    result = db_delete(sql, id)
    return json.dumps(result)
    
if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8080))  # Erhalte den Port aus der Environment Variable, sonst benutze 8080
    app.run(host='0.0.0.0', port=port)      # Starte die App
