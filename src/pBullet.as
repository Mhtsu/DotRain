package  
{
	/**
	 * ...
	 * @author mhtsu
	 */
	public class pBullet 
	{
		public var x:Number = new Number;
		public var y:Number = new Number;
		public var sx:Number = new Number;
		public var sy:Number = new Number;
		public var visible:Boolean = new Boolean;
		public function pBullet(x2:Number = 0, y2:Number = 0, sx2:Number = 0, sy2:Number = -5)
		{
			x = x2;
			y = y2;
			sx = sx2;
			sy = sy2;
		}
		
		public function check():Boolean {
			var a:Boolean = new Boolean
			a = x < -3 || x > 397 || y < -3 || y > 297
			return a
		};
	}

}