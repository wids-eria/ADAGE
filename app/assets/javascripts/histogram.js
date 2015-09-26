function Histogram(data){
  var self = this;
  self.convert = function(bin){
    if(!self.init && self.bin !=bin){
      var min_num = Math.min.apply(Math,self.data);
      var max_num = Math.max.apply(Math,self.data);

      var w = (max_num - min_num)/bin;

      self.ticks = [];
      self.values = [];

      for(var i=0; i < bin;i++){
        var min = i*w+min_num;
        var max = (i+1)*w+min_num;
        self.values[i] = 0;
        self.ticks[i] = min;
        self.data.forEach(function(score){
          if(score >= min && score <=max){
            self.values[i] += 1;
          }
        });
      }

      self.init = true;
    }
  };

  self.getValues = function(bin){
    self.convert(bin);

    if(self.values[0] !='') self.values.unshift('');
    return self.values;
  };

  self.getLabels = function(bin){
    self.convert(bin);
    if(self.ticks[0] !='x') self.ticks.unshift('x');
    return self.ticks;
  };

  function Histogram(){
    self.data = data;
    self.init = false;
    self.bin = 0;
    self.ticks = [];
    self.values = [];
  };

  return Histogram();
};