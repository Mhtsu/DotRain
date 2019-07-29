package  
{
	/**
	 * ...
	 * @author mhtsu
	 */
	public class Bomb
	{
		public var x:int = new int
		public var y:int = new int
		public var flag:int = new int
		/*フラグ
		 * 0=非表示
		 * 1=爆発前
		 * 2=爆発後
		 */
		public function Bomb(x2:int = 0, y2:int = 0, flag2:int = 0)
		{
			x = x2
			y = y2
			flag = flag2
		}
		
		public function check():Boolean {
			return x < 0 || x > 400 || y < 0 || y > 300
		}
		
	}

}