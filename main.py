import psycopg2
import random
import traceback

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
            dict['login'] = splitted[7]
            dict['email'] = splitted[6]
            dict['password'] = splitted[5]
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
            dict['end_date'] = splitted[4] #need to test
            dict['discount'] = splitted[5]
            dict['street'] = splitted[2]
            dict['city'] = splitted[3]
            dict['seats'] = splitted[6]
            dict['price'] = splitted[7]
            list.append(dict)
        return list

class Workshops:
    def list(self, confdaylist):
        list=[]
        f = open("data/workshop.csv")

        for row in confdaylist:
            for i in range(0, 4):
                dict = {}
                splitted = f.readline().strip().split('|')
                dict['name'] = splitted[0]
                dict['start_date'] = row[2]
                dict['start_time'] = splitted[1] + ":" + splitted[2]
                dict['end_time'] = "3 hours"
                dict['seats'] = splitted[3]
                dict['price'] = splitted[4]
                dict['id_ConfDay'] = row[0]
                list.append(dict)
        return list

class ConfReservations:
    def list(self, confdaylist):
        list=[]
        for row in confdaylist:
            for i in range(0, 2):
                dict = {}
                dict['id_User'] = random.randint(1, 200)
                dict['id_ConfDay'] = row[0]
                dict['reserved_seats'] = int(row[1] / 2)
                list.append(dict)
        return list

class People:
    def list(self, cdr):
        list=[]
        f = open("data/people.csv")
        for row in cdr:
            for i in range(0, row[3]):
                dict = {}
                splitted = f.readline().strip().split('|')
                dict['first_name'] = splitted[0]
                dict['last_name'] = splitted[1]
                dict['id_cdr'] = row[0]
                if random.randint(0, 10)==0:
                    dict['student_card']=123123
                else:
                    dict['student_card']=None
                list.append(dict)
            if row[0] > len(cdr)/4:
                break
        return list

class WorkshopReservations:
    def list(self, cdr):
        list=[]
        for row in cdr:
            dict = {}
            dict['id_workshop'] = row[0]
            dict['id_cdr'] = row[2]
            dict['reserved_seats'] = int(row[1]/20)
            list.append(dict)
        return list
class PeopleToWorkshopReservations:
    def list(self, ptc):
        list = []
        # for row in
# MAIN PROGRAM
try:
    conn = psycopg2.connect("dbname=konferencje user=postgres")
except:
    print("No connection to database")
    exit()

cur = conn.cursor()
cur.execute("""set datestyle = 'ISO, DMY';""")
# USERS (Company)
try:
    cur.executemany(
        """SELECT add_user(true, %(name)s,NULL, NULL, %(telephone)s, %(street)s, %(city)s, %(login)s, %(email)s, %(password)s )""",
        Company().list())
    conn.commit()
except:
    print("Pomijam Company")
    print(traceback.print_exc())
# Users
try:
    cur.executemany(
        """SELECT add_user(false, NULL,%(first_name)s, %(sur_name)s, %(telephone)s, %(street)s, %(city)s, %(login)s, %(email)s, %(password)s )""",
        Users().list())
    conn.commit()
except:
    print("Pomijam users")
    print(traceback.print_exc())
# Conferences + ConfDays
try:
    cur.executemany(
        "SELECT add_conference(%(name)s, %(start_date)s, date %(start_date)s + integer %(end_date)s, %(discount)s, %(street)s, %(city)s, %(seats)s, %(price)s)",
        Conference().list())
    conn.commit()
except:
    print("Pomijam Conference")
    print(traceback.print_exc())

conn.commit()
# Workshops
cur.execute("""SELECT * FROM \"ConfDay\"""")
list = cur.fetchall()
try:
    cur.executemany(
        """SELECT add_workshop(%(id_ConfDay)s, %(name)s, date %(start_date)s + time %(start_time)s, date %(start_date)s + time %(start_time)s + interval %(end_time)s, %(seats)s, %(price)s)""",
        Workshops().list(list))
    conn.commit()
except:
    print("Pomijam Workshop")
    print(traceback.print_exc())
# ConfReservations + ConfDayReservations
try:
    cur.executemany(
        """SELECT create_confreservation(%(id_User)s, %(id_ConfDay)s, %(reserved_seats)s)""",
        ConfReservations().list(list)
    )
    conn.commit()
except:
    print("Pomijam Confreservation")
    print(traceback.print_exc())
# People to ConfDayReservations
cur.execute("""SELECT * FROM \"ConfDayReservation\"""")
cdr = cur.fetchall()
try:
    cur.executemany(
        """SELECT connect_person_to_conference(%(first_name)s, %(last_name)s, %(id_cdr)s, %(student_card)s)""",
        People().list(cdr)
    )
    conn.commit()
except:
    print("Pomijam People")
    print(traceback.print_exc())
print("next")
# WorkshopReservations
cur.execute("""SELECT DISTINCT w.id, w.seats, cdr.id, cdr.reserved_seats
FROM \"ConfDay\" cd
INNER JOIN \"Workshop\" w ON w.\"id_ConfDay\" = cd.id
INNER JOIN \"ConfDayReservation\" cdr ON cd.id = cdr.\"id_ConfDay\"""")
cdAndWorkshop = cur.fetchall()
try:
    cur.executemany(
        """SELECT reserve_workshop(%(id_cdr)s, %(id_workshop)s, %(reserved_seats)s)""",
        WorkshopReservations().list(cdAndWorkshop)
    )
except:
    print("Pomijam WorkshopReservation")
    print(traceback.print_exc())

# cur.execute("""SELECT * FROM \"PeopleAndConfReservation\"""")
# ptc = cur.fetchall()
# try:
#     cur.executemany(
#         """SELECT connect_person_to_workshop(%(id_ptc)s, %(id_wr))""",
#         PeopleToWorkshopReservations().list(ptc)
#     )
#     conn.commit()
# except:
#     print("Pomijam People to Workshop")
#     print(traceback.print_exc())

conn.commit()
cur.close()
conn.close()