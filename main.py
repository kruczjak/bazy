import psycopg2
import random

class Company:
    def list(self):
        list = []
        f = open("data/company.csv")
        for content in f.readlines():
            dict = {}
            splitted = content.split('|')
            dict['name'] = splitted[0]
            dict['telephone'] = splitted[1]
            dict['street'] = splitted[2]
            dict['city'] = splitted[3]
            dict['login'] = splitted[4]
            dict['email'] = splitted[5]
            dict['password'] = splitted[6]
            list.append(dict)
        return list


class Users:
    def list(self):
        list = []
        f = open("data/user.csv")
        for content in f.readlines():
            dict = {}
            splitted = content.split('|')
            dict['first_name'] = splitted[0]
            dict['sur_name'] = splitted[1]
            dict['telephone'] = splitted[2]
            dict['street'] = splitted[3]
            dict['city'] = splitted[4]
            dict['login'] = splitted[5]
            dict['email'] = splitted[6]
            dict['password'] = splitted[7]
            list.append(dict)
        return list

class Conference:
    def list(self):
        list = []
        f = open("data/conference.csv")
        for content in f.readlines():
            dict = {}
            splitted = content.split('|')
            dict['name'] = splitted[0]
            dict['start_date'] = splitted[1]
            dict['end_date'] = splitted[1] + ' + ' + splitted[4] #need to test
            dict['discount'] = splitted[5]
            dict['street'] = splitted[2]
            dict['city'] = splitted[3]
            dict['seats'] = splitted[6]
            dict['price'] = splitted[7]
            list.append(dict)
        return list

class Workshops:
    def list(self):
        list=[]
        f = open("data/workshop.csv")
        dict = {}
        for content in f.readlines():
            dict = {}
            splitted = content.split('|')
            dict['name'] = splitted[0]
            dict['start_time'] = splitted[1]
            list.append(dict)
        return list

# MAIN PROGRAM
try:
    conn = psycopg2.connect("dbname=konferencje user=postgres")
except:
    print("No connection to database")
    exit()

cur = conn.cursor()
print(Company().list())
cur.executemany(
    """SELECT add_user(true, %(name)s,NULL, NULL, %(telephone)s, %(street)s, %(city)s, %(login)s, %(email)s, %(password)s )""",
    Company().list())

cur.executemany(
    """SELECT add_user(false, NULL,%(first_name)s, %(sur_name)s, %(telephone)s, %(street)s, %(city)s, %(login)s, %(email)s, %(password)s )""",
    Users().list())

cur.executemany(
    """SELECT add_conference(%(name)s, %(start_date)s, %(end_date)s, %(discount)s, %(street)s, %(city)s, %(seats)s, %(price)s)""",
    Conference().list())


conn.commit()
cur.close()
conn.close()