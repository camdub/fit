//= chart

function pluck(array, property) {
  var i, rv = [];
  for(i = 0; i < array.length; ++i)
    rv[i] = array[i][property];
  return rv;
}

var step_data = [
  {
    "dateTime":"2013-07-24",
    "value":"9985"
  },
  {
    "dateTime":"2013-07-25",
    "value":"12943"
  },
  {
    "dateTime":"2013-07-26",
    "value":"5222"
  },
  {
    "dateTime":"2013-07-27",
    "value":"4998"},
  {
    "dateTime":"2013-07-28",
    "value":"1740"
  }
];

var data = {
  labels: [
    "Jul 24", "Jul 25","Jul 26","Jul 27", "Jul 28"
  ],
  datasets: [
    {
      fillColor : "rgba(46, 204, 113, 0.5)",
      strokeColor : "rgba(39, 174, 96,0.5)",
      pointColor : "rgba(39, 174, 96,1)",
      pointStrokeColor : "#fff",
      data: [5.106217, 6.80889, 2.67047, 2.55591, 1.08898]
    }
  ]
};

Zepto(function($) {
  var ctx = $('#steps')[0].getContext('2d');
  new Chart(ctx).Line(data, {
    scaleOverride: true,
    scaleSteps: 5,
    scaleStepWidth: 2,
    scaleStartValue: 0,
  }); 
});
