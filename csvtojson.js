const csv=require('csvtojson');
const csvFilePath='wineTrain.csv';
//const csvFilePath='wineTest.csv';
var fs=require("fs");
var data=[];
csv()
.fromFile(csvFilePath)
.on('json',(jsonObj)=>{

	data.push(jsonObj);
    })
.on('done',(error)=>{
     

     var dataJson= JSON.stringify(data, null, 2);
      result= 'var trainData =' + dataJson;
     // result= 'var testData =' + dataJson;

    fs.writeFileSync('trainData.js', result, 'utf-8');


    //fs.writeFileSync('testData.js', result, 'utf-8');


	});