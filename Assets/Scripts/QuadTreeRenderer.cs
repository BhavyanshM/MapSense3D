using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class QuadTreeRenderer : MonoBehaviour 
{
	public LineFactory lineFactory;

	private Vector2 start;
	private Line drawnLine;
	
	static private int l = 4;
	static private float width = 0.005f;

	private Vector2 startLeft = new Vector2(-l,-l);
	private Vector2 endLeft = new Vector2(-l,l);
	private Vector2 startUp = new Vector2(-l,l);
	private Vector2 endUp = new Vector2(l,l);
	private Vector2 startRight = new Vector2(l,l);
	private Vector2 endRight = new Vector2(l,-l);
	private Vector2 startDown = new Vector2(l,-l);
	private Vector2 endDown = new Vector2(-l,-l);

	private QuadTree qt;

	void Start(){
		qt = new QuadTree();
	}

	void Update ()
	{


		drawnLine = lineFactory.GetLine (startLeft, endLeft, width, Color.black);
		drawnLine = lineFactory.GetLine (startUp, endUp, width, Color.black);
		drawnLine = lineFactory.GetLine (startRight, endRight, width, Color.black);
		drawnLine = lineFactory.GetLine (startDown, endDown, width, Color.black);
		
		if(Input.GetMouseButton(0)){
			var mPos = Input.mousePosition;
			int x = (int)((mPos.x - 531)/490f*255f);
			int y = (int)((mPos.y - 61)/490f*255f);
			qtDraw(new Vector2(x,y), new Vector2(0,0), 8f, 8);

		}
		// qtDraw(new Vector2(240,250), new Vector2(0,0), 8f, 8);
		// drawPlus(new Vector2(1,1), 2);
	}

	
	public void drawPlus(Vector2 pos, float size){
		var startV = new Vector2(pos.x,pos.y + size/2);
		var endV = new Vector2(pos.x,pos.y - size/2);
		var startH = new Vector2(pos.x - size/2, pos.y);
		var endH = new Vector2(pos.x + size/2, pos.y);
		lineFactory.GetLine (startV, endV, width, Color.black);
		lineFactory.GetLine (startH, endH, width, Color.black);
	}

	public void qtDraw(Vector2 pt, Vector2 center, float size, int level){
		int x = (int)pt.x;
		int y = (int)pt.y;
		int dx = ((x >> (level - 1)) % 2)*2 - 1;
		int dy = ((y >> (level - 1)) % 2)*2 - 1;
		// Debug.Log("X:" + dx + " Y:" + dy);
		Vector2 newPos = new Vector2(center.x + dx*(size/4), center.y + dy*(size/4));
		drawPlus(center, size);
		if(level>0){
			qtDraw(pt, newPos, size/2, level-1);
		}
	}


	public void Clear()
	{
		var activeLines = lineFactory.GetActive ();

		foreach (var line in activeLines) {
			line.gameObject.SetActive(false);
		}
	}
}
