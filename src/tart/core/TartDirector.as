package tart.core {

    public class TartDirector {

        private var _currentScene:TartScene;
        private var _globalChapter:TartChapter;

        public function TartDirector(firstScene:TartScene, globalChapter:TartChapter=null) {
            _currentScene  = firstScene;
            _globalChapter = globalChapter;
        }

    }
}
