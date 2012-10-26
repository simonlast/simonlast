
var width = window.innerWidth;;
var height = window.innerHeight;
var r = width/6;
var mode = 'm'; //m = menu, c = create, e = explore
var pos = [width/2-width/7,width/2+width/7]

var svg = d3.select("#poet_menu")
        .append("svg:svg")
        .attr("width", width)
        .attr("height", height)
        .attr("left",0)
        .attr("right",0);  



function createNewCircles(){


 svg.append("svg:circle")
       	.attr("class","circle_button")
        .style("stroke", "none")
        .style("fill", "rgb(121,189,154)")
        .style("opacity", "0")
        .style("opacity", ".6")
        .attr("r", r) 
        .attr("cx", pos[0])
        .attr("cy", height/2-50)
        .datum(0) //explore
        //.on("mouseover", fade_in)
        //.on("mouseout", fade_out)
        //.on("onLoad", function(d, i) { return enter_page(pos[0])})
        .on("click", function(d, i) { return minimize(d,i)})
   		

 		  		
   		
  svg.append("svg:circle")
         	.attr("class","circle_button")
        .style("stroke", "none")
        .style("fill", "rgb(59,134,134)")
        .style("opacity", "0")
        .style("opacity", ".6")
        .attr("r", r) 
        .attr("cx", pos[1])
        .attr("cy", height/2-50)
        .datum(1) //create
        .on("click", function(d, i) { return minimize(d,i)})
        //.on("mouseover", fade_in)
        //.on("mouseout", fade_out)
        //.on("onLoad", function(d, i) { return enter_page(pos[1])})
       
       
  svg.append("text")
       .attr("text-anchor", "middle")
       .style("font-size", "70px")
       //.style("user-select", "none")
        .attr("dx", pos[0])
        .attr("dy", height/2-50)
        .style("fill", "rgb(220,220,220)")
       .text("explore")
       .datum(0) //explore
        //.on("mouseover", fade_in)
       	//.on("mouseout", fade_out)
       	.on("click", function(d, i) { return minimize(d,i)})

      svg.append("text")
       .attr("text-anchor", "middle")
       .style("fill", "rgb(220,220,220)")
       .style("font-size", "70px")
        .attr("dx", pos[1])
        .attr("dy", height/2-50)
       .text("create")
       .datum(1) //create
        // .on("mouseover", fade_in)
       	//.on("mouseout", fade_out)
       	.on("click", function(d, i) { return minimize(d,i)})
 
       

  
        
 }
 
 function fade_in(){
 		d3.select(this).transition()
        .duration(250)
        .style("opacity", ".51")
 	
 }
 
 function fade_out(){
 		d3.select(this).transition()
        .duration(250)
        .style("opacity", ".8")
 	
 }
 
function enter_page(cx){
	d3.select(this).transition()
     .duration(250)
     .delay(500)
       .attr("cx", cx)
        .attr("cy", height/2-50);
}
 
 
function animate_in(){
	//if(d3.event == null){
	d3.select(this).transition()
        .duration(250)
        .attr("opacity", ".8")
        .attr("r", 25*2); 
//}
}

function animate_out(){
	//	if(d3.event == null){
	d3.select(this).transition()
        .duration(500)
        .attr("r", 25);
 //              }
}

function minimize(d,i){
	if(mode == 'm'){
		if(d == 0)
			mode = 'e';
		else
			mode = 'c';
	d3.selectAll("circle").transition()
		.duration(500)
		.attr("cx", function(d, i) { if(i == 0){ return pos[0]+width/6  }else{ return pos[1] - width/6}})
        .attr("cy", 0)
        .attr("r", r*.2);
      
    d3.selectAll("text").transition()
		.duration(500)
		.attr("dx", function(d, i) { if(i == 0){ return pos[0]+125  }else{ return pos[1] - 125}})
        .attr("dy", 0)
        .style("opacity", 0)
        .style("font-size", "10px")
        
       if(mode == 'e')
     	 getGraph();
     	else
     	getCreate();
     }else{
     	document.getElementById("input_box").innerHTML = "";
     	svg.selectAll("circle.node").remove();
     	svg.selectAll("text.create").remove();
     	d3.select("#create").html("");
     	mode = 'm';
    	d3.selectAll("circle").transition()
		.duration(500)
		.attr("cx", function(d, i) { if(i == 0){ return pos[0]}else{ return pos[1]}})
        .attr("cy", height/2 - 50)
        .attr("r", r);
        
         d3.selectAll("text").transition()
		.duration(500)
		.attr("dx", function(d, i) { if(i == 0){ return pos[0]}else{ return pos[1]}})
        .attr("dy", height/2 - 50)
        .style("opacity",1)
       .style("font-size", "70px");
    
     }
}

function getGraph(){

var color = d3.scale.category20();

var force = d3.layout.force()
    .charge(-100)
    .linkDistance(150)
    .size([width, height]);


d3.json("data/miserables.json", function(json) {
  force
      .nodes(json.nodes)
      .links(json.links)
      .start();

  var link = svg.selectAll("line.link")
      .data(json.links)
    .enter().append("line")
      .attr("class", "link")
      .style("stroke-width", function(d) { return Math.sqrt(d.value); });

  var node = svg.selectAll("circle.node")
      .data(json.nodes)
    .enter().append("circle")
      .attr("class", "node")
      .attr("r", 25)
      .style("fill", function(d) { if(2*Math.random() < 1){return "rgb(121,189,154)";}else return "rgb(59,134,134)"; })
      .call(force.drag)
      .attr("opacity", ".8")
      .on("mouseover", animate_in)
      .on("mouseout", animate_out);

  node.append("title")
      .text(function(d) { return d.name; });

  force.on("tick", function() {
    link.attr("x1", function(d) { return d.source.x; })
        .attr("y1", function(d) { return d.source.y; })
        .attr("x2", function(d) { return d.target.x; })
        .attr("y2", function(d) { return d.target.y; });

    node.attr("cx", function(d) { return d.x; })
        .attr("cy", function(d) { return d.y; });
  });
});

}

function getCreate(){
	
	/*var create = d3.select("#poet_menu")
		.append("svg:svg")
        .attr("width", width)
        .attr("height", height)
        .attr("left",0)
        .attr("right",0); 
         */
	svg.append("text")
		.attr("class","create")
       .attr("text-anchor", "middle")
       .style("font-size", "70px")
       .style("fill", "rgb(220,220,220)")
        .attr("dx", -1*width)
        .attr("dy", height/4)
        .transition()
		.duration(800)
        .attr("dx", width/2)
        .attr("dy", height/4)   
       .text("'Twas brillig, and the slithy toves"); 
       
      
      	svg.append("text")
      	.attr("class","create")
       .attr("text-anchor", "middle")
       .style("font-size", "70px")
       .style("contenteditable","true")
       .style("fill", "rgb(220,220,220)")
       .attr("dx", -1*width)
        .attr("dy", height/2)
        .transition()
        .delay(250)
		.duration(800)
        .attr("dx", width/2)
        .attr("dy", height/2)
       .text("Did gyre and gimble in the wabe;"); 
       
       
       
 
       	//d3.select("input_box").html("<p>hello</p>")
	    document.getElementById("input_box").innerHTML = "<input type=\"text\" value=\"\">";
}

createNewCircles();
//getGraph();

