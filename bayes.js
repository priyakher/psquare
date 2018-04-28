
const bayes = require('classificator')
const classifier = bayes()
const ConfusionMatrix = require('ml-confusion-matrix');
var test = require('./testData.js');
var train = require('./trainData.js'); 

var trainData=test.testData;
var testData=train.trainData;

    
trainData.forEach(function (ele){

classifier.learn( ele.stemDescription, (ele.variety));

});




console.log(classifier.categorize("red mocha cherri "));



var trueValues=[];
var predictedValues=[];
var i=0;
testData.forEach(function(ele){

trueValues[i]=ele.variety;

predictedValues[i]=classifier.categorize(ele.stemDescription).predictedCategory;

for ( var j=0; j<4; j++)
{

if (trueValues[i] == (classifier.categorize(ele.stemDescription).likelihoods[j].category))

predictedValues[i]=(classifier.categorize(ele.stemDescription).likelihoods[j].category);
}

i++;
})
const CM2 = ConfusionMatrix.fromLabels(trueValues, predictedValues);
console.log(CM2.getAccuracy()); 



