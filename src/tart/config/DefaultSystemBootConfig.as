package tart.config {

    import tart.core.ISystemBootConfig;
    import tart.core.TartSystem;
    import tart.systems.ActorUpdateSystem;
    import tart.systems.DirectionSystem;
    import tart.systems.RenderSystem;

    public class DefaultSystemBootConfig implements ISystemBootConfig {

        //----------------------------------------------------------------------
        // implements ISystemBootConfig
        //----------------------------------------------------------------------

        public function onSystemInit(system:TartSystem):void {
            system.addSubSystems([
                 new DirectionSystem()
                ,new ActorUpdateSystem()
                ,new RenderSystem()
            ]);
        }

    }
}
