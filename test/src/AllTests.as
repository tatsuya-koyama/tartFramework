package {

    import tests.SampleTests;
    import tests.dessert_knife.KnifeTests;
    import tests.dessert_knife.blades.FunctionKnifeTests;
    import tests.dessert_knife.blades.RandomKnifeTests;
    import tests.dessert_knife.blades.StringKnifeTests;
    import tests.dessert_knife.tools.async.AwaitTests;
    import tests.dessert_knife.tools.async.AsyncTests;
    import tests.dessert_knife.tools.async.DeferTests;
    import tests.dessert_knife.tools.async.DeferredTests;
    import tests.dessert_knife.tools.async.PromiseTests;
    import tests.dessert_knife.tools.signal.MessageChannelTests;
    import tests.dessert_knife.tools.signal.SignalTests;

    [Suite]
    public class AllTests {

        public var sampleTests:SampleTests;
        public var knife_knifeTests:KnifeTests;
        public var knife_blades_functionKnifeTests:FunctionKnifeTests;
        public var knife_blades_randomKnifeTests:RandomKnifeTests;
        public var knife_blades_stringKnifeTests:StringKnifeTests;
        public var knife_tools_awaitTests:AwaitTests;
        public var knife_tools_asyncTests:AsyncTests;
        public var knife_tools_deferTests:DeferTests;
        public var knife_tools_deferredTests:DeferredTests;
        public var knife_tools_promiseTests:PromiseTests;
        public var knife_tools_messageChannelTests:MessageChannelTests;
        public var knife_tools_signalTests:SignalTests;

    }
}
