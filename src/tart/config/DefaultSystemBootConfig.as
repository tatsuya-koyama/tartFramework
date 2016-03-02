package tart.config {

    import tart.core.ISystemBootConfig;
    import tart.core.TartSystem;
    import tart.systems.DirectionSystem;

    public class DefaultSystemBootConfig implements ISystemBootConfig {

        //----------------------------------------------------------------------
        // implements ISystemBootConfig
        //----------------------------------------------------------------------

        public function onSystemInit(system:TartSystem):void {
            system.addSubSystems([
                new DirectionSystem()
            ]);
        }

    }
}
