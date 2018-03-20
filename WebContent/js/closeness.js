/**
 * 
 */
function closeness(graph, oriented) {
		  var Q = [],
		    S = []; // Queue and Stack
		  // list of predcessors on shorteest paths from source
		  var pred = Object.create(null);
		  // distance from source
		  var dist = Object.create(null);
		  // number of shortest paths from source to key

		  var currentNode;
		  var centrality = Object.create(null);

		  graph.forEachNode(setCentralityToZero);
		  graph.forEachNode(calculateCentrality);

		  return centrality;

		  function setCentralityToZero(node) {
		    centrality[node.id] = 0;
		  }

		  function calculateCentrality(node) {
		    currentNode = node.id;
		    singleSourceShortestPath(currentNode);
		  }


		  function singleSourceShortestPath(source) {
		    graph.forEachNode(initNode);
		    dist[source] = 0;
		    Q.push(source);

		    while (Q.length) {
		      var v = Q.shift();
		      var dedup = Object.create(null);
		      S.push(v);
		      graph.forEachLinkedNode(v, toId);
		    }

		    function toId(otherNode) {
		      // NOTE: This code will also consider multi-edges, which are often
		      // ignored by popular software (Gephi/NetworkX). Depending on your use
		      // case this may not be desired and deduping needs to be performed. To
		      // save memory I'm not deduping here...
		      processNode(otherNode.id);
		    }

		    function initNode(node) {
		      var nodeId = node.id;
		      pred[nodeId] = []; // empty list
		      dist[nodeId] = -1;
		    }

		    function processNode(w) {
		      // path discovery
		      if (dist[w] === -1) {
		        // Node w is found for the first time
		        dist[w] = dist[v] + 1;
		        Q.push(w);
		      }
		      // path counting
		      if (dist[w] === dist[v] + 1) {
		        // edge (v, w) on a shortest path
		        pred[w].push(v);
		      }
		      
		    }
		
			  for (var i = 0; i < Object.keys(dist).length; i++){
				  
		    		centrality[source] = centrality[source] + dist[i];
			  }
			  		
			  	centrality[source] = 1/centrality[source];
		    
		  }
		}