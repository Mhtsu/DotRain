package  
{
	/**
	 * ...
	 * @author mhtsu
	 */
	public class bullet 
	{
		public var x:Number = new Number
		public var y:Number = new Number
		public var flag:int = new int
		public var sx:Number = new Number
		public var sy:Number = new Number
		/* フラグ
		 * 0 = 表示なし
		 * 1 = ポイント
		 * 2 = 敵弾
		 * 3 = 爆弾破片
		 * 4 = スタート用
		 * 5 = エネルギー
		 * 6 = 敵弾(小)
		 * 以下未定
		 * 7 = 追尾(なんてね)
		 */
		public function bullet(x2:int = 0, y2:int = 0, flag2:int = 0,sx2:Number = 0,sy2:Number = 0 )
		{
			x = x2
			y = y2
			flag = flag2
			sx = sx2
			sy = sy2
			
		}
		
		public function check(g:int ):Boolean {
			var a:Boolean = new Boolean
			if (g < 0) {
				a = y < 0
			}else if (g > 0) {
				a = y > 300
			}else{
				a = y < 0 || y > 300 || x < 0 || x > 400
			}
			return a
		}
		
	}

}