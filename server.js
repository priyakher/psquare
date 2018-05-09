var fs = require('fs');
// import wine predictor
const PredictWine= require('./PredictWine.js');


//import the express module
var express = require('express');

//import body-parser
var bodyParser = require('body-parser');

//store the express in a variable 
var app = express();

//configure body-parser for express
app.use(bodyParser.urlencoded({extended:false}));
app.use(bodyParser.json());

//allow express to access our html (index.html) file
// app.get('/index.html', function(req, res) {
//         res.sendFile(__dirname + "/" + "index.html");
//     });

app.use(express.static('sourcehtml'));

//configure body-parser for express
app.use(bodyParser.urlencoded({extended:false}));
app.use(bodyParser.json());


//route the GET request to the specified path, "/user". 
//This sends the user information to the path  
app.post('/result.html', function(req, res){
        
            var response = req.body.chk1 + ' ' + req.body.chk2 + ' ' + req.body.chk3 
            
            console.log(response);
        
        //var result = PredictWine.category("mocha wine red cherri");

        var result = PredictWine.category(response);
        console.log(result);
        var data = fs.readFileSync('./sourcehtml/resultorg.html'); 
        
        var updatedData = data.toString().replace(new RegExp('predictwine1', 'g'), result.likelihoods[0].category); 
        updatedData = updatedData.toString().replace(new RegExp('predictwine2', 'g'), result.likelihoods[1].category);
        updatedData = updatedData.toString().replace(new RegExp('predictwine3', 'g'), result.likelihoods[2].category);
        updatedData = updatedData.toString().replace(new RegExp('predictwine4', 'g'), result.likelihoods[3].category);

        console.log(updatedData); 
        fs.writeFileSync('./sourcehtml/result.html', updatedData);
        console.log('adding file - scrubbedHTML.txt - to catalog');

        // res.sendFile('index2.html')

        res.sendFile('result.html', { root: './sourcehtml/' })
        
        //convert the response in JSON format
        //res.end(JSON.stringify(response));
    });

app.listen(8081, function(){
    console.log('Server running on 8081'); 
});

//Regular Expression Based Implementation
// String.prototype.replaceAll = function(search, replacement) {
//     var target = this;
//     return target.replace(new RegExp(search, 'g'), replacement);
// };

//Split and Join (Functional) Implementation
// String.prototype.replaceAll = function(search, replacement) {
//     var target = this;
//     return target.split(search).join(replacement);
// };