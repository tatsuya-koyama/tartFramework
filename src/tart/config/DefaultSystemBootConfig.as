package tart.config {

    import tart.core.ISystemBootConfig;
    import tart.core.TartSystem;
    import tart.systems.ActorDestroySystem;
    import tart.systems.ActorUpdateSystem;
    import tart.systems.DirectionSystem;
    import tart.systems.KeyInputHandlingSystem;
    import tart.systems.NewActorRegisterSystem;
    import tart.systems.RenderSystem;
    import tart.systems.TouchHandlingSystem;

    public class DefaultSystemBootConfig implements ISystemBootConfig {

        //----------------------------------------------------------------------
        // implements ISystemBootConfig
        //----------------------------------------------------------------------

        public function onSystemInit(system:TartSystem):void {
            system.addSubSystems([
                 new DirectionSystem()
                ,new KeyInputHandlingSystem()
                ,new TouchHandlingSystem()
                ,new ActorUpdateSystem()
                ,new ActorDestroySystem()
                ,new NewActorRegisterSystem()
                ,new RenderSystem()
            ]);
        }

    }
}
