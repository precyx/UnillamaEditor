package com.sorcerer
{
	// adobe
	//
	// own
	//
	public class BoardManager
	{
		// data
		private var _boardArray:Vector.<Board>;
		private var _length:uint;
		//
		//
		public function BoardManager():void{
			_boardArray = new Vector.<Board>();
		}
		// publics
		public function add(board:Board) {
			_boardArray.push(board);
		}
		public function remove(board:Board) {
			var i = _boardArray.indexOf(board);
			_boardArray.splice(i, 1);
			board.parent.removeChild(board);
		}
		public function removeAll() {
			for (var i:uint = 0; i < _boardArray.length; i++) {
				var b:Board = _boardArray[i];
				b.parent.removeChild(b);
			}
			_boardArray.length = 0;
		}
		/** 
		 * Nur 1 Board hat den Fokus.
		 */
		public function focusSingle(board:Board) {
			unfocusAll();
			board.focus = true;
			board.parent.setChildIndex( board, board.parent.numChildren - 1);
		}
		/** 
		 * Ein weiteres Board bekommt den Fokus.
		 */
		public function focusAdditional(board:Board) {
			
		}
		public function focusAll() {
			
		}
		public function unfocusSingle(board:Board) {
			
		}
		public function unfocusAll() {
			for (var i:uint = 0; i < _boardArray.length; i++) {
				var b:Board = _boardArray[i];
				b.focus = false;
			}
		}
		public function get length():uint {
			return _boardArray.length;
		}
		public function getFocusedBoard():Board {
			var fb:Board = null;
			for (var i:uint = 0; i < _boardArray.length; i++) {
				var b:Board = _boardArray[i];
				if (b.focus) {
					fb = b;
					break;
				}
			}
			return fb;
		}
	}//end-class
}//end-pack