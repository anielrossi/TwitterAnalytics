<meta charset="utf-8">
<%@ page import="twitter4j.TwitterException"%>
<%@ page import="twitter4j.User"%>
<%@ page import="twitter4j.TwitterFactory"%>
<%@ page import="twitter4j.Twitter"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="org.json.simple.*"%>

<%! @SuppressWarnings("unchecked") %>

<%	
	//riempimento di obj con me in prima posizione e a seguire i miei followers e i followers dei followers in ordine di selezione
	int i = 0; //viene dichiarata globale perchè serve a riempire tutta la lista di nodi del grafo
	int z = 0;
	int bool = 0; //booleano per verificare se un utente è in comune
	List<List<User>> fofList = (ArrayList<List<User>>) request.getSession().getAttribute("fofList");
	String[] checkedUsers =(String[]) request.getSession().getAttribute("checkedUsers");
	User loggedUser = (User) request.getSession().getAttribute("loggedUser");
	List<User> myFollowers = (ArrayList<User>) request.getSession().getAttribute("myFollowers");

	JSONObject obj = new JSONObject();	//oggetto JSON contenente nodi e link
	JSONArray nodes = new JSONArray();
	JSONArray links = new JSONArray();
	JSONObject me = new JSONObject();
	// JSONArray followersNodes = new JSONArray();

	me.put("name", loggedUser.getScreenName());
	me.put("group", "1");
	me.put("picture", loggedUser.getProfileImageURL());
	nodes.add(0, me);
	for(i=0; i< myFollowers.size(); i++){
		JSONObject person = new JSONObject();
		person.put("name", myFollowers.get(i).getScreenName());
		person.put("group","1");
		person.put("picture", myFollowers.get(i).getProfileImageURL());
		nodes.add(i+1, person);
	
		JSONObject edge = new JSONObject();
		edge.put("source", i+1);
		edge.put("target", 0);
		edge.put("value", 1);
		edge.put("exists", 0);
		links.add(i, edge);
	}
	z = i;	//mi posizione con un cursore in fondo alla lista temporanea di nodi (che ora contiene solo me e i miei followers)
	for(int k=0; k< myFollowers.size() ; k++){
		for(int y=0; y < checkedUsers.length; y++){
			if(checkedUsers[y].equals(myFollowers.get(k).getScreenName())){
				for(int x=0; x < fofList.get(y).size(); x++){
					bool = 0;
					for (int a = 0; a < nodes.size(); a++){
						//controllo se è già presente
						String s = nodes.get(a).toString();
						Object o = JSONValue.parse(s);
						JSONObject pers = (JSONObject)o;
							//se è già esistente
							if (pers.get("name").toString().equals(fofList.get(y).get(x).getScreenName())){
								JSONObject edge = new JSONObject();
								z++;
							
								edge.put("source", a);
								edge.put("target", k+1);
								edge.put("value", 1);
								edge.put("exists", 1);
								links.add(z-1, edge);  
								bool = 1;
								}
							}
							//se non esiste inserisco sia nodo che link
							if (bool == 0){
								i++;
								z++;
								
								JSONObject person = new JSONObject();
								person.put("name", fofList.get(y).get(x).getScreenName());
								person.put("group",k+2);
								person.put("picture",fofList.get(y).get(x).getProfileImageURL());
								nodes.add(i, person);
								
								JSONObject edge = new JSONObject();
								edge.put("source", i);
								edge.put("target", k+1);
								edge.put("value", 1);
								edge.put("exists", 0);
								links.add(z-1, edge);	
								} 
							bool = 0;	
							}	
						}
					}
	}	
	obj.put("nodes", nodes);
	obj.put("links", links);

%>

<head>
	<!-- JQuery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
	<script src="http://vast-engineering.github.io/jquery-popup-overlay/jquery.popupoverlay.js"></script>

	<!-- Js -->
	<script type="text/javascript" src="../js/vivagraph.js"></script>
	<script type="text/javascript" src="../js/centrality.js"></script>
	<script type="text/javascript" src="../js/closeness.js"></script>
	<script type="text/javascript" src="../js/operations.js"></script>
	<script type="text/javascript" src="../js/bPopup.js"></script>
	<link type="text/css" rel="stylesheet" href="../css/materialize.min.css"  media="screen,projection"/>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.96.1/js/materialize.min.js"></script>
	

	<!-- CSS -->

	<link rel="stylesheet" href="../css/bootstrap.css">
    <link rel="stylesheet" href="../css/bootstrap.min.css">
	<link rel="stylesheet" href="../css/style.css" type="text/css">
    <link rel="stylesheet" href="../css/materialize.min.css">


    
	<meta name="viewport" content="width=device-width, initial-scale=1">
 	<style type="text/css" media="screen">
       html, body, svg { width: 100%; height: 100%;} 
 	</style>

</head>
<body>
	<div class="page-header">
  		<h1 class="text-center title">Network of friendship</h1>
  		<div id="buttons">
  		<a class="btn btn-warning" href="redirect.jsp"> Back to your profile </a>
  		<a class="btn btn-warning" href="followers.jsp"> Back to your followers </a>
  		<a class="btn btn-warning" href="followersoffollowers.jsp"> Back to the hierarchy </a>
  		</div>
	</div>
	<div id="graph">
		<script type="text/javascript" src="../js/materialize.min.js"></script>
		<script type="text/javascript">

			//assegnamento dell'oggetto JSON al grafico
			var objString = JSON.stringify(<%=obj%>, null, 4);
			var graph = JSON.parse(objString);
			var i;
			var j;
			var graphViva = Viva.Graph.graph();
 
			for (i = 0; i < graph.nodes.length; i++){
				graphViva.addNode(i, {name : graph.nodes[i].name, picture : graph.nodes[i].picture});
			}
 
			for (i = 0; i < graph.links.length; i++){
				graphViva.addLink(graph.links[i].source, graph.links[i].target, graph.links[i].exists);
			}


			//Drawing	
    		var graphics = Viva.Graph.View.svgGraphics(),
            nodeSize = 24,
            // we use this method to highlight all realted links
            // when user hovers mouse over a node:
            highlightRelatedNodes = function(nodeId, isOn) {
            // just enumerate all realted nodes and update link color:
            	graphViva.forEachLinkedNode(nodeId, function(node, link){
            	var linkUI = graphics.getLinkUI(link.id);
            		if (linkUI) {
                		// linkUI is a UI object created by graphics below
                    	linkUI.attr('stroke', isOn ? '#00FFCC' : 'gray');
                	}
            	});
            };
	 		graphics.node(function(node) {
	 			
	        	var ui= Viva.Graph.svg('image')
	              	.attr('width', 20)
	              	.attr('height', 20)
	              	.link(node.data.picture); 
	        
	        	ui.append('title').text(node.data.name);

	         	$(ui).click(function() {
	         		var n = graph.nodes.length;
		    	  	var closeness1 = closViva[node.id].value;
		    	  	document.getElementById("clos").innerHTML = closeness1;
		    	 	var betweenness1 = bet[node.id].value;
		    	  	document.getElementById("bet").innerHTML = betweenness1;
		    	  	var degreeness1 = deg[node.id].value;
		    	  	document.getElementById("deg").innerHTML = degreeness1;
		    	  
		    	  	var closenessN = (closViva[node.id].value * (n-1));
		    	  	document.getElementById("closN").innerHTML = closenessN;
		    	  	var betweennessN = (bet[node.id].value/(n-1));
		    	  	document.getElementById("betN").innerHTML = betweennessN;
		    	  	var degreenessN = (deg[node.id].value/(n-1));
		    	  	document.getElementById("degN").innerHTML = degreenessN;
		    	  
		    	  	var name = graph.nodes[node.id].name;
		    	  	document.getElementById("name").innerHTML =name;
		    	  	var pic = graph.nodes[node.id].picture;
		    	  	document.getElementById("pic").src = pic;
		    	  
		    	
		    	  	$("#my_popup").bPopup({
		    	  		modalClose: true,
		    	  	    opacity: 0.6,
		    	  	    positionStyle: 'fixed', //'fixed' or 'absolute'
		    	  	    modalColor: '#3598ae',
		    	  	    speed: 450,
		    	        transition: 'slideDown'
		    	    });	

		      	});
	
	      		$(ui).hover(function() { // mouse over
                    highlightRelatedNodes(node.id, true);
                	}, function() { // mouse out
                    	highlightRelatedNodes(node.id, false);
                		});
                return ui;
            }).placeNode(function(nodeUI, pos){
	    	 	nodeUI.attr('x', pos.x - nodeSize / 2).attr('y', pos.y - nodeSize / 2);
	     		});
	 
	 		graphics.link(function(link){
		 		var dualLink = (link.data === 1),
         			ui = Viva.Graph.svg('path')
                	.attr('stroke', dualLink ? 'black' : 'gray')
                	.attr('fill', 'none');
     			ui.dualLink = dualLink; // remember for future.
     			return ui;
     		}).placeLink(function(linkUI, fromPos, toPos) {
    	 			var ry = linkUI.dualLink ? 10 : 0,
    		 		data = 'M' + fromPos.x + ',' + fromPos.y + ' A 10,' + ry + ',-30,0,1,' + toPos.x + ',' + toPos.y;
         			linkUI.attr("d", data);
     			})
	 		var renderer = Viva.Graph.View.renderer(graphViva,{
	 			graphics : graphics
	     					});
	 		renderer.run();
	 
			//End drawing	 

	 		var calculator = Viva.Graph.centrality();
	 		var bet = calculator.betweennessCentrality(graphViva, false);
	 		var deg = calculator.degreeCentrality(graphViva, "in");
	 		var clos = closeness(graphViva);
	 		var closViva = toVivaGraphCentralityFormat(clos);

		</script>
	</div>
	<div id="my_popup" class="card-panel blue-grey lighten-5">
	 	<table class="bordered">
        	<tbody>
          		<tr>
            		<td class = "col">Username:</td>
            		<td id = "name"></td>
          		</tr>
          		<tr>
            		<td class = "col">Profile Picture</td>
            		<td id = "img"><img id = "pic" src = "" height="42" width="42"></td>
          		</tr>
          		<tr>
            		<td class = "col">Degreeness Centrality</td>
            		<td id = "deg"></td>
          		</tr>
          		<tr>
            		<td class = "col">Normalized Degreenes Centrality</td>
            		<td id = "degN"></td>
          		</tr>
          		<tr>
            		<td class = "col">Betweenness Centrality</td>
            		<td id = "bet"></td>
          		</tr>
          		<tr>
            		<td class = "col">Normalized Betweenness Centrality</td>
            			<td id = "betN"></td>
          		</tr>
          		<tr>
            		<td class = "col">Closeness Centrality</td>
            		<td id = "clos"></td>
          		</tr>
          		<tr>
            		<td class = "col">Normalized Closeness Centrality</td>
            		<td id = "closN"></td>
          		</tr>
        	</tbody>
      	</table>
	</div>
	
</body>