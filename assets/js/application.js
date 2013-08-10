//= require moment
//= require chart

// Attempt to load TypeKit
try{Typekit.load();}catch(e){}

Array.prototype.pluck = function(property) {
  var i, rv = [];
  for(i = 0; i < this.length; ++i)
    rv[i] = this[i][property];
  return rv;
};

var dayStrings = [
  'Sun',
  'Mon',
  'Tues',
  'Wed',
  'Thurs',
  'Fri',
  'Sat'
];

var dayLabels = [];
var distance = JSON.parse(gon.distance);
var caloriesIn = JSON.parse(gon.caloriesIn);

distance.pluck('dateTime').forEach(function(date, index, arr) {
  if(index === arr.length - 1)
    dayLabels.push("Today");
  else
    dayLabels.push(dayStrings[moment(date).days()]);
});

var dataDistance = {
  labels: dayLabels,
  datasets: [
    {
      fillColor : "rgba(46, 204, 113, 0.025)",
      strokeColor : "rgba(39, 174, 96,0.7)",
      pointColor : "rgba(39, 174, 96,1)",
      pointStrokeColor : "#fff",
      data: distance.pluck('value')
    }
  ]
};

var dataCalories = {
  labels: dayLabels,
  datasets: [
    {
      fillColor: "rgba(238, 104, 93, 0.025)",
      strokeColor: "rgba(238, 104, 93, 1.0)",
      data: caloriesIn.pluck('value')
    }
  ]
};

Zepto(function($) {
  var distanceCtx = $('#steps')[0].getContext('2d');
  var caloriesInCtx = $('#calories')[0].getContext('2d');

  new Chart(distanceCtx).Line(dataDistance, {
    scaleOverride: true,
    scaleSteps: 5,
    scaleStepWidth: 2,
    scaleStartValue: 0,
    scaleFontFamily : "'camingodos-web'",
    scaleFontSize : 13,
    scaleGridLineColor: "rgba(0,0,0,.025)"
  }); 

  new Chart(caloriesInCtx).Bar(dataCalories, {
    scaleOverride: true,
    scaleSteps: 7,
    scaleStepWidth: 500,
    scaleStartValue: 0,
    scaleFontFamily : "'camingodos-web'",
    scaleFontSize : 13,
    scaleGridLineColor: "rgba(0,0,0,.025)"
  });

  $('.time-ago').html(moment.utc(gon.last_updated).fromNow());
});
