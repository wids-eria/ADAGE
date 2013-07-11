$ ->
  version = 3
  data  = [3,7,9,1,4,6,8,2,5]
  
  [pt, pl, pr, pb] = [20, 20, 20, 20]  # padding
  w     = 800 - (pl + pr)
  h     = 300 - (pt + pb)
  max   = d3.max(data)
  
  # Scales
  x  = d3.scale.linear().domain([0, data.length - 1]).range [0, w]
  y  = d3.scale.linear().domain([0, max]).range [h, 0]
  
  # Base vis layer
  vis = d3.select('#chart')
      .style('margin', '20px auto')
      .style('width', "#{w}px")
    .append('svg:svg')
      .attr('width', w + (pl + pr))
      .attr('height', h + pt + pb)
      .attr('class', 'viz')
    .append('svg:g')
      .attr('transform', "translate(#{pl},#{pt})")
 
  # add path layers to their repesctive group
  vis.selectAll('path.line')
    .data([data])
  .enter().append("svg:path")
    .attr "d", d3.svg.line()
      .x((d,i) -> x(i))
      .y(y)
  
  #
  # STEP 2
  #
  return if version < 2 && version != 0

  # Add tick groups
  ticks = vis.selectAll('.ticky')
    .data(y.ticks(7))
  .enter().append('svg:g')
    .attr('transform', (d) -> "translate(0, #{y(d)})")
    .attr('class', 'ticky')
      
  # Add y axis tick marks
  ticks.append('svg:line')
    .attr('y1', 0)
    .attr('y2', 0)
    .attr('x1', 0)
    .attr('x2', w)

  # Add y axis tick labels
  ticks.append('svg:text')
    .text((d) -> d)
    .attr('text-anchor', 'end')
    .attr('dy', 2)
    .attr('dx', -4)
    
  # Add tick groups
  ticks = vis.selectAll('.tickx')
    .data(x.ticks(data.length))
  .enter().append('svg:g')
    .attr('transform', (d, i) -> "translate(#{x(i)}, 0)")
    .attr('class', 'tickx')

  # Add x axis tick marks
  ticks.append('svg:line')
    .attr('y1', h)
    .attr('y2', 0)
    .attr('x1', 0)
    .attr('x2', 0)

  # Add x axis tick labels
  ticks.append('svg:text')
    .text((d, i) -> i)
    .attr('y', h)
    .attr('dy', 15)
    .attr('dx', -2)

  #
  # STEP 3
  #
  return if version < 3 && version != 0
    
  # Add point circles
  vis.selectAll('.point')
    .data(data)
  .enter().append("svg:circle")
    .attr("class", (d, i) -> if d == max then 'point max' else 'point')
    .attr("r", (d, i) -> if d == max then 6 else 4)
    .attr("cx", (d, i) -> x(i))
    .attr("cy", (d) -> y(d))
    .on('mouseover', -> d3.select(this).attr('r', 8))
    .on('mouseout',  -> d3.select(this).attr('r', 4))
    .on('click', (d, i) -> console.log d, i)
