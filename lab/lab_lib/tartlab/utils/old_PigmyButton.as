package tartlab.utils {

    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;

    public class PigmyButton extends TextField {

        private var _onClick:Function;
        private var _textFormat:TextFormat;

        public function PigmyButton(onClick:Function, text:String="Button",
                                    x:Number=20, y:Number=20,
                                    width:Number=200, height:Number=40,
                                    fontSize:Number=24, fontColor:uint=0xeeeeee)
        {
            _onClick = onClick;

            this.x      = x;
            this.y      = y;
            this.width  = width;
            this.height = height;

            _textFormat = new TextFormat();
            _textFormat.size  = fontSize;
            _textFormat.color = fontColor;
            _textFormat.font  = "_typewriter";
            _textFormat.align = TextFormatAlign.CENTER;

            defaultTextFormat = _textFormat;
            this.text = text;

            selectable  = false;
            border      = true;
            borderColor = fontColor;

            addEventListener(MouseEvent.CLICK, _onClickInternal);
        }

        private function _onClickInternal(event:MouseEvent):void {
            if (_onClick) {
                _onClick(event);
            }
        }

    }
}
