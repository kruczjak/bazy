import psycopg2


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
        with open("data/user.csv") as f:
            content = f.readline()
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

conn.commit()
cur.close()
conn.close()