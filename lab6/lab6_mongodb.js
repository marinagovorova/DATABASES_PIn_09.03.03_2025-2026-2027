use learn

db.unicorns.drop();
db.unicorns.insertMany([
  {name:'Horny', loves:['carrot','papaya'], weight:600, gender:'m', vampires:63},
  {name:'Aurora', loves:['carrot','grape'], weight:450, gender:'f', vampires:43},
  {name:'Unicrom', loves:['energon','redbull'], weight:984, gender:'m', vampires:182},
  {name:'Roooooodles', loves:['apple'], weight:575, gender:'m', vampires:99},
  {name:'Solnara', loves:['apple','carrot','chocolate'], weight:550, gender:'f', vampires:80},
  {name:'Ayna', loves:['strawberry','lemon'], weight:733, gender:'f', vampires:40},
  {name:'Kenny', loves:['grape','lemon'], weight:690, gender:'m', vampires:39},
  {name:'Raleigh', loves:['apple','sugar'], weight:421, gender:'m', vampires:2},
  {name:'Leia', loves:['apple','watermelon'], weight:601, gender:'f', vampires:33},
  {name:'Pilot', loves:['apple','watermelon'], weight:650, gender:'m', vampires:54},
  {name:'Nimue', loves:['grape','carrot'], weight:540, gender:'f'},
  {name:'Dunx', loves:['grape','watermelon'], weight:704, gender:'m', vampires:165}
]);

// 2.2 and 2.3
db.unicorns.find({gender:'m'}).sort({name:1});
db.unicorns.find({gender:'f'}).sort({name:1}).limit(3);
db.unicorns.findOne({gender:'f', loves:'carrot'});
db.unicorns.find({gender:'f', loves:'carrot'}).limit(1);
db.unicorns.find({gender:'m'}, {_id:0, loves:0, gender:0}).sort({name:1});
db.unicorns.find({}, {_id:0}).sort({$natural:-1});
db.unicorns.find({}, {_id:0, name:1, loves:{$slice:1}});
db.unicorns.find({gender:'f', weight:{$gte:500,$lte:700}}, {_id:0});
db.unicorns.find({gender:'m', weight:{$gte:500}, loves:{$all:['grape','lemon']}}, {_id:0});
db.unicorns.find({vampires:{$exists:false}}, {_id:0});
db.unicorns.find({gender:'m'}, {_id:0, name:1, loves:{$slice:1}}).sort({name:1});

// towns
db.towns.drop();
db.towns.insertMany([
  {name:'Punxsutawney', population:6200, last_census:ISODate('2008-01-31'), famous_for:['phil the groundhog'], mayor:{name:'Jim Wehrle'}},
  {name:'New York', population:22200000, last_census:ISODate('2009-07-31'), famous_for:['status of liberty','food'], mayor:{name:'Michael Bloomberg', party:'I'}},
  {name:'Portland', population:528000, last_census:ISODate('2009-07-20'), famous_for:['beer','food'], mayor:{name:'Sam Adams', party:'D'}}
]);
db.towns.find({'mayor.party':'I'}, {_id:0, name:1, mayor:1});
db.towns.find({'mayor.party':{$exists:false}}, {_id:0, name:1, mayor:1});

function getMaleUnicorns(){ return db.unicorns.find({gender:'m'}, {_id:0, name:1}).sort({name:1}); }
var cursor = getMaleUnicorns().limit(2); cursor.forEach(function(u){ print(u.name); });

db.unicorns.countDocuments({gender:'f', weight:{$gte:500,$lte:600}});
db.unicorns.distinct('loves').sort();
db.unicorns.aggregate([{$group:{_id:'$gender', count:{$sum:1}}}, {$sort:{_id:1}}]);

db.unicorns.updateOne({name:'Ayna'}, {$set:{weight:800, vampires:51}});
db.unicorns.updateMany({gender:'m'}, {$inc:{vampires:5}});
db.towns.updateOne({name:'Portland'}, {$unset:{'mayor.party':''}});
db.unicorns.updateOne({name:'Pilot'}, {$push:{loves:'chocolate'}});
db.unicorns.updateOne({name:'Aurora'}, {$addToSet:{loves:{$each:['sugar','lemon']}}});

db.towns.deleteMany({'mayor.party':{$exists:false}});
db.towns.deleteMany({});

// links
db.habitats.drop();
db.habitats.insertMany([
  {_id:'forest', name:'Лесная зона', description:'Лесные территории'},
  {_id:'mountain', name:'Горная зона', description:'Горные пастбища'},
  {_id:'lake', name:'Приозерная зона', description:'Берега водоемов'}
]);
db.unicorns.updateOne({name:'Horny'}, {$set:{habitat:{$ref:'habitats',$id:'forest'}}});
db.unicorns.updateOne({name:'Aurora'}, {$set:{habitat:{$ref:'habitats',$id:'lake'}}});
db.unicorns.updateOne({name:'Unicrom'}, {$set:{habitat:{$ref:'habitats',$id:'mountain'}}});

// indexes and explain
db.unicorns.createIndex({name:1});
db.unicorns.createIndex({gender:1, weight:-1});
db.unicorns.getIndexes();
db.unicorns.dropIndexes();
try { db.unicorns.dropIndex('_id_'); } catch (e) { print(e.message); }

db.numbers.drop();
for(let i = 0; i < 100000; i++){ db.numbers.insertOne({value:i}); }
db.numbers.find({}, {_id:0}).sort({value:-1}).limit(4);
db.numbers.find().sort({value:-1}).limit(4).explain('executionStats');
db.numbers.createIndex({value:1});
db.numbers.getIndexes();
db.numbers.find().sort({value:-1}).limit(4).explain('executionStats');

try {
  db.unicorns.dropIndex("name_1");
} catch(e) {
  print("Индекс name_1 отсутствовал, продолжаем");
}

db.unicorns.createIndex({name:1}, {unique:true});

db.unicorns.getIndexes();

try {
  db.unicorns.insertOne({
    name:"Horny",
    loves:["apple"],
    weight:500,
    gender:"m",
    vampires:10
  });
} catch(e) {
  print("Ошибка уникального индекса:");
  print(e.message);
}
