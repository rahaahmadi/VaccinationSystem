import mysql.connector


def connect():
    connection = mysql.connector.connect(
        host='localhost',
        username='root',
        database='project'
    )

    return connection


def cursor(connection):
    return connection.cursor()
