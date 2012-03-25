$.fn.spin = function(opts) { //allows jquery for spinner
  this.each(function() {
    var $this = $(this),
        data = $this.data();

    if (data.spinner) {
      data.spinner.stop();
      delete data.spinner;
    }
    if (opts !== false) {
      data.spinner = new Spinner($.extend({color: $this.css('color')}, opts)).spin(this);
    }
  });
  return this;
};

var bigSpinner = {
  lines: 12,
  length: 20, 
  width: 6, 
  radius: 27, 
  color: '#fff', 
  speed: 1,
  trail: 60, 
  shadow: true 
};

var smallSpinner = {
  lines: 12, 
  length: 7, 
  width: 4,
  radius: 10,
  color: '#fff', 
  speed: 1, 
  trail: 60, 
  shadow: false
};

var minnerSpinner = {
  lines: 10, 
  length: 3, 
  width: 2,
  radius: 5,
  color: '#fff', 
  speed: 1, 
  trail: 60, 
  shadow: false
};