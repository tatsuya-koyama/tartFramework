package {

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.system.MessageChannel;
    import flash.system.Worker;

    public class WorkerThread extends Sprite {

        private var _channelToWorker:MessageChannel;
        private var _channelToMain:MessageChannel;

        public function WorkerThread() {
            _channelToMain = Worker.current.getSharedProperty("_channelToMain");

            _channelToWorker = Worker.current.getSharedProperty("_channelToWorker");
            _channelToWorker.addEventListener(Event.CHANNEL_MESSAGE, _onMessageFromMain);

            _channelToMain.send("Worker started.");
        }

        private function _onMessageFromMain(event:Event):void {
            var data:* = event.target.receive();
            trace("[Main -> Worker] received:", data);
        }

    }
}
