package tart.core {

    public class TartDirector {

        private var _currentScene:TartScene;

        public function TartDirector(firstScene:TartScene) {
            _currentScene = firstScene;
        }

    }
}
