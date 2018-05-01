/*
File name: BayesModel.js
Function: generates naive bayes model using training data.
*/
const bayes = require('classificator')
const classifier = bayes()
const ConfusionMatrix = require('ml-confusion-matrix');
var test = require('./testData.js');
var train = require('./trainData.js'); 
var classifierModel=require('./classifierModel.js');
var fs=require("fs");

var trainData=test.testData;
var stateJson=classifierModel.classifier;

  
trainData.forEach(function (ele){

classifier.learn( ele.stemDescription, (ele.variety));

});

let stateJson = classifier.toJson();

//### load the classifier back from its JSON representation.

fs.writeFileSync('classifierModel.js', stateJson, 'utf-8');

