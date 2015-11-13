package tartlab.utils {

    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;

    public class PigmyConsole extends TextField {

        private var _textFormat:TextFormat;

        public function PigmyConsole(x:Number=20, y:Number=20,
                                     width:Number=200, height:Number=400,
                                     fontSize:Number=14, fontColor:uint=0xeeeeee,
                                     borderColor:uint=0x505050)
        {
            this.x      = x;
            this.y      = y;
            this.width  = width;
            this.height = height;

            _textFormat = new TextFormat();
            _textFormat.size  = fontSize;
            _textFormat.color = fontColor;
            _textFormat.font  = "_typewriter";
            _textFormat.align = TextFormatAlign.LEFT;

            this.defaultTextFormat = _textFormat;

            this.border = true;
            this.borderColor = borderColor;
        }

        public function log(text:String):void {
            appendText(text + "\n");
            scrollV = maxScrollV;
        }

        public function rewrite(text:String):void {
            this.text = text;
            scrollV = maxScrollV;
        }

        public function clear():void {
            text = "";
            scrollV = maxScrollV;
        }

    }
}
