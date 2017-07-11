var express = require('express')
var database = require('./data-base')
var bodyParser = require('body-parser')
var app = express()
app.use(bodyParser.urlencoded({ extended: true}))
app.get('/',(req, res, err) => {
    res.send('Servidor Top')
})

app.post('/', (req,res,err) => {
    var dog = req.body

    if (dog.name && dog.breed) {
      console.log(dog)
      database.insertDog(dog, (err) => {
        if(!err){
          res.status(200).json(dog)
        }else {
          res.status(400).json('Invalid insertion: ' + err)
        }
      })
    }else{
      res.send('invalid dog data')
    }
})

app.get('/dogs', (req,res,err)=> {
  database.getAllDogs((err, rows) =>{
    if(!err){
      res.status(200).json(rows)
    }else{
      res.status(500).json({'erro':'Internal server error'})
    }
  })
})

app.get('/dogs/:dogId',(req,res,err) =>{

  database.getById(req.params.dogId, (err, rows) => {

    if (!err) {

      res.status(200).json(rows)

    }else{
      res.status(500).json('Internal server error: ' + err)
    }
  })
})

app.delete('/dogs/:dogId', (req,res,err)=> {
  var id = req.params.dogId

  database.deleteDog(id, (err) => {
    if (!err) {
      res.status(200).json({id})
    }else{
      res.status(500).json('Internal server error: ' + err)
    }
  })
})

app.put('/dogs/:dogId', (req,res,err) => {
  var newDog = req.body
  var dogId = req.params.dogId
  database.updateDog(dogId,newDog, (err) => {
    if(!err){
      res.status(200).json(newDog)
    }else{
      res.status(400).json('Invalid insertion: ' + err)
    }
  })
})
app.listen(3000)
