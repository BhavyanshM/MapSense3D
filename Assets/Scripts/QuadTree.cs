using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class QuadTree
{
    private Node root;
    private int depth;


	public class Node{
		public Node[] subnodes;
		public Vector2 position;
		public float size;
		public int data;
		public bool empty;

		public Node(Vector2 pos, float s){
			this.size = s;
			this.position = pos;
		}

	}

    public QuadTree(){
    	this.depth = 8;
    	// this.root = new Node(new Vector2(0,0), 8f);
    	// this.insert(root, new Vector2(34,78));
    }

	public int getMortonIndex(int x, int y){
		int dx = ((x >> (this.depth - 1)) % 2)*2;
		int dy = ((y >> (this.depth - 1)) % 2);
		return dx + dy;
	}


	public void insert(Node p, Vector2 pos){
		// int key = this.getMortonIndex((int)pos.x, (int)pos.y);
		// if(p.subnodes[key] == null){
		// 	p.subnodes[key] = new Node(new Vector2(pos.x + 2, pos.y+2), p.size/2);
		// }
	}

}

