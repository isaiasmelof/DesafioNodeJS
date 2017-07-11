var sqlite3 = require('sqlite3').verbose()
var db = new sqlite3.Database('./db')

db.run('create table if not exists tb_dog (name TEXT, breed Text)', (err) => {
  if(err) {
    console.log('Error creating table ' + err)
  }
})

var insertDog = (dog, callback) => {
  var query = db.prepare('INSERT INTO TB_DOG VALUES (?,?)')
  query.run(dog.name, dog.breed,  callback)
}

var getAllDogs = (callback) => {
  db.all('SELECT rowid AS id, * from tb_dog', callback)
}

var getById = (id, callback) => {
  db.all(`SELECT rowid as id, * FROM TB_DOG WHERE id = ${id}`, callback)
}


var deleteDog = (id, callback) => {
  var query = db.prepare(`DELETE FROM TB_DOG WHERE ROWID = (?)`)
  query.run(id,callback)
}

var updateDog = (id,newDog, callback) => {

   getById(id, (err, rows)=>{
     var dog = rows

     if (newDog.name) {
       dog.name = newDog.name
     }
     if(newDog.breed) {
       dog.breed = newDog.breed
     }
     var query = db.prepare(`UPDATE TB_DOG SET NAME = (?), BREED = (?) WHERE ROWID = (?)`)
     query.run(dog.name, dog.breed, id, callback)
   })
}
module.exports = {

  insertDog,
  getAllDogs,
  getById,
  deleteDog,
  updateDog

}
