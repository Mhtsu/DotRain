package  
{
	/**
	 * ...
	 * @author mhtsu
	 */
	public class enemySet 
	{
		public var visible:Boolean = new Boolean;
		public var start:int = new int;
		public var x:int = new int;//現在のx座標
		public var y:int = new int;//現在のy座標
		public var time:int = new int;//経過時間
		public var xAnim:Vector.<int> = new Vector.<int>//アニメーション座標　相対x
		public var yAnim:Vector.<int> = new Vector.<int>//同上　y
		public var tAnim:Vector.<int> = new Vector.<int>//アニメを開始する相対時刻
		public var cAnim:int = new int;
		public var count:int = new int;
		public var att:Array = new Array//攻撃タイプ
		public var attT:Array = new Array;//攻撃時間
		public var attR:Array = new Array; //攻撃角度
		public var type:Array = new Array;
		public function enemySet(X:int = 0, Y:int = 0)
		{
			x = X;
			y = Y;
			count = 0;
			cAnim = 0;
		}
		
	}

}