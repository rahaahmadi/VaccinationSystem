import connection
import callproc

conn = connection.connect()
cursor = conn.cursor()


def registerInput():
    id = input('id: ')
    password = input('password: ')
    name = input('name: ')
    lastName = input('last name: ')
    birth = input('date of birth: ')
    gender = input('gender: ')
    disease = input('do you have any disease? (yes/no): ')
    return id, password, name, lastName, birth, gender, disease


def printResult(results):
    rows = ()
    for result in results:
        rows = result.fetchall()

    for row in rows:
        print(row)

print('Welcome')
while True:
    print('1)Register\t\t2)Login\t\t3)Menu')
    cmd = int(input())
    if cmd == 1:
        print('1)Register as user\t\t2)Register as doctor\t\t3)Register as nurse')
        cmd = int(input())
        if cmd == 1:
            id, password, name, lastName, birth, gender, disease = registerInput()
            args = (id, password, name, lastName, birth, gender, disease)
            callproc.register(cursor, args)
            conn.commit()
        elif cmd == 2:
            id, password, name, lastName, birth, gender, disease = registerInput()
            med_id = input('medical id: ')
            args = (id, password, name, lastName, birth, gender, disease, med_id)
            callproc.doctorRegister(cursor, args)
            conn.commit()
        elif cmd == 3:
            id, password, name, lastName, birth, gender, disease = registerInput()
            nurse_id = input('nurse id: ')
            degree = input('degree: ')
            args = (id, password, name, lastName, birth, gender, disease, nurse_id, degree)
            callproc.nurseRegister(cursor, args)
            conn.commit()
    elif cmd == 2:
        id = input('id: ')
        password = input('password: ')
        args = (id, password)
        results = callproc.login(cursor, args)
        conn.commit()
        for result in results:
            rows = result.fetchall()
            for row in rows:
                print('your tag is: ', row[0])
    elif cmd == 3:
        print('1)Add Brand\t\t2)Add Health Center\t\t3)Delete Account\t\t4)Add Vial\n5)Add Injection\t\t'
              '6)View Profile\t\t7)Change Password\t\t8)Rate Vaccination Center\n9)Get Center Rate\t\t'
              '10)Get Number of Injection\t\t11)Get number of vaccinated per brand\n'
              '12)Get total number of vaccinated\t\t13)Get center rate per brand\t\t14)Customize center rate\n15)back'
              '')
        cmd = int(input())
        if cmd == 1:
            tag = input('tag: ')
            name = input('brand name: ')
            dose = input('dose: ')
            interval = input('days between doses: ')
            args = (tag, name, dose, interval)
            callproc.addBrand(cursor, args)
            conn.commit()
        elif cmd == 2:
            tag = input('tag: ')
            name = input('Center Name: ')
            address = input('Center Address: ')
            args = (tag, name, address)
            callproc.addHealthCenter(cursor, args)
            conn.commit()
        elif cmd == 3:
            tag = input('tag: ')
            id = input('User ID: ')
            args = (tag, id)
            callproc.deleteAccount(cursor, args)
            conn.commit()
        elif cmd == 4:
            tag = input('tag: ')
            serialNo = input('Serial Number: ')
            brand = input('Brand: ')
            dateOfProduction = input('Date of Production: ')
            dose = input('dose: ')
            center = input('center: ')
            args = (tag, serialNo, brand, dateOfProduction, dose, center)
            callproc.addVial(cursor, args)
            conn.commit()
        elif cmd == 5:
            tag = input('tag: ')
            id = input('Vaccinated ID: ')
            center = input('Vaccination Center: ')
            vial_id = input('Vial Serial Number: ')
            args = (tag, id, center, vial_id)
            callproc.addInjection(cursor, args)
            conn.commit()
        elif cmd == 6:
            tag = input('tag: ')
            results = callproc.viewProfile(cursor, tag)
            conn.commit()
            printResult(results)
        elif cmd == 7:
            tag = input('tag: ')
            oldPass = input('Old Password: ')
            newPass = input('New Password')
            args = (tag, oldPass, newPass)
            callproc.changePassword(cursor, args)
            conn.commit()
        elif cmd == 8:
            tag = input('tag: ')
            center = input('Vaccination Center: ')
            rate = input('Rate: ')
            args = (tag, center, rate)
            callproc.rateVaccinationCenter(cursor, args)
            conn.commit()
        elif cmd == 9:
            pageNo = 1
            results = callproc.getRate(cursor, pageNo)
            conn.commit()
            printResult(results)
        elif cmd == 10:
            results = callproc.getNumberOfInjection(cursor, ())
            conn.commit()
            printResult(results)
        elif cmd == 11:
            results = callproc.getNumberOfVaccinatedPerBrand(cursor, ())
            conn.commit()
            printResult(results)
        elif cmd == 12:
            results = callproc.getTotalNumberOfVaccinated(cursor, ())
            conn.commit()
            printResult(results)
        elif cmd == 13:
            results = callproc.getCenterRatePerBrand(cursor, ())
            conn.commit()
            printResult(results)
        elif cmd == 14:
            tag = input('tag: ')
            results = callproc.customizeCenterRate(cursor, tag)
            conn.commit()
            printResult(results)
        elif cmd == 15:
            continue
    if cmd == 'exit':
        break
