// Лабораторная работа 6.2. Работа с БД в СУБД MongoDB
// Выполнил: Харьковский Семён, группа К3341


db = db.getSiblingDB("learn");
db.dropDatabase();

function section(title) {
  print("\n" + "=".repeat(78));
  print(title);
  print("=".repeat(78));
}

function show(cursor) {
  cursor.forEach(doc => printjson(doc));
}

// -----------------------------------------------------------------------------
// 2.1.1. Создание БД и вставка документов
// -----------------------------------------------------------------------------
section("2.1.1. Создание БД learn и заполнение коллекции unicorns");

db.unicorns.insertMany([
  {name: "Horny",       loves: ["carrot", "papaya"],              weight: 600, gender: "m", vampires: 63},
  {name: "Aurora",      loves: ["carrot", "grape"],               weight: 450, gender: "f", vampires: 43},
  {name: "Unicrom",     loves: ["energon", "redbull"],            weight: 984, gender: "m", vampires: 182},
  {name: "Roooooodles", loves: ["apple"],                           weight: 575, gender: "m", vampires: 99},
  {name: "Solnara",     loves: ["apple", "carrot", "chocolate"], weight: 550, gender: "f", vampires: 80},
  {name: "Ayna",        loves: ["strawberry", "lemon"],           weight: 733, gender: "f", vampires: 40},
  {name: "Kenny",       loves: ["grape", "lemon"],                weight: 690, gender: "m", vampires: 39},
  {name: "Raleigh",     loves: ["apple", "sugar"],                weight: 421, gender: "m", vampires: 2},
  {name: "Leia",        loves: ["apple", "watermelon"],           weight: 601, gender: "f", vampires: 33},
  {name: "Pilot",       loves: ["apple", "watermelon"],           weight: 650, gender: "m", vampires: 54},
  {name: "Nimue",       loves: ["grape", "carrot"],               weight: 540, gender: "f"}
]);

const dunx = {name: "Dunx", loves: ["grape", "watermelon"], weight: 704, gender: "m", vampires: 165};
db.unicorns.insertOne(dunx);
print("Документов в unicorns: " + db.unicorns.countDocuments({}));
show(db.unicorns.find({}, {_id: 0}).sort({name: 1}));

// -----------------------------------------------------------------------------
// 2.2.1-2.2.3 и 2.1.4. Выборка и проекция
// -----------------------------------------------------------------------------
section("2.2.1. Самцы и самки; сортировка и ограничение");
print("Самцы:");
show(db.unicorns.find({gender: "m"}, {_id: 0}).sort({name: 1}));
print("Первые три самки:");
show(db.unicorns.find({gender: "f"}, {_id: 0}).sort({name: 1}).limit(3));
print("Первая самка, любящая carrot, через findOne:");
printjson(db.unicorns.findOne({gender: "f", loves: "carrot"}, {_id: 0}));
print("Та же выборка через limit(1):");
show(db.unicorns.find({gender: "f", loves: "carrot"}, {_id: 0}).limit(1));

section("2.2.2. Проекция списка самцов без пола и предпочтений");
show(db.unicorns.find({gender: "m"}, {_id: 0, gender: 0, loves: 0}).sort({name: 1}));

section("2.2.3. Обратный порядок добавления");
show(db.unicorns.find({}, {_id: 0, name: 1}).sort({$natural: -1}));

section("2.1.4. Первое предпочтение каждого единорога");
show(db.unicorns.find({}, {_id: 0, name: 1, loves: {$slice: 1}}).sort({name: 1}));

// -----------------------------------------------------------------------------
// 2.3.1-2.3.4. Логические операторы
// -----------------------------------------------------------------------------
section("2.3.1. Самки весом от 500 до 700 кг");
show(db.unicorns.find(
  {gender: "f", weight: {$gte: 500, $lte: 700}},
  {_id: 0}
).sort({weight: 1}));

section("2.3.2. Самцы от 500 кг, предпочитающие grape и lemon");
show(db.unicorns.find(
  {gender: "m", weight: {$gte: 500}, loves: {$all: ["grape", "lemon"]}},
  {_id: 0}
));

section("2.3.3. Единороги без поля vampires");
show(db.unicorns.find({vampires: {$exists: false}}, {_id: 0}));

section("2.3.4. Имена самцов и первое предпочтение");
show(db.unicorns.find(
  {gender: "m"},
  {_id: 0, name: 1, loves: {$slice: 1}}
).sort({name: 1}));

// -----------------------------------------------------------------------------
// 3.1.1. Вложенные объекты
// -----------------------------------------------------------------------------
section("3.1.1. Коллекция towns и запросы к вложенному объекту mayor");
db.towns.insertMany([
  {
    name: "Punxsutawney",
    population: 6200,
    last_census: ISODate("2008-01-31"),
    famous_for: ["Phil the groundhog"],
    mayor: {name: "Jim Wehrle"}
  },
  {
    name: "New York",
    population: 22200000,
    last_census: ISODate("2009-07-31"),
    famous_for: ["Statue of Liberty", "food"],
    mayor: {name: "Michael Bloomberg", party: "I"}
  },
  {
    name: "Portland",
    population: 528000,
    last_census: ISODate("2009-07-20"),
    famous_for: ["beer", "food"],
    mayor: {name: "Sam Adams", party: "D"}
  }
]);
print("Города с независимыми мэрами:");
show(db.towns.find({"mayor.party": "I"}, {_id: 0, name: 1, mayor: 1}));
print("Города с беспартийными мэрами:");
show(db.towns.find({"mayor.party": {$exists: false}}, {_id: 0, name: 1, mayor: 1}));

// -----------------------------------------------------------------------------
// 3.1.2. Функция и курсор
// -----------------------------------------------------------------------------
section("3.1.2. Функция фильтра, курсор, сортировка и forEach");
const maleFilter = () => ({gender: "m"});
const maleCursor = db.unicorns.find(maleFilter(), {_id: 0, name: 1})
  .sort({name: 1})
  .limit(2);
maleCursor.forEach(doc => print(doc.name));

// -----------------------------------------------------------------------------
// 3.2.1-3.2.3. Агрегированные запросы
// -----------------------------------------------------------------------------
section("3.2.1. Число самок весом от 500 до 600 кг");
print(db.unicorns.countDocuments({gender: "f", weight: {$gte: 500, $lte: 600}}));

section("3.2.2. Уникальные предпочтения");
printjson(db.unicorns.distinct("loves").sort());

section("3.2.3. Число единорогов каждого пола");
show(db.unicorns.aggregate([
  {$group: {_id: "$gender", count: {$sum: 1}}},
  {$sort: {_id: 1}}
]));

// -----------------------------------------------------------------------------
// 3.3.1-3.3.7. Изменение данных
// -----------------------------------------------------------------------------
section("3.3.1. Добавление Barny (современная замена save)");
db.unicorns.insertOne({name: "Barny", loves: ["grape"], weight: 340, gender: "m"});
printjson(db.unicorns.findOne({name: "Barny"}, {_id: 0}));

section("3.3.2. Замена данных Ayna");
db.unicorns.updateOne({name: "Ayna"}, {$set: {weight: 800, vampires: 51}});
printjson(db.unicorns.findOne({name: "Ayna"}, {_id: 0}));

section("3.3.3. Добавление redbull в предпочтения Raleigh");
db.unicorns.updateOne({name: "Raleigh"}, {$addToSet: {loves: "redbull"}});
printjson(db.unicorns.findOne({name: "Raleigh"}, {_id: 0}));

section("3.3.4. Увеличение vampires всем самцам на 5");
db.unicorns.updateMany({gender: "m"}, {$inc: {vampires: 5}});
show(db.unicorns.find({gender: "m"}, {_id: 0, name: 1, vampires: 1}).sort({name: 1}));

section("3.3.5. Мэр Portland становится беспартийным");
db.towns.updateOne({name: "Portland"}, {$unset: {"mayor.party": ""}});
printjson(db.towns.findOne({name: "Portland"}, {_id: 0, name: 1, mayor: 1}));

section("3.3.6. Добавление chocolate в предпочтения Pilot");
db.unicorns.updateOne({name: "Pilot"}, {$addToSet: {loves: "chocolate"}});
printjson(db.unicorns.findOne({name: "Pilot"}, {_id: 0}));

section("3.3.7. Добавление sugar и lemon в предпочтения Aurora");
db.unicorns.updateOne(
  {name: "Aurora"},
  {$addToSet: {loves: {$each: ["sugar", "lemon"]}}}
);
printjson(db.unicorns.findOne({name: "Aurora"}, {_id: 0}));

// -----------------------------------------------------------------------------
// 3.4.1. Удаление данных
// -----------------------------------------------------------------------------
section("3.4.1. Удаление городов с беспартийными мэрами и очистка towns");
const deletedTowns = db.towns.deleteMany({"mayor.party": {$exists: false}});
printjson(deletedTowns);
print("Оставшиеся города:");
show(db.towns.find({}, {_id: 0}));
print("Очистка коллекции towns:");
printjson(db.towns.deleteMany({}));
printjson(db.getCollectionNames().sort());

// -----------------------------------------------------------------------------
// 4.1.1. Ссылки
// -----------------------------------------------------------------------------
section("4.1.1. Коллекция зон обитания и DBRef-ссылки");
db.habitats.insertMany([
  {_id: "forest", name: "Лес", description: "Лесная зона с мягким климатом"},
  {_id: "mountains", name: "Горы", description: "Высокогорная зона"},
  {_id: "coast", name: "Побережье", description: "Прибрежная зона"}
]);
db.unicorns.updateOne({name: "Aurora"}, {$set: {habitat: DBRef("habitats", "forest", "learn")}});
db.unicorns.updateOne({name: "Nimue"}, {$set: {habitat: DBRef("habitats", "forest", "learn")}});
db.unicorns.updateOne({name: "Unicrom"}, {$set: {habitat: DBRef("habitats", "mountains", "learn")}});
db.unicorns.updateOne({name: "Leia"}, {$set: {habitat: DBRef("habitats", "coast", "learn")}});
show(db.unicorns.find({habitat: {$exists: true}}, {_id: 0, name: 1, habitat: 1}).sort({name: 1}));
const aurora = db.unicorns.findOne({name: "Aurora"});
print("Разыменование ссылки Aurora:");
printjson(db.getCollection(aurora.habitat.collection).findOne({_id: aurora.habitat.oid}));

// -----------------------------------------------------------------------------
// 4.2.1 и 4.3.1. Индексы
// -----------------------------------------------------------------------------
section("4.2.1. Уникальный индекс по имени единорога");
print(db.unicorns.createIndex({name: 1}, {unique: true, name: "uq_unicorn_name"}));
printjson(db.unicorns.getIndexes());

section("4.3.1. Управление индексами");
print("Индексы до удаления:");
printjson(db.unicorns.getIndexes());
db.unicorns.dropIndexes();
print("После dropIndexes (остаётся _id_):");
printjson(db.unicorns.getIndexes());
print("Попытка удалить обязательный индекс _id_:");
try {
  db.unicorns.dropIndex("_id_");
} catch (error) {
  print("Ожидаемая ошибка: " + error.message);
}

// -----------------------------------------------------------------------------
// 4.4.1. План выполнения запроса
// -----------------------------------------------------------------------------
section("4.4.1. Сравнение плана запроса без индекса и с индексом");
db.numbers.drop();
const batchSize = 1000;
for (let start = 0; start < 100000; start += batchSize) {
  const operations = [];
  for (let value = start; value < start + batchSize; value++) {
    operations.push({insertOne: {document: {value: value}}});
  }
  db.numbers.bulkWrite(operations, {ordered: false});
}

print("Последние четыре документа:");
show(db.numbers.find({value: {$gte: 99996}}, {_id: 0}).sort({value: -1}).limit(4));

const beforeIndex = db.numbers.explain("executionStats")
  .find({value: {$gte: 99996}})
  .sort({value: -1})
  .limit(4)
  .finish();
print("Без индекса:");
printjson({
  winningPlan: beforeIndex.queryPlanner.winningPlan,
  executionTimeMillis: beforeIndex.executionStats.executionTimeMillis,
  totalDocsExamined: beforeIndex.executionStats.totalDocsExamined,
  totalKeysExamined: beforeIndex.executionStats.totalKeysExamined,
  nReturned: beforeIndex.executionStats.nReturned
});

print(db.numbers.createIndex({value: 1}, {name: "ix_numbers_value"}));
printjson(db.numbers.getIndexes());

const afterIndex = db.numbers.explain("executionStats")
  .find({value: {$gte: 99996}})
  .sort({value: -1})
  .limit(4)
  .finish();
print("С индексом:");
printjson({
  winningPlan: afterIndex.queryPlanner.winningPlan,
  executionTimeMillis: afterIndex.executionStats.executionTimeMillis,
  totalDocsExamined: afterIndex.executionStats.totalDocsExamined,
  totalKeysExamined: afterIndex.executionStats.totalKeysExamined,
  nReturned: afterIndex.executionStats.nReturned
});

print("\nЛабораторная работа 6.2 выполнена. База: " + db.getName());
printjson(db.getCollectionNames().sort());
