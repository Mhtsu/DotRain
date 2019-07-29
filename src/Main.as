package 
{
	import flash.accessibility.AccessibilityProperties;
	import flash.desktop.ClipboardFormats;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GraphicsGradientFill;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;
	 
	/**
	 * ...
	 * @author mhtsu
	 * 
	 * 追加済み
	 * ・エネルギーメーター(ok)
	 * ・弾の発射方角指定(ok)
	 * ・吸収能力(武器切り替え機能搭載)(ok)
	 * ・残機表記(随所表示)(ok)
	 * ・スコア表示を小さくする(ok)
	 * ・背景(とりあえずなしで)
	 * ・コンボ表示(画面が見えづらくなるので中止)
	 * ・追尾弾(時間不足で追加断念)
	 * ・リザルト画面はキーボードで進む(ok)
	 * ・隠し要素
	 * 		銃レベル5(クリア後追加)(ok)
	 * ・難易度は変更はできないが、少し難しい難易度にします(RANK S は超難しい)
	 * ・ステージごとのスコアランク設定可能に(txtファイルから)(ok)
	 * ・アニメーション１フレーム遅れバグ修正(現在よくわかってない)
	 * ・アニメーション、ラベルまでループ処理(クリアフレームの存在により必要じゃないかも)
	 * ------------------------------------------
	 * 
	 * 今後追加したいこと
	 * 
	 * ・ステージは8構成
	 * ・残機終了したらそのステージのはじめから、そして残機は3になる。
	 * ・ショップ画面(ステージクリアごと)
	 * 		集めたドットでいろんなものを買っていく方式
	 * 		買える要素は、銃のレベルアップ・残機(高級)・エネルギーの最大値増加　等..
	 * ・隠し要素
	 * 		別機体画像 等..
	 * ・エネルギー表示位置改良
	 * ・武器の切り替えわかりやすく
	 * ・ポーズ画面
	 * 
	 */
	public class Main extends Sprite 
	{
		
		private var eBullets:Array = new Array //敵弾(体)の位置情報
		private var pBullets:Vector.<pBullet> = new Vector.<pBullet>
		private var bullets:Vector.<bullet> = new Vector.<bullet> //弾(ドット)
		private var bulletImg:Vector.<BitmapData> = new Vector.<BitmapData>(100, false); //ドット以外の絵(敵弾等)
		private var bBullets:Vector.<Bomb> = new Vector.<Bomb> //爆弾(四角)
		private var frame:uint = new uint;
		private var bd:BitmapData //背景
		private var eBulletImg:Vector.<BitmapData> = new Vector.<BitmapData>(100, false); //四角
		private var p1:player = new player(193,200)
		private var playerImg:BitmapData = new BitmapData(15,15);
		[Embed(source = "../lib/p.png")] private const img1:Class;
		private var key:Vector.<Boolean> = new Vector.<Boolean>(255, true);
		private var keyT:Vector.<int> = new Vector.<int>(255, true);
		private var txt:TextField = new TextField
		private var start:int = new int
		private var end:int = new int
		private var score:int = new int
		private var a:Vector.<int> = new Vector.<int>(10000,false)
		private var b:Vector.<int> = new Vector.<int>(10000,false)
		private var c:Vector.<int> = new Vector.<int>(10000, false)
		private var d:Vector.<int> = new Vector.<int>(500, false)//赤玉
		private var gv:int = new int(2)//重力
		private var game:uint = new uint(0)		//ゲームフラグ
		private var pCirS:uint = new uint(30)	//吸収範囲
		private var CpCirS:uint = new uint(30)	//吸収範囲　定数
		private var zanzou:Boolean = new Boolean(true)
		private var gTxt:TextField = new TextField;			//ゲームテキスト
		private var gTxtformat:TextFormat = new TextFormat;	//ゲームテキストのフォーマット
		private var HPtxt:TextField = new TextField; 		//残機表示
		private var HPtxtF:TextFormat = new TextFormat; 	//テキストフォーマット
		private var stageNum:int = new int(1);	//現在のステージ番号
		private var stageLast:int = new int(1);	//最終ステージ番号
		
		private var rank:Vector.<int> = new Vector.<int>(4, true);
		private var enemy:Vector.<enemySet> = new Vector.<enemySet>
		private var stageD:Vector.<stageSet> = new Vector.<stageSet>;	//(未使用)
		[Embed(source = "../lib/STAGE0.txt", mimeType = "application/octet-stream")]private static var txt0:Class;
		[Embed(source = "../lib/STAGE1.txt", mimeType = "application/octet-stream")]private static var txt1:Class;
		
		
		private var mTxt1:TextField = new TextField//初期画面
		private var mTxt2:TextField = new TextField;//説明
		[Embed(source = "../lib/menu.png")] private const img2:Class;
		private var menuImg:Bitmap = new img2;
		private var selImg:Sprite = new Sprite
		private var sel:int = new int(0)
		private var f:Boolean = new Boolean(false)//長押し止め
		private var f2:Boolean = new Boolean(false)
		private var f3:Boolean = new Boolean(false)
		private var f4:Boolean = new Boolean(false)
		private var f5:Boolean = new Boolean(false)
		private var bf:Boolean = new Boolean(false);	//ボムの長押し止め
		private var mF:int = new int(0);
		private var howto:String = new String;
		private var count:int = new int;
		private var count2:int = new int;
		private var time:int = new int;
		
		//スコア画像
		[Embed(source = "../lib/SCOREs.png")] private const imgs:Class;
		[Embed(source = "../lib/0s.png")] private const nimg0:Class;
		[Embed(source = "../lib/1s.png")] private const nimg1:Class;
		[Embed(source = "../lib/2s.png")] private const nimg2:Class;
		[Embed(source = "../lib/3s.png")] private const nimg3:Class;
		[Embed(source = "../lib/4s.png")] private const nimg4:Class;
		[Embed(source = "../lib/5s.png")] private const nimg5:Class;
		[Embed(source = "../lib/6s.png")] private const nimg6:Class;
		[Embed(source = "../lib/7s.png")] private const nimg7:Class;
		[Embed(source = "../lib/8s.png")] private const nimg8:Class;
		[Embed(source = "../lib/9s.png")] private const nimg9:Class;
		private var scoreImg:BitmapData = new BitmapData(50,10,true,0x0);
		private var numImgB:Vector.<Bitmap> = new Vector.<Bitmap>;
		private var numImg:Vector.<BitmapData> = new Vector.<BitmapData>;
		private var gameCount:int = 0;
		private var clear:uint = 0;	//クリアーのフレーム数
		
		
		//リザルト画面用
		private var resultTxt:TextField = new TextField;
		private var rankTxt:TextField = new TextField;
		private var rankTxtTf:TextFormat = new TextFormat;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown)
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp)
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			
			frame = 0
			
			//背景
			bd = new BitmapData(400, 300, false)
			stage.addChild(new Bitmap(bd))
			
			txt.x = 0
			txt.y = 0
			txt.width = 400
			txt.height = 300
			txt.alpha = 0.4
			txt.backgroundColor = 0x000000
			txt.textColor = 0xFFFFFF
			txt.text = "いｆｊしｄｆじｆｄ"
			txt.visible = false;
			stage.addChild(txt)
			
			//プレイヤー
			var sq2:Bitmap = new img1
			playerImg = new BitmapData(15, 15, true, 0x0)
			playerImg.draw(sq2)
			p1.level = 3;
			sq2 = null;
			
			//敵の弾(体)
			//タイプ１(通常)
			var sq:Sprite = new Sprite
			sq.graphics.lineStyle(1, 0xFFFFFF)
			sq.graphics.beginFill(0x9999FF)
			sq.graphics.drawRect(0,0,10,10)
			sq.graphics.endFill()
			eBulletImg[1] = new BitmapData(10, 10, true, 0x0)
			eBulletImg[1].draw(sq)
			
			//タイプ2(砲台)
			sq = new Sprite
			sq.graphics.lineStyle(1, 0xFFFFFF)
			sq.graphics.beginFill(0xFF9999)
			sq.graphics.drawRect(0,0,10,10)
			sq.graphics.endFill()
			eBulletImg[2] = new BitmapData(10, 10, true, 0x0)
			eBulletImg[2].draw(sq)
			
			//タイプ3(エネルギー箱)
			sq = new Sprite
			sq.graphics.lineStyle(1, 0xFFFFFF)
			sq.graphics.beginFill(0x0000FF)
			sq.graphics.drawRect(0,0,10,10)
			sq.graphics.endFill()
			eBulletImg[3] = new BitmapData(10, 10, true, 0x0)
			eBulletImg[3].draw(sq)
			
			//タイプ4(可燃性)
			sq = new Sprite
			sq.graphics.lineStyle(1, 0xFFFFFF)
			sq.graphics.beginFill(0xFF0000)
			sq.graphics.drawRect(0,0,10,10)
			sq.graphics.endFill()
			eBulletImg[4] = new BitmapData(10, 10, true, 0x0)
			eBulletImg[4].draw(sq)
			
			//敵弾
			//敵弾(小)
			sq = new Sprite
			sq.graphics.lineStyle(1, 0xFF0000)
			sq.graphics.beginFill(0xFFFF99)
			sq.graphics.drawCircle(5, 5, 4);
			sq.graphics.endFill()
			bulletImg[0] = new BitmapData(10, 10, true, 0x0)
			bulletImg[0].draw(sq);
			
			sq = new Sprite;
			sq.graphics.lineStyle(1, 0xFF0000);
			sq.graphics.beginFill(0xFFFF99)
			sq.graphics.drawCircle(3, 3, 2);
			sq.graphics.endFill();
			bulletImg[1] = new BitmapData(6, 6, true, 0x0);
			bulletImg[1].draw(sq);
			
			sq = null
			
			
			
			//敵データ-------------------------------------------------------------------------------------------------------------------
			/*enemy[0] = new enemySet;
			enemy[0].type = [
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1],
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
					[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 1, 1, 4, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
					]
			enemy[0].att = new Array;
			enemy[0].attT = new Array
			enemy[0].att[0] = [1, 1, 1, 0, 0];
			enemy[0].attT[0] = [0, 100, 100, 100, -1];
			enemy[0].att[1] = [1, 1, 1, 0, 0]
			enemy[0].attT[1] = [0, 100, 100, 100, -1];
			
			enemy[0].xAnim = Vector.<int>([0,20,0,-20,0]);
			enemy[0].yAnim = Vector.<int>([20,0,-20,0,0]);
			enemy[0].tAnim = Vector.<int>([100, 100, 100, 100, -2]);
			enemy[0].start = 0;
			//-------------------------------------------------------------------------------------------------------------------------
			*/
			
			/*
			var t:int = new int(0);
			var i3:int = 0;
			for (i3 = 0; i3 < enemy.length; i3++) { //敵準備
				eBullets[i3] = new Array
				for (i = 0; i < enemy[i3].type.length; i++) {
					for (var i2:int = 0; i2 < enemy[i3].type[i].length; i2++) {
						if (enemy[i3].type[i][i2] > 0) {
							if (enemy[i3].type[i][i2] == 4) {	//砲台の時
 								eBullets[i3].push(new eBullet(i2 * 10, i * 10, enemy[i3].type[i][i2], enemy[i3].attT[t], enemy[i3].att[t], enemy[i3].attR[t]));
								t++;
							}else{
								eBullets[i3].push(new eBullet(i2 * 10, i * 10,enemy[i3].type[i][i2]));
							}
						}
					}
				}
			}
			*/
			
			var i:int = new int
			for (i = 0; i < 50; i++) {
				pBullets[i] = new pBullet()//プレイヤー弾(一応)	
			}
			bBullets[0] = new Bomb()//一応
			
			//ゲームテキスト
			gTxtformat.align = TextFormatAlign.CENTER;
			
			gTxt.visible = false;
			gTxt.width = 400
			gTxt.height = 50
			gTxt.mouseEnabled = false
			gTxt.text = "test";
			gTxt.x = 0
			gTxt.y = 300 / 2 - (gTxt.textHeight - 4) 
			gTxt.textColor = 0xFFFFFF
			gTxt.defaultTextFormat = gTxtformat;
			stage.addChild(gTxt)
			
			
			//メニュー
			menuImg.visible = false
			stage.addChild(menuImg)
			
			mTxt1.x = 170
			mTxt1.y = 130
			mTxt1.width = 200
			mTxt1.height = 200
			mTxt1.backgroundColor = 0x000000;
			mTxt1.textColor = 0xFFFFFF
			mTxt1.text = "スタート\nオプション\n説明"
			mTxt1.mouseEnabled = false
			mTxt1.wordWrap = true;
			mTxt1.multiline = true;
			stage.addChild(mTxt1)
			
			//説明
			mTxt2.x = 10;
			mTxt2.y = 10;
			mTxt2.width = 380
			mTxt2.height = 280
			mTxt2.textColor = 0xFFFFFF
			mTxt2.backgroundColor = 0x0000FF;
			mTxt2.background = true
			mTxt2.mouseEnabled = false
			mTxt2.visible = false
			mTxt2.wordWrap = true;
			mTxt2.multiline = true;
			stage.addChild(mTxt2);
			
			selImg.graphics.lineStyle(1, 0xFFFFFF);
			selImg.graphics.beginFill(0x9999FF);
			selImg.graphics.drawRect(0, 0, 10, 10);
			selImg.graphics.endFill();
			selImg.x = 160;
			selImg.y = 135;
			stage.addChild(selImg);
			
			HPtxtF.bold = true;
			HPtxtF.size = 20;
			HPtxtF.color = 0xFFFFFF
			HPtxtF.align = TextFormatAlign.CENTER;
			HPtxt.defaultTextFormat = HPtxtF;
			HPtxt.text = "P=3"
			HPtxt.x = 0;
			HPtxt.y = 300 / 2 - (HPtxt.textHeight - 4) ;
			HPtxt.width = 400;
			HPtxt.height = 50;
			HPtxt.selectable = false;
			HPtxt.alpha = 0;
			
			stage.addChild(HPtxt);
			
			
			howto = "　　　　　　　　　　　　　　                   遊び方\n" +
			"弾や爆弾を発射する機体を操作して未確認飛行物体を排除しよう！\n" +
			"破壊する度にドットが出現するので近づいて回収しよう！\n"　 +
			"\n　　　　　　　　　　　　　　　　　　　　操作方法\n" +
			"十字キー・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・移動\n" +
			"spaceキー・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・機能使用\n" +
			"1キー・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・通常弾モード切り替え\n" +
			"2キー・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・爆弾モード切り替え\n" +
			"3キー・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・吸収モード切り替え\n" +
			"\n                     spaceキーで閉じる\n";
			
			
			//スコア画像セット
			var scoreImgB:Bitmap = new imgs;
			scoreImg.draw(scoreImgB);
			numImgB[0] = new nimg0;
			numImgB[1] = new nimg1;
			numImgB[2] = new nimg2;
			numImgB[3] = new nimg3;
			numImgB[4] = new nimg4;
			numImgB[5] = new nimg5;
			numImgB[6] = new nimg6;
			numImgB[7] = new nimg7;
			numImgB[8] = new nimg8;
			numImgB[9] = new nimg9;
			for (i = 0; i < 10; i++) {
				numImg[i] = new BitmapData(10,10,true,0x0);
				numImg[i].draw(numImgB[i]);
			}
			
			//リザルト画面関連
			resultTxt.visible = false;
			resultTxt.selectable = false;
			resultTxt.x = 20;
			resultTxt.y = 20;
			resultTxt.textColor = 0xFFFFFF;
			resultTxt.background = true;
			resultTxt.backgroundColor = 0x9999FF;
			resultTxt.width = 200;
			resultTxt.height = 260;
			stage.addChild(resultTxt);
			
			rankTxtTf.bold = true;
			rankTxtTf.color = 0xFFFFFF;
			rankTxtTf.size = 50;
			rankTxt.visible = false;
			rankTxt.defaultTextFormat = rankTxtTf;
			rankTxt.selectable = false;
			rankTxt.x = 250;
			rankTxt.y = 50;
			rankTxt.textColor = 0xFFFFFF;
			rankTxt.width = 120;
			rankTxt.height = 180;
			stage.addChild(rankTxt);
			
			loadStage(stageNum);	//第一ステージ読み込み
		}
		private function onEnterFrame(e:Event):void {
			start = getTimer();
			if (frame++ % 1 == 0){
				if (game == 0) {	//メニュー画面
					menu()
				}else if (game == 1) {	//ゲームスタート
					time++
					
					if (!zanzou){
						bd.fillRect(bd.rect, 0x000000); //塗りつぶし
					}else{
						bd.colorTransform(bd.rect, new ColorTransform(1, 1, 1, 1, -50, -50, -50));
					}
					
					if (time < 50) {//スタート
						gTxt.text = "STAGE" + stageNum;
						gTxt.visible = true;
						bd.copyPixels(playerImg, playerImg.rect, new Point(p1.x, p1.y));
						bd.colorTransform(bd.rect, new ColorTransform(1,1,1,1,-(255-(100/255*time)),-(255-(255/100*time)),-(255-(255/100*time))))
						
					}else if (time < 100) {
						gTxt.text = "START"
						bd.copyPixels(playerImg, playerImg.rect, new Point(p1.x, p1.y));
						bd.colorTransform(bd.rect, new ColorTransform(1,1,1,1,-(255-(100/255*time)),-(255-(255/100*time)),-(255-(255/100*time))))
					}else if (time >= 100) {
						gTxt.visible = false
						game = 2
						reset();
						baw(400 / 2, 300 / 2, 10, 4, 10)
						time = 0;
						HPtxt.alpha = 1;
					}
					
					
				}else if (game == 2){
					
					time++;
					HPtxt.alpha -= 0.01;
					HPtxt.text = "P = " + p1.hp;
					
					bd.lock() //ロック
					
					
					control();//コントロール
					
					p1.err();//壁
					
					launch();//弾処理
					
					Bomb_launch(); //爆弾処理
					
					att();//あたり判定
					
					enemyAnim();
					
					draw(); //主な描画
					
					playerSys();	//プレイヤー処理
					
					bd.unlock() //開放
					
					if (end - start > 16) {	//重いときはドット削除
						bullets.splice(0, 50);
					}
					if (enemyDead(enemy.length - 1)) {	//ボスクリア判定
						time = clear;
					}
				}else if (game == 3) {	//リザルト画面
					results();
				}else if (game == 4) {	//ショップ画面
					shop();
				}else if (game == 5) {	//ポーズ画面
					
				}
			}
			end = getTimer();
			txt.text = "ドット数" + bullets.length + "\n１フレーム" + (end - start) + "\key[88]=" + key[88];
		}
		
		private function keyDown(e:KeyboardEvent):void {
			key[e.keyCode] = true
			keyT[e.keyCode]++;
			
			//武器切り替え
			if (game == 2){
				if (e.keyCode >= 49 && e.keyCode <= 49+p1.Ctype - 1) {
					p1.type = e.keyCode - 49;
				}
			}
			
		}
		private function keyUp(e:KeyboardEvent):void {
			key[e.keyCode] = false
			keyT[e.keyCode] = 0;
		}
		private function control():void {//プレイヤー操作
			
			
			if(p1.flag == 1 || p1.flag == 2){
				
				/*
				if (key[67]) {//回収
					pCirS = 1000
				}else {
					pCirS = CpCirS
				}
				*/
				
				
				
				if (key[37]) p1.x -= p1.sx
				if (key[38]) p1.y -= p1.sy
				if (key[39]) p1.x += p1.sx
				if (key[40]) p1.y += p1.sy
				
				if (key[90]) {
					if (p1.type == 0){ //普通弾
						var i:int = new int;
						var ii:int = new int;
						if (bBullets[0].flag == 0){
							bBullets[0].x = p1.x + 6
							bBullets[0].y = p1.y
						}
						pCirS = CpCirS;
						if (p1.level == 1){ //レベル分け
							if (p1.pbt >= p1.cpbt) { //連射間隔
								for (i = 0; i < pBullets.length; i++){
									if (!pBullets[i].visible) {
										pBullets[i].x = p1.x + 6
										pBullets[i].y = p1.y
										pBullets[i].sx = 0;
										pBullets[i].sy = -5;
										pBullets[i].visible = true
										p1.pbt = 0;
										break;
									}
								}
							}
						}else if (p1.level == 2) {
							if (p1.pbt >= p1.cpbt2) {
								for (i = 0; i < pBullets.length; i++){
									if (!pBullets[i].visible) {
										pBullets[i].x = p1.x + 6
										pBullets[i].y = p1.y
										pBullets[i].sx = 0;
										pBullets[i].sy = -5;
										pBullets[i].visible = true
										p1.pbt = 0;
										break;
									}
								}
							}
						}else if (p1.level == 3) {
							if (p1.pbt >= p1.cpbt) {
								for (ii = -1; ii < 2; ii++){
									for (i = 0; i < pBullets.length; i++){
										if (!pBullets[i].visible) {
											pBullets[i].x = p1.x + 6
											pBullets[i].y = p1.y
											pBullets[i].sx = ii * -2;
											pBullets[i].sy = -5;
											pBullets[i].visible = true
											p1.pbt = 0;
											break;
										}
									}
								}
							}
						}else if (p1.level == 4) {
							if (p1.pbt >= p1.cpbt2) {
								for (ii = -1; ii < 2; ii++){
									for (i = 0; i < pBullets.length; i++){
										if (!pBullets[i].visible) {
											pBullets[i].x = p1.x + 6
											pBullets[i].y = p1.y
											pBullets[i].sx = ii * -2;
											pBullets[i].sy = -5;
											pBullets[i].visible = true
											p1.pbt = 0;
											break;
										}
									}
								}
							}
						}else if (p1.level == 5) {
							if (p1.pbt >= p1.cpbt2) {
								for (ii = -2; ii < 3; ii++){
									for (i = 0; i < pBullets.length; i++){
										if (!pBullets[i].visible) {
											pBullets[i].x = p1.x + 6
											pBullets[i].y = p1.y
											pBullets[i].sx = ii * -1;
											pBullets[i].sy = -5;
											pBullets[i].visible = true
											p1.pbt = 0;
											break;
										}
									}
								}
							}
						}
					/*
					}else if (p1.type == 1) { //ボム弾
						if (bBullets[0].flag == 0) {
							if (!bBullets[0].check()) {
								if (p1.energy - 50 >= 0){
									bBullets[0].flag = 1
									p1.energy -= 50;
								}
							}
						}
					}else if (p1.type == 2) { //吸収
						if (p1.energy - 0.5 >= 0){
							pCirS = 1000;
							p1.energy -= 0.5;
						}*/
					}
					
				} else { 
					if (bBullets[0].flag == 0){
						bBullets[0].x = p1.x + 6;
						bBullets[0].y = p1.y;
					}
					pCirS = CpCirS;
				}
			}
			if (key[88]){	//X
				if (bBullets[0].flag == 0 && !bf) {
					if (!bBullets[0].check()) {
						if (p1.energy - 50 >= 0){
							bBullets[0].flag = 1
							p1.energy -= 50;
						}
					}
				}
				bf = true;
			}else {
				bf = false;
			}
			if (key[67]){	//C
				if (p1.energy - 0.5 >= 0){
					pCirS = 1000;
					p1.energy -= 0.5;
				}
			}
			
			if (key[82]) {
				reset();
			}
			
			if (key[77]) {//メニューへ
				reset()
				setM();
				game = 0;
			}
			
			if (key[76]) {//デバッグ "L"
				if (!f3) {
					f3 = true;
					txt.visible = !txt.visible
				}
			}else {
				f3 = false;
			}
		}
		private function att():void {//あたり判定	//及び敵弾発射処理
			var i3:uint = new uint(0)
			var ebx:int = new int
			var eby:int = new int
			
			const bbx:int = new int(bBullets[0].x)
			var bby:int = new int(bBullets[0].y)
			var bbf:int = new int(bBullets[0].flag)
			
			const es:uint = new uint(eBullets.length)
			
			var t:int = new int(0);
			
			for (var i:uint = 0; i < es; i++) {
				if(enemy[i].visible){
					loop : for (var i2:uint = 0; i2 < eBullets[i].length; i2++ ) { 
						ebx = eBullets[i][i2].x
						eby = eBullets[i][i2].y
						
						if (eBullets[i][i2].type == 4) {
							if (eBullets[i][i2].atTime[eBullets[i][i2].attF] >= 0) {
								if (eBullets[i][i2].count > eBullets[i][i2].atTime[eBullets[i][i2].attF]) {//攻撃開始時刻になったとき
									if(eBullets[i][i2].att[eBullets[i][i2].attF] == 1){ //通常弾
										bullets.push(new bullet(eBullets[i][i2].x, eBullets[i][i2].y, 2, Math.cos(eBullets[i][i2].attR[eBullets[i][i2].attF] * Math.PI / 180) * 2, Math.sin(eBullets[i][i2].attR[eBullets[i][i2].attF] * Math.PI / 180) * 2));	//画面の弾セット
										eBullets[i][i2].count = 0;
										eBullets[i][i2].attF += 1;
									}else if (eBullets[i][i2].att[eBullets[i][i2].attF] == 2) {	//通常弾(小)
										bullets.push(new bullet(eBullets[i][i2].x, eBullets[i][i2].y, 6, Math.cos(eBullets[i][i2].attR[eBullets[i][i2].attF] * Math.PI / 180) * 2, Math.sin(eBullets[i][i2].attR[eBullets[i][i2].attF] * Math.PI / 180) * 2));	//画面の弾セット
										eBullets[i][i2].count = 0;
										eBullets[i][i2].attF += 1;
									}else if (eBullets[i][i2].att[eBullets[i][i2].attF] == 3) {	//プレイヤー向き弾(大)
										bullets.push(new bullet(eBullets[i][i2].x, eBullets[i][i2].y, 2, 0, 0));	//画面の弾セット
										eBullets[i][i2].count = 0;
										eBullets[i][i2].attF += 1;
									}else if (eBullets[i][i2].att[eBullets[i][i2].attF] == 4) {	//プレイヤー向き弾(小)
										bullets.push(new bullet(eBullets[i][i2].x, eBullets[i][i2].y, 6, 0, 0));	//画面の弾セット
										eBullets[i][i2].count = 0;
										eBullets[i][i2].attF += 1;
									}else{	//何もしないでフラグを次へ
										eBullets[i][i2].attF += 1;
									}
								}else {	//タイマー
									eBullets[i][i2].count += 1;
								}
							}else if (eBullets[i][i2].atTime[eBullets[i][i2].attF] == -1) {
								eBullets[i][i2].attF = 0;
								eBullets[i][i2].count += 1;
							}else if (eBullets[i][i2].atTime[eBullets[i][i2].attF] == -2) {
								
							}
							t++
						}
						
						if (sqAt(ebx, eby, 10, 10, p1.x, p1.y, 15, 15)) {//自機と敵の体
							if (p1.flag == 1) {
								if(eBullets[i][i2].type == 1){
									eBullets[i].splice(i2, 1);
									i2--
									p1.hp--
									p1.flag = 3;
									baw(ebx + 5, eby + 5, 5)
									baw(p1.x + 7, p1.y + 7, 10, 3, 10);
									score += 20
									
									pCirS = 1000;
									break
								}else if (eBullets[i][i2].type == 2) {
									eBullets[i].splice(i2, 1);
									i2--
									p1.hp--
									
									p1.flag = 3;
									p1.flag = 3
									baw(ebx + 5, eby + 5, 10, 3, 10);
									baw(p1.x + 7, p1.y + 7, 10, 3, 10);
									score += 30;
									
									pCirS = 1000;
									break
								}else if (eBullets[i][i2].type == 3) {
									eBullets[i].splice(i2, 1);
									i2--
									p1.hp--
									p1.flag = 3;
									baw(ebx + 5, eby + 5, 10, 5, 1);
									baw(p1.x + 7, p1.y + 7, 10, 3, 10);
									score += 20
									
									pCirS = 1000;
									break
								}else if (eBullets[i][i2].type == 4) {
									eBullets[i].splice(i2, 1);
									i2--
									p1.hp--
									p1.flag = 3;
									baw(ebx + 5, eby + 5, 5)
									baw(p1.x + 7, p1.y + 7, 10, 3, 10);
									score += 20
									
									pCirS = 1000;
									break
								}
							}
						}
						
						//敵の体と銃弾
						for (i3 = 0; i3 < pBullets.length; i3++){
							if (sqAt(ebx, eby, 10, 10, pBullets[i3].x, pBullets[i3].y, 3, 3)) {
								if (pBullets[i3].visible) {
									if(eBullets[i][i2].type == 1){
										eBullets[i].splice(i2, 1);
										i2--
										pBullets[i3].visible = false
										baw(ebx + 5, eby + 5, 5)
										score += 20
										break loop;
									}else if (eBullets[i][i2].type == 2) {
										eBullets[i].splice(i2, 1);
										i2--
										baw(ebx + 5, eby + 5, 10, 3, 10);
										pBullets[i3].visible = false
										score += 30;
										break loop;
									}else if (eBullets[i][i2].type == 3) {
										eBullets[i].splice(i2, 1);
										i2--
										baw(ebx + 5, eby + 5, 10, 5, 1);
										pBullets[i3].visible = false
										score += 30;
										break loop;
									}else if(eBullets[i][i2].type == 4){
										eBullets[i].splice(i2, 1);
										i2--
										pBullets[i3].visible = false
										baw(ebx + 5, eby + 5, 5)
										score += 20
										break loop;
									}
								}
							}
						}
						//敵の体とボム
						if (sqAt(ebx, eby, 10, 10, bbx, bby, 3, 3)) {
							if (bbf == 1) {
								if(eBullets[i][i2].type == 1){
									eBullets[i].splice(i2, 1);
									i2--;
									bbf = 0 //爆発
									baw(bbx + 2, bby + 2, 10, 3, 10) //爆弾
									bby = -10
									baw(ebx + 5, eby + 5, 5) //敵の体
									score += 20
									break 
								}else if (eBullets[i][i2].type == 2) {
									bbf = 0;
									eBullets[i].splice(i2, 1);
									i2--;
									baw(ebx + 5, eby + 5, 10, 3, 10);
									bby = -10
									score += 30;
									break 
								}else if (eBullets[i][i2].type == 3) {
									bbf = 0;
									eBullets[i].splice(i2, 1);
									i2--;
									baw(bbx + 2, bby + 2, 10, 3, 10) //爆弾
									bby = -10;
									score += 30;
									break
								}else if(eBullets[i][i2].type == 4){
									eBullets[i].splice(i2, 1);
									i2--;
									bbf = 0 //爆発
									baw(bbx + 2, bby + 2, 10, 3, 10) //爆弾
									bby = -10
									baw(ebx + 5, eby + 5, 5) //敵の体
									score += 20
									break
								}
							}
						}
						
						
						//ボムの破片と敵の体
						for (i3 = 0; i3 < d.length ; i3++) {
							if (d[i3] > 0 ) {
								if (b[d[i3]] >= ebx && b[d[i3]] <= ebx + 10 && c[d[i3]] >= eby && c[d[i3]] <= eby + 10) {
									if(eBullets[i][i2].type == 1){
										eBullets[i].splice(i2, 1);
										i2--
										bullets.splice(d[i3], 1)
										d.splice(i3,1)
										i3--
										baw(ebx + 5, eby + 5, 10, 1, 1)
										score += 5;
										break;
									}else if (eBullets[i][i2].type == 2) {
										eBullets[i].splice(i2, 1);
										i2--
										bullets.splice(d[i3], 1)
										d.splice(i3,1)
										i3--
										baw(ebx + 5, eby + 5, 10, 3, 10);
										score += 30;
										break;
									}else if (eBullets[i][i2].type == 3) {
										eBullets[i].splice(i2, 1);
										i2--
										bullets.splice(d[i3], 1)
										d.splice(i3,1)
										i3--
										baw(ebx + 5, eby + 5, 10, 5, 1)
										score += 30;
										break;
									}else if(eBullets[i][i2].type == 4){
										eBullets[i].splice(i2, 1);
										i2--
										bullets.splice(d[i3], 1)
										d.splice(i3,1)
										i3--
										baw(ebx + 5, eby + 5, 10, 1, 1)
										score += 5
										break;
									}
								}
							}
						}
					}
				}
				bBullets[0].y = bby
				bBullets[0].flag = bbf
				
				
			}
			d.splice(0,d.length)
			
			
			
		}
		private function move(Num:int, x1:Number, y1:Number):void {//敵移動
			for (var i:uint = 0; i < eBullets[Num].length; i++) {
				eBullets[Num][i].x += x1
				eBullets[Num][i].y += y1
			}
		}
		private function launch():void { //自機弾移動
			var i:int = new int;
			for (i = 0; i < pBullets.length; i++){
				if (pBullets[i].visible) {
					pBullets[i].y += pBullets[i].sy
					pBullets[i].x += pBullets[i].sx
					if (pBullets[i].check()) {
						pBullets[i].visible = false
					}
				}
			}
		}
		private function bulletAnim():void {
			var radian:Number = new Number
			var r:Number = new Number
			for (var i:int = 0; i < bullets.length; i++) {
				a[i] = bullets[i].flag
				b[i] = bullets[i].x
				c[i] = bullets[i].y
				radian = Math.atan2((p1.y+8) - bullets[i].y,(p1.x+8) - bullets[i].x)
				if (a[i] == 1) {
					if (p1.flag == 0 ||  p1.flag == 1 || p1.flag == 2) {
						bullets[i].x += bullets[i].sx
						bullets[i].y += bullets[i].sy
						if (!cirSt(p1.x + 8, p1.y + 8, pCirS, bullets[i].x, bullets[i].y)) {//プレイヤー付近にドットがなければ
							if (bullets[i].sx < 0) {
								bullets[i].sx += random(1, 3)
								if (bullets[i].sx > 0) {
									bullets[i].sx = 0
								}
							}else if ( bullets[i].sx > 0) {
								bullets[i].sx -= random(1, 3)
								if (bullets[i].sx < 0) {
									bullets[i].sx = 0
								}
								
							}
							
							bullets[i].sy = gv //重力有り
							
						}else {//プレイヤー付近にドットがあれば
							if(p1.flag != 0){
								
								bullets[i].sx = Math.cos(radian) * 5
								bullets[i].sy = Math.sin(radian) * 5
								if (cirSt(p1.x + 8, p1.y + 8, 4, bullets[i].x, bullets[i].y)) {
									bullets[i].flag = 0
									score += 1
								}
							}
						}
					}else if (p1.flag == 3) {
						if (p1.time == 300) {
								bullets[i].sx = -(Math.cos(radian) * 10)
								bullets[i].sy = -(Math.sin(radian) * 10)
						}
						
						bullets[i].x += bullets[i].sx
						bullets[i].y += bullets[i].sy
					}
				}else if (a[i] == 0) {
					bullets.splice(i, 1)
					i--
				}else if (a[i] == 2) {	//敵弾アニメーション
					
					if (bullets[i].sx == 0 && bullets[i].sy == 0) {
						radian = Math.atan2((p1.y+8) - bullets[i].y,(p1.x+8) - bullets[i].x)
						bullets[i].sx = Math.cos(radian) * 2
						bullets[i].sy = Math.sin(radian) * 2
					}
 					r = bullets[i].sx;
					bullets[i].x += bullets[i].sx
					bullets[i].y += bullets[i].sy
					if (cirSt(p1.x + 8, p1.y + 8, 10, bullets[i].x + 5, bullets[i].y + 5)) {//敵弾と自機のあたり判定
						if (p1.flag == 1) {	//死亡処理
							bullets[i].flag = 0
							p1.hp--
							p1.flag = 3;
							baw(p1.x + 7, p1.y + 7, 10, 3, 10);
							score -= 100;
							pCirS = 1000;
						}
					}
				}else if (a[i] == 3) {
					d.push(i)
					bullets[i].x += bullets[i].sx
					bullets[i].y += bullets[i].sy
				}else if (a[i] == 4) {
					bullets[i].x += bullets[i].sx * 2
					bullets[i].y += bullets[i].sy * 2
				}else if (a[i] == 5) {
					if (p1.flag == 0 ||  p1.flag == 1 || p1.flag == 2) {
						bullets[i].x += bullets[i].sx
						bullets[i].y += bullets[i].sy
						if (!cirSt(p1.x + 8, p1.y + 8, pCirS, bullets[i].x, bullets[i].y)) {//プレイヤー付近にドットがなければ
							if (bullets[i].sx < 0) {
								bullets[i].sx += random(1, 3)
								if (bullets[i].sx > 0) {
									bullets[i].sx = 0
								}
							}else if ( bullets[i].sx > 0) {
								bullets[i].sx -= random(1, 3)
								if (bullets[i].sx < 0) {
									bullets[i].sx = 0
								}
								
							}
							
							bullets[i].sy = gv //重力有り
							
						}else {//プレイヤー付近にドットがあれば
							if(p1.flag != 0){
								bullets[i].sx = Math.cos(radian) * 5;
								bullets[i].sy = Math.sin(radian) * 5;
								if (cirSt(p1.x + 8, p1.y + 8, 4, bullets[i].x, bullets[i].y)) {
									bullets[i].flag = 0;
									score += 2;
									p1.energy++; //エネルギー補給
								}
							}
						}
					}else if (p1.flag == 3) { //死亡時
						if (p1.time == 300) {
								bullets[i].sx = -(Math.cos(radian) * 10)
								bullets[i].sy = -(Math.sin(radian) * 10)
						}
						if(p1.time == 300) {
								bullets[i].sx = -(Math.cos(radian) * 10)
								bullets[i].sy = -(Math.sin(radian) * 10)
						}
						bullets[i].x += bullets[i].sx
						bullets[i].y += bullets[i].sy
					} 
				}else if (a[i] == 6) {	//敵弾(小)
					
					if (bullets[i].sx == 0 && bullets[i].sy == 0) {	//プレイヤー向きの弾は最初に設定
						radian = Math.atan2((p1.y+8) - bullets[i].y,(p1.x+8) - bullets[i].x)
						bullets[i].sx = Math.cos(radian) * 2
						bullets[i].sy = Math.sin(radian) * 2
					}
 					r = bullets[i].sx;
					bullets[i].x += bullets[i].sx
					bullets[i].y += bullets[i].sy
					if (cirSt(p1.x + 8, p1.y + 8, 8, bullets[i].x + 2, bullets[i].y + 2)) {//敵弾と自機のあたり判定
						if (p1.flag == 1) {
							bullets[i].flag = 0
							p1.hp--
							p1.flag = 3;
							baw(p1.x + 7, p1.y + 7, 10, 3, 10);
							score -= 100;
							pCirS = 1000;
						}
					}
				}
			}
		}
		private function sqAt(x:int, y:int, xS:int, yS:int, x2:int, y2:int, xS2:int, yS2:int):Boolean {//四角と四角
			return x <= (x2 + xS2) && (x + xS) >= x2 && y <= (y2 + yS2) && (y + yS) >= y2;
		}
		private function sqAt2(x:int, y:int, x2:int, y2:int, xS2:int, yS2:int):Boolean { //四角と点
			var a:Boolean = new Boolean(false)
			return x > x2 && x < x2 + xS2 && y > y2 && y < y2 + yS2
		}
		private function cirSt(x:int, y:int, S:int, x2:int, y2:int):Boolean {//丸と点
			return Math.sqrt(Math.pow(x - x2, 2) + Math.pow(y - y2, 2)) <= S
		}
		private function baw(x:Number, y:Number, S:Number, flag2:int = 1, m:Number = 3):void {//爆発  xy:座標  S:散らばる半径
			for (var i:int = 0; i < S * m; i++) {
				var a:Number = new Number(x)
				var b:Number = new Number(y)
				var j:int = new int;
				while(a == x && b == y){
				 //a = random(x - S, x + S);
				 //b = random(y - S, y + S);
				 j = random(0, 360);
				 a = x + (Math.cos(j) * random(1, S));
				 b = y + (Math.sin(j) * random(1, S));
				 }
				bullets.push(new bullet(a, b, flag2, a - x, b - y));
			}
		}
		private function random(start1:int, end1:int):int {
			return Math.floor(Math.random() * (end1 - start1) + start1)
		}
		private function Bomb_launch():void { //爆弾
			if (bBullets[0].flag == 1) {//画面に一つだけ
				bBullets[0].y -= 5
				if (bBullets[0].check()) {
					bBullets[0].flag = 0
				}
			}
		}
		private function reset(HP:int = 3):void {
			eBullets = new Array
			var t:int = new int(0);
			for (var i3:int = 0; i3 < enemy.length; i3++) { //敵準備
				enemy[i3].visible = false;
				enemy[i3].count = 0;
				enemy[i3].cAnim = 0;
				eBullets[i3] = new Array
				for (var i:int = 0; i < enemy[i3].type.length; i++) {
					for (var i2:int = 0; i2 < enemy[i3].type[i].length; i2++) {
						if (enemy[i3].type[i][i2] > 0) {
							if (enemy[i3].type[i][i2] == 4) {
								eBullets[i3].push(new eBullet(i2 * 10 + enemy[i3].x, i * 10 + enemy[i3].y, enemy[i3].type[i][i2], enemy[i3].attT[t], enemy[i3].att[t], enemy[i3].attR[t]));
								t += 1;
							}else{
								eBullets[i3].push(new eBullet(i2 * 10 + enemy[i3].x, i * 10 + enemy[i3].y,enemy[i3].type[i][i2]));
							}
						}
					}
				}
				t = 0
			}
			bBullets[0] = new Bomb()
			bullets = new Vector.<bullet>
			a = new Vector.<int>
			b = new Vector.<int>
			c = new Vector.<int>
			d = new Vector.<int>
			
			for (i = 0; i < pBullets.length; i++) {
				pBullets[i].visible = false
			}
			//p1 = new player(193,200)
			p1.x = 193;
			p1.y = 200;
			p1.hp = HP;
			p1.energy = 100;
			p1.flag = 1;
			p1.time = p1.ctime;
			
			score = 0
			pCirS = CpCirS
			gameCount = 0;
			HPtxt.alpha = 0;
			
			time = 0;
			
		}
		private function menu():void {
			menuImg.visible = true
			//基本画面ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
			if (mF == 0){
				if (key[40]) {//下
					if (!f) {
						sel += 1
						f = true
					}
				}else if (!key[40]) {
					f = false
				}
				if (key[38]) {
					if (!f2) {
						sel -= 1
						f2 = true
					}
				}else if (!key[38]) {
					f2 = false
				}
				
				if (sel > 2) {
					sel = 0
				}else if (sel < 0) {
					sel = 2
				}
				
				if (key[32] && keyT[32] == 1) {
					if (!f3) {
						f3 = true
						if (sel == 0) {
							game = 1
							resetM()
							bd.fillRect(bd.rect, 0xFF000000 );
						}else if (sel == 1) {
							mTxt2.visible = true
							sel = 0
							mF = 1
						}else if (sel == 2) {
							mF = 2
							mTxt2.visible = true
							mTxt2.text = howto
							selImg.visible = false
							
						}
					}
				}else {
					f3 = false
				}
				selImg.x = 160
				selImg.y = sel * mTxt1.textHeight / 3 + 134
				
			//おぷしょんーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
			}else if (mF == 1) {
				var ends:int = new int(3)
				selImg.x = 0
				selImg.y = sel * mTxt2.textHeight / 4 + 14
				mTxt2.text = "吸収範囲　　　　　　　　　　　　　　　" + CpCirS + "\n" +
							 "重力　　　　　　　　　　　　　　　　　　" + gv + "\n" +
							 "残像モード                 " + zanzou + "\n" +
							 "戻る"
				if (key[39]) {
					if (!f5) {
						f5 = true
						count2 = frame
						if (sel == 1) {
							gv += 1
						}else if (sel == 2) {
							zanzou = !zanzou
						}
					}
					
					if (sel == 0) {
						if ((frame - count2) % 5 == 0) {
							CpCirS += 1
						}
					}
					
				}else {
					f5 = false
					count2 = 0
				}
				if (key[37]) {
					if (!f4) {
						f4 = true
						count = frame
						if (sel == 1) {
							gv -= 1
						}else if (sel == 2) {
							zanzou = !zanzou
						}
					}
					if (sel == 0) {
						if ((frame - count) % 5 == 0) {
							CpCirS -= 1
						}
					}
				}else {
					f4 = false
					count = 0
				}
				if (key[40]) {//下
					if (!f) {
						sel += 1
						f = true
					}
				}else if (!key[40]) {
					f = false
				}
				if (key[38]) {//上
					if (!f2) {
						sel -= 1
						f2 = true
					}
				}else if (!key[38]) {
					f2 = false
				}
				
				//戻るーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
				if (sel > ends) {
					sel = 0
				}else if (sel < 0) {
					sel = ends
				}
				
				if (key[32]) {
					if (!f3) {
						if (sel == 0) {
							
						}else if (sel == ends) {
							sel = 1
							f3 = true
							mF = 0
							mTxt2.visible = false
							mTxt2.text = ""
						}
					}
				}else {
					f3 = false
				}
			}else if (mF == 2) {//遊び方
				
				if (key[32]) {
					if (!f3) {
						f3 = true
						mF = 0
						mTxt2.visible = false
						mTxt2.text = ""
						selImg.visible = true
					}
				}else {
					f3 = false
				}
			}
			
			
		}
		private function setM():void {//メニューセット
			sel = 0
			mF = 0
			menuImg.visible = true
			selImg.visible = true
			//メインメニューテキストフィールド(TF)
			mTxt1.visible = true
			mTxt1.x = 170
			mTxt1.y = 130
			mTxt1.width = 200
			mTxt1.height = 200
			mTxt1.backgroundColor = 0x000000;
			mTxt1.textColor = 0xFFFFFF
			mTxt1.text = "スタート\nオプション\n説明"
			
		}
		private function resetM():void {//メニュー片付け
			menuImg.visible = false
			mTxt1.visible = false
			selImg.visible = false
		}
		private function loadStage(num:int):void {//開発中 ステージ読み込み
			var em:Vector.<enemySet> = new Vector.<enemySet>
			var eNum:int = new int(0); //敵番号
			var Stxt:String = new String;
			var StIndex:int = new int; //enemy開始位置
			var selIndex:int = new int;	//検索位置
			var eStIndex:int = new int;	//一つの敵の検索開始位置
			var st:String = new String; //一時格納庫
			var st2:String = new String;
			var ranks:Array = new Array;	//ランク格納
			
			var start:int = new int;
			var type:Array = new Array;
			var x:int = new int;
			var y:int = new int;
			var attT:Array = new Array;
			var att:Array = new Array;
			var attR:Array = new Array;
			var xAnim:Array = new Array;
			var yAnim:Array = new Array;
			var tAnim:Array = new Array;
			
			var i:int = new int;
			var i2:int = new int;
			var value:int = new uint;
			var value2:int = new uint;
			
			//ステージ(num)データ読み込み
			Stxt = new String(new Main["txt"+num]);
			var reg:RegExp = new RegExp("(\r\n)", "g");	
			Stxt = Stxt.replace(reg, "");	//改行をすべて消す
			//ステージ情報
			StIndex = Stxt.indexOf("[STAGE]", 0) + 7;
			selIndex = StIndex;
			//クリアカウント
			selIndex = Stxt.indexOf("clear=", StIndex) + 6;
			st = Stxt.slice(selIndex, Stxt.lastIndexOf(";", selIndex));
			clear = parseInt(st);
			
			//ランク情報
			selIndex = Stxt.indexOf("rank=", StIndex) + 5;
			st = Stxt.slice(selIndex, Stxt.indexOf(";", selIndex));
			ranks = st.split(",");
			for (i = 0; i < 4; i++) {
				rank[i] = parseInt(ranks[i]);
			}
			
			//敵情報
			StIndex = Stxt.indexOf("[ENEMY]", 0) + 7; //開始位置確認
			selIndex = StIndex;
			while(true){
				eStIndex = Stxt.indexOf("{", selIndex) + 1; 　//i体目検索
				if (eStIndex == 0) { //見つからない場合
					break;
				}else {
					em[eNum] = new enemySet;
				}
				selIndex = eStIndex;
				
				//start
				selIndex = Stxt.indexOf("start=", eStIndex) + 6; 
				st = Stxt.slice(selIndex, Stxt.indexOf(";", selIndex)); //終止符まで
				start = parseInt(st);
				em[eNum].start = start; //代入
				
				//type
				selIndex = Stxt.indexOf("type", eStIndex) + 4;
				st = Stxt.slice(selIndex, Stxt.indexOf(";", selIndex)); //終止符
				i = 0;
				selIndex = 0;
				while (true) {
					if (st.indexOf("/", selIndex) == -1) {
						st = st.slice(selIndex); //区切りまで取る
						type[i] = new Array;
						type[i] = st.split(","); //区切って取得
						break; //なかったらブレーク
					}else {
   						 //区切りまで取る
						type[i] = new Array;
  						type[i] = st.slice(selIndex, st.indexOf("/", selIndex)).split(","); //区切って取得
						selIndex = st.indexOf("/", selIndex) + 1; //　'/'へインデックス
					};
					i++;
				}
				value = type.length;	//高速化
				for (i = 0; i < value; i++) {
					value2 = type[i].length;
					for (i2 = 0; i2 < value2; i2++) {
						type[i][i2] = parseInt(type[i][i2]);	//整数化
					}
				}
				em[eNum].type = type.concat();
				type = new Array;
				
				//x
				selIndex = Stxt.indexOf("x=", eStIndex) + 2;
				st = Stxt.slice(selIndex, Stxt.indexOf(";", selIndex)); //終止符まで
				x = parseInt(st);
				em[eNum].x = x; //代入
				
				//y
				selIndex = Stxt.indexOf("y=", eStIndex) + 2;
				st = Stxt.slice(selIndex, Stxt.indexOf(";", selIndex)); //終止符まで
				y = parseInt(st);
				em[eNum].y = y;
				
				
				
				//attT
				selIndex = Stxt.indexOf("attT=", eStIndex) + 5;
				st = Stxt.slice(selIndex, Stxt.indexOf(";", selIndex)); //終止符まで
				i = 0;
				attT = st.split("/"); //区切って取得
				
 				if (st.indexOf("/", 0) == -1) {
					attT[i] = new Array;
					attT[i] = st.split(","); //区切って取得
				}else {
   					//区切りまで取る
					for (i = 0; i < attT.length; i++ ){
						st2 = attT[i];
						attT[i] = new Array;
						attT[i] = st2.split(",");
					}
				};	
				
				
				/*
				while (true) {
 					if (st.indexOf("/", 0) == -1) {
						attT[i] = new Array;
						attT[i] = st.split(","); //区切って取得
						break; //なかったらブレーク
					}else {
   						//区切りまで取る
						attT = st.split("/"); //区切って取得
						attT[i] = new Array;
						attT[i] = attT[i].split(",");
					};	
					i++;
				}
				*/
				
				//att
				selIndex = Stxt.indexOf("att=", eStIndex) + 4;
				st = Stxt.slice(selIndex, Stxt.indexOf(";", selIndex)); //終止符まで
				i = 0;
				att = st.split("/"); //区切って取得
				if (st.indexOf("/", 0) == -1) {
					att[i] = new Array;
					att[i] = st.split(","); //区切って取得
				}else {
   					//区切りまで取る
					for (i = 0; i < att.length; i++ ){
						st2 = att[i];
						att[i] = new Array;
	 					att[i] = st2.split(",");
					}
				};	
				
				//attR
				selIndex = Stxt.indexOf("attR=", eStIndex) + 5;
				st = Stxt.slice(selIndex, Stxt.indexOf(";", selIndex)); //終止符まで
				i = 0;
				attR = st.split("/"); //区切って取得
				if (st.indexOf("/", 0) == -1) {
					attR[i] = new Array;
					attR[i] = st.split(","); //区切って取得
				}else {
   					//区切りまで取る
					for (i = 0; i < attR.length; i++ ){
						st2 = attR[i];
						attR[i] = new Array;
						attR[i] = st2.split(",");
					}
				};	
				
				/*
				i = 0;
				selIndex = Stxt.indexOf("att=", eStIndex) + 4;
				st = Stxt.slice(selIndex, Stxt.indexOf(";", selIndex)); //終止符まで
				while (true) {
					if (st.indexOf("/", selIndex) == -1) {
						att[i] = new Array;
						att[i] = st.split(","); //区切って取得
						break; //なかったらブレーク
					}else {
   						 //区切りまで取る
						att[i] = new Array;
  						att[i] = st.slice(selIndex, st.indexOf("/", selIndex)).split(","); //区切って取得
						selIndex = st.indexOf("/", selIndex) + 1; //　'/'へインデックス
					};	
					i++;
				}
				*/
				
				value = att.length;	//高速化
				for (i = 0; i < value; i++) {
					value2 = att[i].length;
					for (i2 = 0; i2 < value2; i2++) {
						att[i][i2] = parseInt(att[i][i2]);	//整数化
						attT[i][i2] = parseInt(attT[i][i2]);
 						attR[i][i2] = parseInt(attR[i][i2]);
					}
				}
				em[eNum].att = att.concat();
				em[eNum].attT = attT.concat();
				em[eNum].attR = attR.concat();
				
				//xAnim
				selIndex = Stxt.indexOf("xAnim=", eStIndex) + 6;
				st = Stxt.slice(selIndex, Stxt.indexOf(";", selIndex)); //終止符まで
				xAnim = st.split(","); //とりあえずString型
				
				//yAnim
				selIndex = Stxt.indexOf("yAnim=", eStIndex) + 6;
				st = Stxt.slice(selIndex, Stxt.indexOf(";", selIndex)); //終止符まで
				yAnim = st.split(","); //とりあえずString型
				
				//tAnim
				selIndex = Stxt.indexOf("tAnim=", eStIndex) + 6;
				st = Stxt.slice(selIndex, Stxt.indexOf(";", selIndex)); //終止符まで
				tAnim = st.split(","); //とりあえずString型
				
				//att系代入
				/*
				value = att.length;
				for (i = 0; i < value; i++) {
					em[eNum].att[i] = parseInt(att[i]);
					em[eNum].attT[i] = parseInt(attT[i]);
				}
				*/
				
				//Anim系代入
				value = xAnim.length;
				for (i = 0; i < value; i++) {
					em[eNum].xAnim[i] = parseInt(xAnim[i]);
					em[eNum].yAnim[i] = parseInt(yAnim[i]);
					em[eNum].tAnim[i] = parseInt(tAnim[i]);
				}
				
				selIndex = eStIndex + 1; //次の敵へ
  				eNum++;
				
			}
			
			enemy = new Vector.<enemySet>;
			enemy = em;
		}
		private function bulletsDraw():void {	//弾描画	//及び画面外の弾削除
			var i:int = new int;
			for (i = 0; i < bullets.length; i++) {
				if (bullets[i].flag == 1){
					bd.setPixel32(bullets[i].x, bullets[i].y, 0xFFFFFF);
					if (bullets[i].check(gv)) {
						bullets.splice(i, 1)
						i--
					}
				}else if (bullets[i].flag == 2) {
					bd.copyPixels(bulletImg[0],bulletImg[0].rect,new Point(bullets[i].x,bullets[i].y));
					if (bullets[i].check(0)) {
						bullets.splice(i, 1)
						i--
					}
				}else if (bullets[i].flag == 3) {
					bd.setPixel32(bullets[i].x, bullets[i].y, 0xFF2222);
					bd.setPixel32(bullets[i].x+1, bullets[i].y, 0xFF2222);
					bd.setPixel32(bullets[i].x, bullets[i].y+1, 0xFF2222);
					bd.setPixel32(bullets[i].x + 1, bullets[i].y + 1, 0xFF2222);
					if (bullets[i].check(0)) {
						bullets.splice(i, 1)
						i--
					}
				}else if (bullets[i].flag == 4) {
					bd.setPixel32(bullets[i].x, bullets[i].y, 0xFFFFFF);
					bd.setPixel32(bullets[i].x+1, bullets[i].y, 0xFFFFFF);
					bd.setPixel32(bullets[i].x, bullets[i].y+1, 0xFFFFFF);
					bd.setPixel32(bullets[i].x + 1, bullets[i].y + 1, 0xFFFFFF);
					if (bullets[i].check(0)) {
						bullets.splice(i, 1)
						i--
					}
				}else if (bullets[i].flag == 5) {
					bd.setPixel32(bullets[i].x, bullets[i].y, 0x9999FF);
					if (bullets[i].check(0)) {
						bullets.splice(i, 1)
						i--
					}
				}else if (bullets[i].flag == 6) {
					bd.copyPixels(bulletImg[1],bulletImg[1].rect,new Point(bullets[i].x+4,bullets[i].y+4));
					if (bullets[i].check(0)) {	//はみ出し
						bullets.splice(i, 1)
						i--
					}
				}
			}
		}
		private function enemyAnim():void {
			var es:int = new int(enemy.length);
			var onex:Number = new Number
			var oney:Number = new Number
			for (var i:int = 0; i < es; i++) {
				if (time >= enemy[i].start) {
					enemy[i].visible = true;
				}
				
				if (enemy[i].visible) {
					onex = enemy[i].xAnim[enemy[i].cAnim] / enemy[i].tAnim[enemy[i].cAnim]; //一フレームごとの移動距離
					oney = enemy[i].yAnim[enemy[i].cAnim] / enemy[i].tAnim[enemy[i].cAnim];
					if (enemy[i].tAnim[enemy[i].cAnim] > 0) {
						if(enemy[i].count < enemy[i].tAnim[enemy[i].cAnim]){//移動
							move(i, onex, oney);
						}else if (enemy[i].count == enemy[i].tAnim[enemy[i].cAnim]) {//移動完了
							move(i, onex, oney);
							enemy[i].cAnim++;
							enemy[i].count = 0;
						}
						enemy[i].count++
					}else if (enemy[i].tAnim[enemy[i].cAnim] == 0) {	//一瞬の処理
						move(i, enemy[i].xAnim[enemy[i].cAnim], enemy[i].yAnim[enemy[i].cAnim]);
						enemy[i].cAnim++
						enemy[i].count = 0;
						i--;　//次の処理をこのフレームで処理するため
						
					}else if (enemy[i].tAnim[enemy[i].cAnim] == -1){	//繰り返し
						enemy[i].cAnim = 0;
						enemy[i].count = 0;
					}else if (enemy[i].tAnim[enemy[i].cAnim] == -2) {	//終了
						enemy[i].visible = false;
					}
				}
			}
		}
		private function cut(Num:int, Num2:int ):uint {//(Num)の(Num2)桁目を取得
			var i:int = new int;
			for (i = 0; i < Num2 - 1; i++) {
				Num /= 10;
			}
			return Num % 10;
		}
		private function draw():void {
			if (!zanzou){
				bd.fillRect(bd.rect, 0x000000); //塗りつぶし
			}else{
				bd.colorTransform(bd.rect, new ColorTransform(1, 1, 1, 1, -20, -20, -20));
			}
			
			var v:int = new int
			v = enemy.length;
			//敵弾(体)表示
			for (var i2:uint = 0; i2 < v; i2++) {
				if(enemy[i2].visible){
					for (var i:uint = 0; i < eBullets[i2].length; i++) {
						bd.copyPixels(eBulletImg[eBullets[i2][i].type], eBulletImg[eBullets[i2][i].type].rect, new Point(eBullets[i2][i].x, eBullets[i2][i].y))	
					}
				}
			}
			
			bulletsDraw();
			
			bulletAnim()
			
			//プレイヤー
			if (p1.hp > 0){
				if (p1.flag == 3 || p1.flag == 2) {
					p1.time--;
					if (p1.time < 240) {
						p1.flag = 2; //無敵時間
						if (p1.time % 10 > 5) {
							bd.copyPixels(playerImg, playerImg.rect, new Point(p1.x, p1.y))
						}
					}else if (p1.time == 240) { //残機表示
						HPtxt.alpha = 1;
					}else{ //仮死亡
						p1.x = 193;
						p1.y = 200;
					}
				}
				if (p1.time == 0) {
					p1.time = p1.ctime;
					p1.flag = 1;
				}
			}
			if (p1.flag == 1) {
				bd.copyPixels(playerImg, playerImg.rect, new Point(p1.x, p1.y))
			}
			if (p1.pbt < p1.cpbt) {//連射カウント
				p1.pbt++
			}
			
			//自機の弾
			v = pBullets.length
			for (i = 0; i < v;i++){
				if (pBullets[i].visible) {
					bd.setPixel32(pBullets[i].x, pBullets[i].y, 0xFFFFFF);
					bd.setPixel32(pBullets[i].x + 1, pBullets[i].y, 0xFFFFFF);
					bd.setPixel32(pBullets[i].x + 2, pBullets[i].y, 0xFFFFFF);
					bd.setPixel32(pBullets[i].x, pBullets[i].y + 1, 0xFFFFFF);
					bd.setPixel32(pBullets[i].x + 1, pBullets[i].y + 1, 0xFFFFFF);
					bd.setPixel32(pBullets[i].x + 2, pBullets[i].y + 1, 0xFFFFFF);
					bd.setPixel32(pBullets[i].x, pBullets[i].y + 2, 0xFFFFFF);
					bd.setPixel32(pBullets[i].x + 1, pBullets[i].y + 2, 0xFFFFFF);
					bd.setPixel32(pBullets[i].x + 2, pBullets[i].y + 2, 0xFFFFFF);
				}
			}
			
			//自機のボム
			v = bBullets[0].x
			i = bBullets[0].y
			
			if (bBullets[0].flag == 1) { //3x3のブロック
				bd.setPixel32(v, i, 0xFF0000);
				bd.setPixel32(v + 1, i, 0xFF0000);
				bd.setPixel32(v + 2, i, 0xFF0000);
				bd.setPixel32(v, i + 1, 0xFF0000);
				bd.setPixel32(v + 1, i + 1, 0xFF0000);
				bd.setPixel32(v + 2, i + 1, 0xFF0000);
				bd.setPixel32(v, i + 2, 0xFF0000);
				bd.setPixel32(v + 1, i + 2, 0xFF0000);
				bd.setPixel32(v + 2, i + 2, 0xFF0000);
			}
			
			//スコア表示
			if (score < 0) {
				score = 0;
			}
			v = 0;
			i = 8;//桁数
			bd.copyPixels(scoreImg, scoreImg.rect, new Point(0, 290));
			for (i2 = 1; i2 <= i; i2++) {
				v = cut(score, i2);	//v桁目の数字を取得
				bd.copyPixels(numImg[v], numImg[v].rect, new Point((numImg[v].width) * (i - i2) + scoreImg.width, 300 - numImg[v].height));
			}
			
			//エナジー表示
			if (p1.energy > 100) {
				p1.energy = 100;
				score++;
			}
			bd.fillRect(new Rectangle(0, 274, 102, 12), 0xFFFFFFFF);
			bd.fillRect(new Rectangle(1, 275, p1.energy, 10), 0x2200FF00);
			
			//タイプ別表示
			if (p1.type == 0){ //通常
				bd.fillRect(new Rectangle(107, 274, 12, 12), 0xFFFFFFFF);
			}else if (p1.type == 1) { //ボム
				bd.fillRect(new Rectangle(107, 274, 12, 12), 0xFFFF0000);
			}else if (p1.type == 2) { //吸収
				bd.fillRect(new Rectangle(107, 274, 12, 12), 0xFFFFFF00);
			}
			
		}
		private function playerSys():void {	//プレイヤー処理   //クリア判定
			if (p1.hp == 0) {	//ゲームオーバー判定
				gameCount++;
				HPtxt.alpha = 1;
				HPtxt.text = "GAMEOVER";
				if (gameCount == 300) {	//カウントが300になったら
					gameCount = 0;	//カウントリセット
					HPtxt.alpha = 0;
					reset();
					setM();
					game = 0;	//メニューへ
				}
			}else if (time>= clear) {	//クリア判定
				gameCount++;
				HPtxt.alpha = 1;
				HPtxt.text = "GAMECLEAR";
				if (gameCount == 300) {	//カウントが300になったら
					gameCount = 0;	//カウントリセット
					HPtxt.alpha = 0;
					resultsSet();
					game = 3;
				}
			}
		}
		private function resultsSet():void {
			resultTxt.visible = true;
			rankTxt.visible = true;
			gameCount = 0;
		}
		private function results():void {	//リザルト
			var scorePt:int = score;
			var hpPt:int = p1.hp * 1000;
			var enelgyPt:int = p1.energy*5;
			var pt:int = scorePt + hpPt + enelgyPt;
			gameCount++;
			bd.fillRect(bd.rect, 0x000000);
			resultTxt.text = "RESULT\n" +
			"score = " + score + "\n" +
			"    " + scorePt + "pt\n" +
			"hp = " + p1.hp + "機\n" +
			"    " + hpPt + "pt\n" +
			"enelgy = " + p1.energy + "\n" +
			"    " + enelgyPt + "pt\n" +
			"\ntotal = " + pt + "pt\n";
			
			if (pt >= rank[0]) {
				rankTxt.text = "Rank\n   S";
			}else if (pt >= rank[1]) {
				rankTxt.text = "Rank\n   A";
			}else if (pt >= rank[2]) {
				rankTxt.text = "Rank\n   B";
			}else if (pt >= rank[3]) {
				rankTxt.text = "Rank\n   C";
			}
			//resultTxt.appendText("\n\nThanks\nFor\nPlaying!");
			
			if (gameCount >= 200) {//キーボード入力可能
				gameCount = 200;
				resultTxt.appendText("\nPress Space-Key\nNext!\n");
				if (key[32] && keyT[32] == 1) {
					keyT[32]++;	//長押し防止
					resetResults();	//リザルト結果片付け
					reset();	//ステージ等かたずけ
					gameCount = 0;
					time = 0;
					if (stageNum == stageLast){	//最後のステージならば
						setM();	//メニューに戻す
						game = 0;
					}else {	//次のステージへ
						stageNum++;
						loadStage(stageNum);
						reset(p1.hp);	//残機引き継ぎ
						game = 1;	//ゲームスタートへ
					}
				}
			}
		}
		private function resetResults():void {	//リザルト片付け
			resultTxt.visible = false;
			rankTxt.visible = false;
		}
		private function enemyDead(n:int):Boolean {	//敵が死んだか
			if (eBullets[n].length != 0) {	//生きてる体があればfalse
				return false;
			}
			return true;
		}
		private function shopSet():void {	//ショップ画面セット
			game = 4;
			
		}
		private function shop():void {	//ショップ画面中の処理
			
		}
		private function resetShop():void {	//ショップ画面片付け
			game = 1; //ゲーム画面へ
		}
		
	}
}