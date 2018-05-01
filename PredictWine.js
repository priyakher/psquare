/*
File name: PredictWine.js
Function: Calculates the wine variety based on user input 
*/
var PredictWine={};

module.exports=PredictWine;

PredictWine.category= function(input)
{

const bayes = require('classificator')
const classifier = bayes()
var classifierModel=require('./classifierModel.js');
var fs=require("fs");


var stateJson=classifierModel.classifier;


let revivedClassifier = bayes.fromJson(stateJson);



var result=revivedClassifier.categorize(input);

console.log(result);

return result;

}


