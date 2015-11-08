package tartlab.utils {

    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;

    public class PigmyButton extends Sprite {

        public var textColor:uint      = 0xeeeeee;
        public var hoverTextColor:uint = 0xeeee88;
        public var downTextColor:uint  = 0xee9966;

        private var _onClick:Function;
        private var _textFormat:TextFormat;
        private var _bgTextField:TextField;
        private var _fgTextField:TextField;
        private var _fgTextY:Number;

        public function PigmyButton(onClick:Function, text:String="Button",
                                    x:Number=20, y:Number=20,
                                    width:Number=200, height:Number=40,
                                    fontSize:Number=24)
        {
            _onClick = onClick;
            this.x   = x;
            this.y   = y;

            _bgTextField = _makeBgTextField(width, height);
            addChild(_bgTextField);

            _fgTextField = _makeFgTextField(width, height, text, fontSize);
            _centeringVerticalAlign();
            addChild(_fgTextField);

            _initMouseEvents();
        }

        private function _initMouseEvents():void {
            addEventListener(MouseEvent.MOUSE_OVER, _onMouseOver)
            addEventListener(MouseEvent.MOUSE_OUT,  _onMouseOut)
            addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown)
            addEventListener(MouseEvent.MOUSE_UP,   _onMouseUp)
            addEventListener(MouseEvent.CLICK,      _onClickInternal);
        }

        private function _makeBgTextField(width:Number, height:Number):TextField {
            var bgTextField:TextField = new TextField();
            bgTextField.width       = width;
            bgTextField.height      = height;
            bgTextField.border      = true;
            bgTextField.borderColor = textColor;
            return bgTextField;
        }

        private function _makeFgTextField(width:Number, height:Number,
                                          text:String, fontSize:Number):TextField
        {
            _textFormat  = new TextFormat();
            _textFormat.size  = fontSize;
            _textFormat.color = textColor;
            _textFormat.font  = "_typewriter";
            _textFormat.align = TextFormatAlign.CENTER;

            var fgTextField:TextField = new TextField();
            fgTextField.defaultTextFormat = _textFormat;
            fgTextField.text       = text;
            fgTextField.width      = width;
            fgTextField.height     = height;
            fgTextField.wordWrap   = true;
            fgTextField.selectable = false;
            return fgTextField;
        }

        private function _centeringVerticalAlign():void {
            var middleY:Number = _bgTextField.height / 2;
            _fgTextY = middleY - _fgTextField.textHeight / 2;
            _fgTextField.y = _fgTextY;
        }

        private function _onMouseOver(event:MouseEvent):void {
            _fgTextField.y = _fgTextY - 1;
            _textFormat.color = hoverTextColor;
            _fgTextField.setTextFormat(_textFormat);
        }

        private function _onMouseOut(event:MouseEvent):void {
            _fgTextField.y = _fgTextY;
            _textFormat.color = textColor;
            _fgTextField.setTextFormat(_textFormat);
        }

        private function _onMouseDown(event:MouseEvent):void {
            _fgTextField.y = _fgTextY + 2;
            _textFormat.color = downTextColor;
            _fgTextField.setTextFormat(_textFormat);
        }

        private function _onMouseUp(event:MouseEvent):void {
            _fgTextField.y = _fgTextY - 1;
            _textFormat.color = hoverTextColor;
            _fgTextField.setTextFormat(_textFormat);
        }

        private function _onClickInternal(event:MouseEvent):void {
            if (_onClick) {
                _onClick(event);
            }
        }

    }
}
