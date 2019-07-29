package  
{
	/**
	 * ...
	 * @author mhtsu
	 */
	public class eBullet 
	{
		
		public var x:Number = new Number;
		public var y:Number = new Number;
		public var type:int = new int;
		public var atTime:Array = new Array;//攻撃間隔
		public var att:Array = new Array //攻撃タイプ
		public var attF:int = new int;//攻撃アニメーション位置
		public var attR:Array = new Array; //攻撃角度(度)　攻撃タイプのみの変数
		public var count:int = new int;
		
		/*type一覧表
		 *1=通常
		 *2=可燃性
		 *3=水
		 *4=砲台
		 *以下未定
		*/
		
		public function eBullet(x2:Number = 0, y2:Number = 0, TYPE:int = 1, AT_TIME:Array = null, ATT:Array = null, ATTR:Array = null):void
		{
			x = x2;
			y = y2;
			type = TYPE;
			atTime = AT_TIME;
			att = ATT;
			attR = ATTR;
			attF = 0;
			count = 0;
		};
		
		public function atk(ex:int, ey:int):bullet {
			var R:Number = Math.atan2(ey - (y + 5), ex - (x + 5));
			return new bullet(x + 5, y + 5, 2, Math.cos(R) * 5, Math.sin(R) * 5);
		}
		
		public function check():Boolean {
			return x < 0 || x > 400 || y < 0 || y > 300;
		};
	};

};