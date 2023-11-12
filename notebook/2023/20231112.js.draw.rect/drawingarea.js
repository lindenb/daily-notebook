class PopupMenu {
	popupMenu;
	constructor() {
		console.log("ok");
		var self=this;
		this.popupMenu = document.createElement("ul");
		this.popupMenu.setAttribute("style","list-style: none; padding: 0; margin: 0; position: absolute; background-color: #f9f9f9; border: 1px solid #ccc; box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.5);");
		}
	addMenu(text,fun) {
		var self=this;
		var li = document.createElement("li");
		li.setAttribute("style", "padding: 8px; cursor: pointer;");
		var a = document.createElement("a");
		a.setAttribute("href","#");
		li.appendChild(a);
		a.appendChild(document.createTextNode(text));
		a.addEventListener('click', (event) => {
			fun(event);
			self.dispose();
			}, false);
		this.popupMenu.appendChild(li);
		}
	dispose() {
		var p = this.popupMenu.parentNode;
		if(p!=null) p.removeChild(this.popupMenu);
		}
	show(event) {
		console.log("ok show");
		event.preventDefault();
		this.dispose();
		
        var posX = event.clientX;
        var posY = event.clientY;
        this.popupMenu.style.left = posX + "px";
        this.popupMenu.style.top = posY + "px";
        document.body.appendChild(this.popupMenu);
		}
	}

class DrawingArea {
	

	 canvas;
	 width;
	 height;
	 rectangles=[];
	 selected = null;
	 selectedDrag = null;
	 dragSize=3;
	 is_dragging = false;
	 prexX=null;
	 prevY=null;
	 currentNewRect;
	 
	static Drag = class _Drag {
		rect;idx;
		constructor(rect,idx) {
			this.rect = rect;
			this.idx = idx;
			}
		get startAngle() {
			switch(this.idx) {
				case 0: return  0.5 * Math.PI;
				default: return 0;
				}
			}
		get endAngle() {
			switch(this.idx) {
				case 0: return  2.0 * Math.PI;
				default: return  2 * Math.PI;
				}
			}
		get x() {
			return this.getX();
			}
		get y() {
			return this.getY();
			}
		getRadius() {
			return this.rect.owner.dragSize;
			}
		getX() {
			switch(this.idx) {
				case 0: case 3: return this.rect.x;
				default: return this.rect.maxX;
				}
			}
		getY() {
			switch(this.idx) {
				case 0: case 1: return this.rect.y;
				default: return this.rect.maxY;
				}
			}
		containsXY(x,y) {
			var a= x-this.getX();
			var b= y-this.getY();
			return  Math.sqrt( a*a + b*b ) <= this.getRadius();
			}
		equals(other) {
			if(other==null) return false;
			if(this===other) return true;
			return this.rect === other.rect && this.idx === other.idx;
			}
		moveTo(newX,newY) {
			var maxX = this.rect.getMaxX();
			var maxY = this.rect.getMaxY();
			var minX = this.rect.x;
			var minY = this.rect.y;
			switch(this.idx) {
				case 0: {
					minX = newX;
					minY = newY;
					console.log("ok top left");
					break;
					}
				case 1: {
					maxX = newX;
					minY = newY;
					break;
					}
				case 2: {
					maxX = newX;
					maxY = newY;
					break;
					}
				case 3: {
					minX = newX;
					maxY = newY;
					break;
					}
				default:
					console.log("boum?");
				}
			console.log("moveTO1 "+minX+" "+minY+" "+maxX+" "+maxY);
			if(minX <0 || minX > maxX || maxX >= this.rect.owner.width) {
				return false;
				}
			if(minY <0 || minY > maxY || maxY >= this.rect.owner.height) return false;
			console.log("moveTO2");
			this.rect.x = minX;
			this.rect.y = minY;
			this.rect.width = maxX - minX;
			this.rect.height = maxY - minY;
			console.log("moveTO3 "+this.rect.x+" "+minY+" "+maxX+" "+maxY);
			return true;
			}
		}
	static Rectangle = class _Rectangle {
		owner;x;y;width;height;
		constructor(owner,x,y,width,height) {
			this.owner = owner;
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			}
		
		getMaxX() {
			return this.x + this.width ;
			}
		getMaxY() {
			return this.y + this.height;
			}
		
		get maxX() {
			return this.getMaxX();
			}
		get maxY() {
			return this.getMaxY();
			}
		
		containsXY(x,y) {
			if(x < this.x) return false;
			if(x > this.getMaxX()) return false;
			if(y < this.y) return false;
			if(y > this.getMaxY()) return false;
			return true;
			}
		getDrag(i) {
			return new DrawingArea.Drag(this,i);
			}
		getDrags() {
			return [
				this.getDrag(0),
				this.getDrag(1),
				this.getDrag(2),
				this.getDrag(3)
				];
			}
		
		
		moveR(dx,dy) {
			if(this.x + dx <0) return false;
			if(this.maxX + dx >= this.owner.width) return false;
			if(this.y + dy <0) return false;
			if(this.maxY +dy >= this.owner.height) return false;
			this.x += dx;
			this.y += dy;
			return true;
			}
		}
	 
	static create(id,width,height) {
		var area = new DrawingArea();
		var div = document.getElementById(id);
		area.canvas = document.createElement("canvas");
		area.canvas.setAttribute("width",width);
		area.canvas.setAttribute("height",height);
		div.appendChild(area.canvas);
		area.width = width;
		area.height = height;
		var ctx = area.canvas.getContext('2d');
		
		
        ctx.rect(1,1,width-1,height-1);

		ctx.fillStyle = "gray";
		ctx.fill();
        ctx.strokeStyle = "orange";
		ctx.stroke();
				
		area.canvas.addEventListener('mousedown', (event) => {area.mouseDown(event);}, false);
        area.canvas.addEventListener('mouseup', (event) => {area.mouseUp(event);}, false);
        area.canvas.addEventListener('mousemove', (event) => {area.mouseMove(event);}, false);
        window.addEventListener('keydown', (event) => {area.keyDown(event);}, false);
         area.canvas.addEventListener("contextmenu", (e) => {area.showPopupMenu(event); return false;}); 
		area.rectangles.push(new DrawingArea.Rectangle(area,10,10,50,40));
		area.repaint();
		return area;
		}
	repaint() {
		var ctx = this.canvas.getContext('2d');
		ctx.save();
		ctx.beginPath();
        ctx.rect(1,1,this.width-1,this.height-1);
		ctx.fillStyle = "lightgray";
		ctx.fill();
		ctx.restore();
		
		for(var i in this.rectangles) {
			var r = this.rectangles[i];
			ctx.save();
			ctx.beginPath();
			ctx.rect(r.x, r.y, r.width,r.height);
			ctx.fillStyle = "white";
			ctx.fill();
			ctx.lineWidth =  this.selected === r ?"2":"1";
			ctx.strokeStyle = this.selected === r ? "red" : "darkgray";
			ctx.stroke();
			ctx.restore();
			}
		if(this.selected!=null) {
			for(var i =0;i< 4;++i) {
				var d = this.selected.getDrag(i);
				ctx.save();
				ctx.beginPath();
				ctx.lineWidth = 2;
-               //ctx.fillStyle = "white";//(d.equals(this.selectedDrag)?"blue":"red");
				ctx.arc(d.getX(),d.getY(), this.dragSize, d.startAngle, d.endAngle);
				ctx.fill();
				ctx.restore();
				}
			}
		if(this.currentNewRect!=null) {
			var r =this.currentNewRect;
			ctx.save();
			ctx.beginPath();
			ctx.lineWidth = 2;
			ctx.setLineDash([5, 3]);
			ctx.strokeStyle = "black";
			ctx.rect(r.x, r.y, r.width,r.height);
			ctx.stroke();
			ctx.restore();
			}
		
		ctx.save();
		ctx.beginPath();
		ctx.lineWidth = "1";
		ctx.rect(1,1,this.width-1,this.height-1);
        ctx.strokeStyle = "darkgray";
		ctx.stroke();
		ctx.restore();
		}
	findRectangleAtXY(x,y) {
		var found=null;
		for(var i in this.rectangles) {
			var r = this.rectangles[i];
			if(r.containsXY(x,y)) {
				found = r;
				}
			}
		return found;
		}
	
	
	findDragAtXY(x,y) {
		for(var i in this.rectangles) {
			var r = this.rectangles[i];
			for(var i=0;i< 4;++i) {
				var d = r.getDrag(i);
				if(d.containsXY(x,y)) return d;
				}
			}
		return null;
		}
	
	mouseDown(evt) {
		console.log(evt);
		this.prevX =  evt.offsetX;
		this.prevY =  evt.offsetY;
		var newdrag = this.findDragAtXY(this.prevX,this.prevY);
		var newsel = newdrag!=null? newdrag.rect : this.findRectangleAtXY(this.prevX,this.prevY);
		if(newsel==null) {
			this.is_dragging = true;
			this.selected = null;
			this.selectedDrag = null;
			this.canvas.style.cursor="crosshair";
			this.currentNewRect = new DrawingArea.Rectangle(this,this.prevX,this.prevY,1,1);
			this.repaint();
			}
		else {
			this.selected = newsel;
			this.is_dragging = true;
			this.selectedDrag = newdrag;
			console.log(newsel.x+" "+newsel.y+" "+newsel.maxX+" "+newsel.maxY);
			this.canvas.style.cursor="grab";
			this.repaint();
			}
		}
	
	mouseUp(evt) {
		this.canvas.style.cursor="default";
		if(this.currentNewRect!=null) {
			this.rectangles.push(this.currentNewRect);
			this.currentNewRect = null;
			this.repaint();
			}
		this.is_dragging = false;
		}
	
	mouseMove(evt) {
		if(!this.is_dragging) return;
		var dx = evt.offsetX - this.prevX;
		var dy = evt.offsetY - this.prevY;
		this.prevX =  evt.offsetX;
		this.prevY =  evt.offsetY;
		
		if(this.currentNewRect!=null) {
			if( this.prevX > this.currentNewRect.x && this.prevX < this.width && 
				this.prevY > this.currentNewRect.y && this.prevY < this.height) {
				this.currentNewRect.width = this.prevX - this.currentNewRect.x;
				this.currentNewRect.height = this.prevY - this.currentNewRect.y;
				this.repaint();
				}
			}
		else if(this.selectedDrag!=null) {
			if(this.selectedDrag.moveTo(this.prevX,this.prevY)) {
				this.repaint();
				}
			}
		else if(this.selected!=null) {
			if(this.selected.moveR(dx,dy)) {
				this.repaint();
				}
			}
		
		}
	keyDown(evt) {
		switch(evt.keyCode) {
			case 46: //DEL
				{
				if(this.selected!=null) {
					const index = this.rectangles.indexOf(this.selected);
					this.rectangles.splice(index, 1);
					this.selected=null;
					this.repaint();
					}
				break;
				}
			}
		}	
	showPopupMenu(evt) {
		var self=this;
		if(this.selected!=null && this.selected.containsXY( evt.offsetX, evt.offsetY)) {
			const index = self.rectangles.indexOf(this.selected);
			var menu = new PopupMenu();
			menu.addMenu("Remove Item",(evt)=>{
				self.rectangles.splice(index, 1);
				self.selected=null;
				self.repaint();
				});
			menu.addMenu("Move Back",(evt)=>{
				self.rectangles.splice(index, 1);
				self.rectangles.splice(0, 0, self.selected);
				self.repaint();
				});
			menu.addMenu("Move Front",(evt)=>{
				self.rectangles.splice(index, 1);
				self.rectangles.push(self.selected);
				self.repaint();
				});
			
			menu.show(evt);
			}
		this.is_dragging=false;
		this.currentNewRect=null;
		}	
}