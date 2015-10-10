package {

    import flash.display.Sprite;
    import flash.events.StatusEvent;
    import flash.net.LocalConnection;
    import flash.system.Capabilities;
    import flash.text.TextField;
    import flash.text.TextFormat;

    // Sender
    public class Main extends Sprite {

        private const CONNECTION_NAME:String = "app#com.tatsuyakoyama.tart.lab.receiver:tartSampleConnection";

        private var _connection:LocalConnection;
        private var _textField:TextField;
        private var _textFormat:TextFormat;

        public function Main() {
            _centeringWindowForDesktopApp();
            _initTextField();
            _initLocalConnection();
        }

        private function _centeringWindowForDesktopApp():void {
            PLATFORM::DESKTOP {
                stage.nativeWindow.x = (Capabilities.screenResolutionX - stage.nativeWindow.width)  * 0.5;
                stage.nativeWindow.y = (Capabilities.screenResolutionY - stage.nativeWindow.height) * 0.5;
            }
        }

        private function _initTextField():void {
            _textFormat = new TextFormat();
            _textFormat.size  = 14;
            _textFormat.color = 0xeeeeee;
            _textFormat.font  = "_typewriter";

            _textField = new TextField();
            _textField.x      = 10;
            _textField.y      = 10;
            _textField.width  = stage.stageWidth - 20;
            _textField.height = stage.stageHeight - 20;

            _textField.defaultTextFormat = _textFormat;
            stage.addChild(_textField);
        }

        private function _initLocalConnection():void {
            _log("LocalConnection.isSupported: " + LocalConnection.isSupported);

            _connection = new LocalConnection();
            _connection.addEventListener(StatusEvent.STATUS, _onConnectionStatus);
            _log("start sending message...");
            _log("domain: " + _connection.domain);
            _connection.send(CONNECTION_NAME, "onMessageFromLC", "test message");
        }

        private function _onConnectionStatus(event:StatusEvent):void {
            switch (event.level) {
            case "status":
                _log("send succeeded");
                break;
            case "error":
                _log("[Error] send failed");
                break;
            }
        }

        private function onMessageFromLC(param:String):void {
            _log(param);
        }

        private function _log(text:String):void {
            _textField.appendText(text + "\n");
            _textField.scrollV = _textField.maxScrollV;
        }

    }
}
