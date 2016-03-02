package tart.core {

    import tart.config.DefaultSystemBootConfig;

    public class TartSystem {

        private var _tartContext:TartContext;
        private var _subSystems:Vector.<TartSubSystem>;

        public function TartSystem(tartContext:TartContext) {
            _tartContext = tartContext;
            _subSystems  = new Vector.<TartSubSystem>();
        }

        //----------------------------------------------------------------------
        // public
        //----------------------------------------------------------------------

        public function init(bootConfig:ISystemBootConfig):void {
            bootConfig = bootConfig || new DefaultSystemBootConfig();
            bootConfig.onSystemInit(this);
        }

        public function addSubSystem(subSystem:TartSubSystem, priority:int=0, sort:Boolean=true):void {
            subSystem.tartContext = _tartContext;
            subSystem.priority    = priority;
            _subSystems.push(subSystem);

            if (sort) {
                _subSystems.sort(_comparePriorityDesc);
            }
            TART::LOG_DEBUG {
                trace("[Debug :: TartSystem] addSubSystem :", subSystem.priority, "-", subSystem.name);
            }
        }

        /**
         * Add multiple sub-systems at once.
         * @param subSystems - First element has high priority.
         */
        public function addSubSystems(subSystems:Array, priority:int=0):void {
            for each (var subSystem:TartSubSystem in subSystems) {
                addSubSystem(subSystem, priority, false);
            }
            _subSystems.sort(_comparePriorityDesc);
        }

        public function process(deltaTime:Number):void {
            for each (var subSystem:TartSubSystem in _subSystems) {
                subSystem.process(deltaTime);
            }
        }

        //----------------------------------------------------------------------
        // private
        //----------------------------------------------------------------------

        private function _comparePriorityDesc(a:TartSubSystem, b:TartSubSystem):int {
            if (a.priority > b.priority) { return -1; }
            if (a.priority < b.priority) { return 1; }
            return 0;
        }

    }
}
