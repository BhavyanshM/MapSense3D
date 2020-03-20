using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class QuadTree
{
    private Node root;
    private int depth;

    public QuadTree(){
    	root = new Node();
    }

	private class Node{
		List<Node> subnodes;
		Vector2 position;
		int size;
		int data;

		public Node(){
			
		}

	}

}

