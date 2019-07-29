package  
{
	/**
	 * ...
	 * @author mhtsu
	 */
	public class player 
	{
		public var x:Number = new Number
		public var y:Number = new Number
		public var sx:int = new int
		public var sy:int = new int
		public var pbt:int = new int(10);//連射カウント
		public const cpbt:int = new int(10);//level1,3連射定数
		public const cpbt2:int = 5; //level2,4連射定数
		public var flag:int = new int
		/* flag
		 * 0 =　表示なし
		 * 1 = 表示
		 *　2 = 復活無敵時間
		 *　3 = 死亡
		 */
		public var time:uint = new uint(300);
		public const ctime:uint = new uint(300);
		public var hp:int = new int(3);
		public var energy:Number = 100; 　//エネルギー MAXが100
		public var level:uint = 1; //レベル
		/* level
		 * 1 = まっすぐの通常発射
		 * 2 = 1の連射速度UP ver
		 * 3 = 三方向に発射
		 * 4 = 3の連射速度UP ver
		 * 5 = 改造レベル！！(クリア報酬？？)
		 */
		public var abFlag:Boolean = false; //吸収フラグ
		public const Ctype:int = 3; //銃タイプの数
		public var type:int = 0; //銃タイプ
		/* type一覧表
		 * -1 = 無装備(イベント用？？)
		 * 0 = 機銃(レベルにより変化)
		 * 1 = ボム(画面に一つ)
		 * 2 = 吸収銃()
		 * 3 = 
		 */
		
		public function player(x2:Number = 0, y2:Number = 0, sx2:int = 3, sy2:int = 3, FLAG:int = 1, HP:int = 3):void
		{
			x = x2
			y = y2
			sx = sx2
			sy = sy2
			flag = FLAG
			hp = HP
		}
		
		public function err():void {
			if (x < 0) x = 0
			if (x > 385) x = 385
			if (y < 0) y = 0
			if (y > 285) y = 285
		}
		
		public function reborn():void {
			if (flag == 2 || flag == 0) {
				time--;
			}
		}
		
	}

}