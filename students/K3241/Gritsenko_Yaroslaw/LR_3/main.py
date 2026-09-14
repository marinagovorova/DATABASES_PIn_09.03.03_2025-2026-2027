import psycopg2
from psycopg2 import sql
from faker import Faker
import random
from datetime import datetime, timedelta

# ---------- Параметры подключения (измените под свои) ----------
DB_CONFIG = {
    'dbname': 'pin_db',      # имя вашей БД
    'user': 'postgres',
    'password': 'postgres',
    'host': 'localhost',
    'port': 5432
}

# ---------- Настройки количества генерируемых записей ----------
N_PROGRAM_TYPES      = 5
N_LOCATIONS          = 10
N_LESSON_TYPES       = 3
N_DOCUMENT_TYPES     = 3
N_STUDENTS           = 150
N_TEACHERS           = 30
N_HOURS_VOLUMES      = 50
N_DISCIPLINES        = 100
N_PROGRAMS           = 20
N_CLASSROOMS         = 30
N_LESSONS            = 200
N_GROUPS             = 30
N_ATTESTATIONS       = 100
N_DOCUMENTS          = 120

# Вспомогательные - для связей
STUDENTS_PER_GROUP = 15   # среднее число студентов в группе
GROUPS_PER_STUDENT = 2    # каждый студент может быть в нескольких группах
TEACHER_DISCIPLINES = 4   # каждый преподаватель ведёт несколько дисциплин
LESSONS_PER_GROUP = 10    # занятий на одну группу
ATTEST_PER_DISCIPLINE = 2 # аттестаций на дисциплину

# ---------- Инициализация ----------
fake = Faker('ru_RU')  # русскоязычные имена, адреса и пр.
random.seed(42)
Faker.seed(42)

conn = psycopg2.connect(**DB_CONFIG)
cur = conn.cursor()

# ---------- Функции-заполнители таблиц ----------
def populate_program_types():
    names = ['Повышение квалификации', 'Профессиональная переподготовка',
             'Краткосрочный курс', 'Семинар', 'Мастер-класс']
    for name in names:
        cur.execute("INSERT INTO program_type (type_name) VALUES (%s)", (name,))
    conn.commit()

def populate_locations():
    for _ in range(N_LOCATIONS):
        name = fake.company()[:50]
        address = fake.address()[:50]
        cur.execute("INSERT INTO location (name, address) VALUES (%s, %s)", (name, address))
    conn.commit()

def populate_lesson_types():
    types = ['лекция', 'лабораторная работа', 'практическое занятие']
    for t in types:
        cur.execute("INSERT INTO lesson_type (name) VALUES (%s)", (t,))
    conn.commit()

def populate_document_types():
    types = ['сертификат о повышении квалификации',
             'удостоверение о повышении квалификации',
             'диплом о профпереподготовке']
    for t in types:
        cur.execute("INSERT INTO document_type (type_name) VALUES (%s)", (t,))
    conn.commit()

def populate_students():
    for _ in range(N_STUDENTS):
        first_name = fake.first_name()[:100]
        last_name = fake.last_name()[:100]
        middle_name = fake.middle_name()[:100] if random.random() > 0.3 else None
        phone = fake.phone_number()[:30]
        passport = f"{random.randint(1000,9999)} {random.randint(100000,999999)}"
        education = random.choice(['среднее', 'высшее', 'неоконченное высшее', None])
        cur.execute("""
            INSERT INTO student (first_name, last_name, middle_name, phone, passport, education)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (first_name, last_name, middle_name, phone, passport, education))
    conn.commit()

def populate_teachers():
    positions = ['преподаватель', 'старший преподаватель', 'доцент', 'профессор', 'ассистент']
    for _ in range(N_TEACHERS):
        first_name = fake.first_name()[:100]
        last_name = fake.last_name()[:100]
        middle_name = fake.middle_name()[:100] if random.random() > 0.3 else None
        phone = fake.phone_number()[:30]
        passport = f"{random.randint(1000,9999)} {random.randint(100000,999999)}"
        position = random.choice(positions)
        cur.execute("""
            INSERT INTO teacher (first_name, last_name, middle_name, phone, passport, position)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (first_name, last_name, middle_name, phone, passport, position))
    conn.commit()

def populate_hours_volumes():
    for _ in range(N_HOURS_VOLUMES):
        lectures = random.randint(0, 60)
        lab = random.randint(0, 40)
        practical = random.randint(0, 40)
        internship = random.randint(0, 20)
        cur.execute("""
            INSERT INTO hours_volume (lectures, lab_works, practical, internship)
            VALUES (%s, %s, %s, %s)
        """, (lectures, lab, practical, internship))
    conn.commit()

def populate_disciplines():
    # Получаем id всех hours_volume
    cur.execute("SELECT id FROM hours_volume")
    hours_ids = [row[0] for row in cur.fetchall()]
    if not hours_ids:
        raise ValueError("Сначала заполните таблицу hours_volume")
    for i in range(N_DISCIPLINES):
        description = f"Дисциплина {i+1}: {fake.sentence(nb_words=5)}"[:1000]
        hours_id = random.choice(hours_ids)
        cur.execute("""
            INSERT INTO discipline (description, hours_volume_id)
            VALUES (%s, %s)
        """, (description, hours_id))
    conn.commit()

def populate_programs():
    cur.execute("SELECT id FROM program_type")
    type_ids = [r[0] for r in cur.fetchall()]
    for i in range(N_PROGRAMS):
        code = f"PRG-{i+1:03d}"
        name = f"Программа {i+1}: {fake.catch_phrase()}"[:100]
        desc = fake.text(max_nb_chars=1000) if random.random()>0.3 else None
        total_hours = random.randint(40, 300)
        cost = random.randint(5000, 200000)
        type_id = random.choice(type_ids)
        cur.execute("""
            INSERT INTO program (code, name, description, total_hours, cost, program_type_id)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (code, name, desc, total_hours, cost, type_id))
    conn.commit()

def populate_classrooms():
    cur.execute("SELECT id FROM location")
    loc_ids = [r[0] for r in cur.fetchall()]
    numbers = [f"{random.randint(100,599)}" for _ in range(N_CLASSROOMS)]
    types = ['лекционная', 'компьютерный класс', 'лаборатория', 'аудитория']
    for num in numbers:
        type_ = random.choice(types)
        loc_id = random.choice(loc_ids)
        cur.execute("""
            INSERT INTO classroom (room_number, type, location_id)
            VALUES (%s, %s, %s)
        """, (num, type_, loc_id))
    conn.commit()

def populate_lessons():
    cur.execute("SELECT id FROM classroom")
    class_ids = [r[0] for r in cur.fetchall()]
    cur.execute("SELECT id FROM lesson_type")
    type_ids = [r[0] for r in cur.fetchall()]
    start_date = datetime(2025, 9, 1)
    for i in range(N_LESSONS):
        l_date = start_date + timedelta(days=i)
        class_id = random.choice(class_ids)
        type_id = random.choice(type_ids)
        cur.execute("""
            INSERT INTO lesson (lesson_date, classroom_id, lesson_type_id)
            VALUES (%s, %s, %s)
        """, (l_date, class_id, type_id))
    conn.commit()

def populate_groups():
    cur.execute("SELECT id FROM program")
    prog_ids = [r[0] for r in cur.fetchall()]
    for i in range(N_GROUPS):
        prog_id = random.choice(prog_ids)
        max_students = random.randint(15, 30)
        start = fake.date_between(start_date='-1y', end_date='today')
        end = start + timedelta(days=random.randint(60, 180))
        group_number = f"ГР-{i+1:03d}"
        cur.execute("""
            INSERT INTO student_group (program_id, max_students, start_date, end_date, group_number)
            VALUES (%s, %s, %s, %s, %s)
        """, (prog_id, max_students, start, end, group_number))
    conn.commit()

def populate_program_discipline():
    cur.execute("SELECT id FROM program")
    prog_ids = [r[0] for r in cur.fetchall()]
    cur.execute("SELECT id FROM discipline")
    disc_ids = [r[0] for r in cur.fetchall()]
    pairs = set()
    for prog_id in prog_ids:
        # каждая программа имеет от 4 до 8 дисциплин
        num = random.randint(4, 8)
        chosen = random.sample(disc_ids, min(num, len(disc_ids)))
        for d_id in chosen:
            pairs.add((d_id, prog_id))
    for d_id, p_id in pairs:
        cur.execute("""
            INSERT INTO program_discipline (discipline_id, program_id)
            VALUES (%s, %s)
            ON CONFLICT DO NOTHING
        """, (d_id, p_id))
    conn.commit()

def populate_teacher_discipline():
    cur.execute("SELECT id FROM teacher")
    teacher_ids = [r[0] for r in cur.fetchall()]
    cur.execute("SELECT id FROM discipline")
    disc_ids = [r[0] for r in cur.fetchall()]
    pairs = set()
    for tid in teacher_ids:
        num = random.randint(1, TEACHER_DISCIPLINES)
        chosen = random.sample(disc_ids, min(num, len(disc_ids)))
        for d_id in chosen:
            pairs.add((d_id, tid))
    for d_id, t_id in pairs:
        cur.execute("""
            INSERT INTO teacher_discipline (discipline_id, teacher_id)
            VALUES (%s, %s)
            ON CONFLICT DO NOTHING
        """, (d_id, t_id))
    conn.commit()

def populate_student_in_group():
    cur.execute("SELECT id FROM student")
    student_ids = [r[0] for r in cur.fetchall()]
    cur.execute("SELECT id FROM student_group")
    group_ids = [r[0] for r in cur.fetchall()]
    used = set()
    for s_id in student_ids:
        # каждого студента записываем в 1..3 группы
        num_groups = random.randint(1, GROUPS_PER_STUDENT)
        groups = random.sample(group_ids, min(num_groups, len(group_ids)))
        for g_id in groups:
            used.add((s_id, g_id))
    for s_id, g_id in used:
        start = fake.date_between(start_date='-1y', end_date='today')
        end = start + timedelta(days=random.randint(60, 180))
        cur.execute("""
            INSERT INTO student_in_group (student_id, group_id, start_date, end_date)
            VALUES (%s, %s, %s, %s)
            ON CONFLICT DO NOTHING
        """, (s_id, g_id, start, end))
    conn.commit()

def populate_attestations():
    formats = ['экзамен', 'дифзачет', 'зачет']
    for i in range(N_ATTESTATIONS):
        fmt = random.choice(formats)
        att_date = fake.date_between(start_date='-1y', end_date='+6M')
        cur.execute("""
            INSERT INTO attestation (format, att_date)
            VALUES (%s, %s)
        """, (fmt, att_date))
    conn.commit()

def populate_discipline_attestation():
    cur.execute("SELECT id FROM discipline")
    disc_ids = [r[0] for r in cur.fetchall()]
    cur.execute("SELECT id FROM attestation")
    att_ids = [r[0] for r in cur.fetchall()]
    used = set()
    for d_id in disc_ids:
        num = random.randint(1, ATTEST_PER_DISCIPLINE)
        chosen = random.sample(att_ids, min(num, len(att_ids)))
        for a_id in chosen:
            used.add((d_id, a_id))
    for d_id, a_id in used:
        cur.execute("""
            INSERT INTO discipline_attestation (discipline_id, attestation_id)
            VALUES (%s, %s)
            ON CONFLICT DO NOTHING
        """, (d_id, a_id))
    conn.commit()

def populate_graduation_documents():
    cur.execute("SELECT id FROM student")
    student_ids = [r[0] for r in cur.fetchall()]
    cur.execute("SELECT id FROM program")
    prog_ids = [r[0] for r in cur.fetchall()]
    cur.execute("SELECT id FROM document_type")
    doc_type_ids = [r[0] for r in cur.fetchall()]
    used = set()
    for _ in range(N_DOCUMENTS):
        s_id = random.choice(student_ids)
        p_id = random.choice(prog_ids)
        dt_id = random.choice(doc_type_ids)
        used.add((s_id, p_id, dt_id))
    for s_id, p_id, dt_id in used:
        doc_num = random.randint(10000, 99999)
        issue_date = fake.date_between(start_date='-1y', end_date='today')
        cur.execute("""
            INSERT INTO graduation_document (program_id, document_type_id, student_id, doc_number, issue_date)
            VALUES (%s, %s, %s, %s, %s)
            ON CONFLICT DO NOTHING
        """, (p_id, dt_id, s_id, doc_num, issue_date))
    conn.commit()

def populate_group_lesson_teacher():
    cur.execute("SELECT id FROM student_group")
    group_ids = [r[0] for r in cur.fetchall()]
    cur.execute("SELECT id FROM lesson")
    lesson_ids = [r[0] for r in cur.fetchall()]
    cur.execute("SELECT id FROM teacher")
    teacher_ids = [r[0] for r in cur.fetchall()]
    used = set()
    for g_id in group_ids:
        # каждой группе назначаем несколько уроков и преподавателей
        num_lessons = random.randint(LESSONS_PER_GROUP-2, LESSONS_PER_GROUP+5)
        chosen_lessons = random.sample(lesson_ids, min(num_lessons, len(lesson_ids)))
        for l_id in chosen_lessons:
            t_id = random.choice(teacher_ids)
            used.add((g_id, l_id, t_id))
    for g_id, l_id, t_id in used:
        cur.execute("""
            INSERT INTO group_lesson_teacher (group_id, lesson_id, teacher_id)
            VALUES (%s, %s, %s)
            ON CONFLICT DO NOTHING
        """, (g_id, l_id, t_id))
    conn.commit()

# ---------- Основная процедура ----------
try:
    print("Заполнение program_type...")
    populate_program_types()
    print("Заполнение location...")
    populate_locations()
    print("Заполнение lesson_type...")
    populate_lesson_types()
    print("Заполнение document_type...")
    populate_document_types()
    print("Заполнение student...")
    populate_students()
    print("Заполнение teacher...")
    populate_teachers()
    print("Заполнение hours_volume...")
    populate_hours_volumes()
    print("Заполнение discipline...")
    populate_disciplines()
    print("Заполнение program...")
    populate_programs()
    print("Заполнение classroom...")
    populate_classrooms()
    print("Заполнение lesson...")
    populate_lessons()
    print("Заполнение student_group...")
    populate_groups()
    print("Заполнение связей program_discipline...")
    populate_program_discipline()
    print("Заполнение связей teacher_discipline...")
    populate_teacher_discipline()
    print("Заполнение student_in_group...")
    populate_student_in_group()
    print("Заполнение attestation...")
    populate_attestations()
    print("Заполнение discipline_attestation...")
    populate_discipline_attestation()
    print("Заполнение graduation_document...")
    populate_graduation_documents()
    print("Заполнение group_lesson_teacher...")
    populate_group_lesson_teacher()
    print("Все данные успешно сгенерированы.")
except Exception as e:
    print("Ошибка:", e)
    conn.rollback()
finally:
    cur.close()
    conn.close()