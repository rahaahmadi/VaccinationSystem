def refresh_cursor(cursor):
    cursor.fetchall()


def register(cursor, args):
    try:
        cursor.callproc('register', args)
        print('successful')
    except Exception as e:
        print(e)


def doctorRegister(cursor, args):
    try:
        cursor.callproc('doctorRegister', args)
        print('successful')
    except Exception as e:
        print(e)


def nurseRegister(cursor, args):
    try:
        cursor.callproc('nurseRegister', args)
        print('successful')
    except Exception as e:
        print(e)


def login(cursor, args):
    try:
        cursor.callproc('login', args)
        print('successful')
    except Exception as e:
        print(e)
    return cursor.stored_results()


def addBrand(cursor, args):
    try:
        cursor.callproc('addBrand', args)
        print('successful')
    except Exception as e:
        print(e)


def addHealthCenter(cursor, args):
    try:
        cursor.callproc('addHealthCenter', args)
        print('successful')
    except Exception as e:
        print(e)


def deleteAccount(cursor, args):
    try:
        cursor.callproc('deleteAccount', args)
        print('successful')
    except Exception as e:
        print(e)


def addVial(cursor, args):
    try:
        cursor.callproc('addVial', args)
        print('successful')
    except Exception as e:
        print(e)


def addInjection(cursor, args):
    try:
        cursor.callproc('addInjection', args)
        print('successful')
    except Exception as e:
        print(e)


def viewProfile(cursor, args):
    try:
        cursor.callproc('viewProfile', args)
    except Exception as e:
        print(e)
    return cursor.stored_results()


def changePassword(cursor, args):
    try:
        cursor.callproc('changePassword', args)
        print('successful')
    except Exception as e:
        print(e)


def rateVaccinationCenter(cursor, args):
    try:
        cursor.callproc('rateVaccinationCenter', args)
        print('successful')
    except Exception as e:
        print(e)


def getRate(cursor, args):
    try:
        cursor.callproc('getRate', args)
    except Exception as e:
        print(e)
    return cursor.stored_results()


def getNumberOfInjection(cursor, args):
    try:
        cursor.callproc('getNumberOfInjection', args)
    except Exception as e:
        print(e)
    return cursor.stored_results()


def getNumberOfVaccinatedPerBrand(cursor, args):
    try:
        cursor.callproc('getNumberOfVaccinatedPerBrand', args)
    except Exception as e:
        print(e)
    return cursor.stored_results()


def getTotalNumberOfVaccinated(cursor, args):
    try:
        cursor.callproc('getTotalNumberOfVaccinated', args)
    except Exception as e:
        print(e)
    return cursor.stored_results()


def getCenterRatePerBrand(cursor, args):
    try:
        cursor.callproc('getCenterRatePerBrand', args)
    except Exception as e:
        print(e)
    return cursor.stored_results()


def customizeCenterRate(cursor, args):
    try:
        cursor.callproc('customizeCenterRate', args)
    except Exception as e:
        print(e)
    return cursor.stored_results()



