package tests.dessert_knife.tools {

    import org.hamcrest.assertThat;
    import org.hamcrest.core.throws;
    import org.hamcrest.object.equalTo;
    import org.hamcrest.object.instanceOf;

    import dessert_knife.knife;
    import dessert_knife.tools.Async;

    public class AsyncTests {

        [Test]
        public function test_invalidInitObject_1():void {
            assertThat(function():void {
                var async:Async = new Async({
                    single: function(async:Async):void {},
                    serial: function(async:Async):void {}
                });
            }, throws(instanceOf(Error)));
        }

        [Test]
        public function test_invalidInitObject_2():void {
            assertThat(function():void {
                var async:Async = new Async({
                    serial  : function(async:Async):void {},
                    parallel: function(async:Async):void {}
                });
            }, throws(instanceOf(Error)));
        }

        [Test]
        public function test_invalidInitObject_3():void {
            assertThat(function():void {
                var async:Async = new Async({
                    single  : function(async:Async):void {},
                    parallel: function(async:Async):void {}
                });
            }, throws(instanceOf(Error)));
        }

        [Test]
        public function test_invalidInitObject_4():void {
            assertThat(function():void {
                var async:Async = new Async({});
            }, throws(instanceOf(Error)));
        }

        [Test]
        public function test_single():void {
            var trail:String = "";

            var async:Async = new Async({
                single: function(async:Async):void {
                    trail += "a";
                }
            });
            async.go();

            assertThat("a", equalTo(trail));
        }

        [Test]
        public function test_serial_success():void {
            var trail:String = "";

            var async:Async = new Async({
                serial: [
                    function(async:Async):void {
                        trail += "a";
                        async.done();
                    },
                    function(async:Async):void {
                        trail += "b";
                        async.done();
                    },
                    function(async:Async):void {
                        trail += "c";
                        async.done();
                    }
                ],
                success: function():void { trail += "s"; }
            });
            async.go();

            assertThat("abcs", equalTo(trail));
        }

        [Test]
        public function test_serial_success_2():void {
            var trail:String = "";

            var async:Async = new Async({
                serial: [
                    function(async:Async):void {
                        trail += "a";
                        async.done();
                    },
                    function(async:Async):void {
                        trail += "b";
                        async.done();
                    },
                    {
                        serial: [
                            function(async:Async):void {
                                trail += "A";
                                async.done();
                            },
                            function(async:Async):void {
                                trail += "B";
                                async.done();
                            }
                        ],
                        success: function():void { trail += "s1"; },
                        anyway: function():void {
                            trail += "w1"
                        }
                    },
                    function(async:Async):void {
                        trail += "c";
                        async.done();
                    }
                ],
                success: function():void { trail += "s2"; },
                anyway: function():void {
                    trail += "w2";
                }
            });
            async.go();

            assertThat("abABs1w1cs2w2", equalTo(trail));
        }

        [Test]
        public function test_serial_fail():void {
            var trail:String = "";

            var async:Async = new Async({
                serial: [
                    function(async:Async):void {
                        trail += "a";
                        async.done();
                    },
                    function(async:Async):void {
                        trail += "b";
                        async.fail();
                    },
                    function(async:Async):void {
                        trail += "c";
                        async.done();
                    }
                ],
                success: function():void { trail += "s"; },
                error: function():void {
                    trail += "_e_"
                },
                anyway: function():void {
                    trail += "_a_"
                }
            });
            async.go();

            assertThat("ab_e__a_", equalTo(trail));
        }

        [Test]
        public function test_serial_fail_2():void {
            var trail:String = "";

            var async:Async = new Async({
                serial: [
                    function(async:Async):void {
                        trail += "a";
                        async.done();
                    },
                    function(async:Async):void {
                        trail += "b";
                        async.done();
                    },
                    {
                        serial: [
                            function(async:Async):void {
                                trail += "A";
                                async.fail();
                            },
                            function(async:Async):void {
                                trail += "B";
                                async.done();
                            }
                        ],
                        success: function():void { trail += "s1"; },
                        error: function():void {
                            trail += "E";
                        },
                        anyway: function():void {
                            trail += "W";
                        }
                    },
                    function(async:Async):void {
                        trail += "c";
                        async.done();
                    }
                ],
                success: function():void { trail += "s2"; },
                error: function():void {
                    trail += "e"
                },
                anyway: function():void {
                    trail += "w"
                }
            });
            async.go();

            assertThat("abAEWew", equalTo(trail));
        }

        [Test]
        public function test_serial_from_array():void {
            var trail:String = "";

            var async:Async = new Async([
                function(async:Async):void {
                    trail += "d";
                    async.done();
                },
                function(async:Async):void {
                    trail += "e";
                    async.done();
                },
                function(async:Async):void {
                    trail += "f";
                    async.done();
                }
            ]);
            async.go();

            assertThat("def", equalTo(trail));
        }

        [Test]
        public function test_parallel_success():void {
            var trail:String = "";
            var onTickHandlers:Array = [];

            var async:Async = new Async({
                parallel: [
                    function(async:Async):void {
                        onTickHandlers.push(function(count:int):void {
                            if (count == 5) {
                                trail += "a";
                                async.done();
                            }
                        });
                    },
                    function(async:Async):void {
                        onTickHandlers.push(function(count:int):void {
                            if (count == 13) {
                                trail += "b";
                                async.done();
                            }
                        });
                    },
                    function(async:Async):void {
                        onTickHandlers.push(function(count:int):void {
                            if (count == 8) {
                                trail += "c";
                                async.done();
                            }
                        });
                    }
                ],
                success: function():void { trail += "s"; },
                anyway: function():void {
                    trail += "d";
                }
            });
            async.go(function():void {
                trail += "e";
            });

            for (var i:int = 0;  i < 20;  ++i) {
                for each (var handler:Function in onTickHandlers) {
                    handler(i);
                }
            }

            assertThat("acbsde", equalTo(trail));
        }

        [Test]
        public function test_parallel_success_2():void {
            var trail:String = "";
            var onTickHandlers:Array = [];

            var async:Async = new Async({
                parallel: [
                    function(async:Async):void {
                        onTickHandlers.push(function(count:int):void {
                            if (count == 7) { trail += "a";  async.done(); }
                        });
                    },
                    function(async:Async):void {
                        onTickHandlers.push(function(count:int):void {
                            if (count == 18) { trail += "b";  async.done(); }
                        });
                    },
                    {
                        parallel: [
                            function(async:Async):void {
                                onTickHandlers.push(function(count:int):void {
                                    if (count == 4) { trail += "c";  async.done(); }
                                });
                            },
                            function(async:Async):void {
                                onTickHandlers.push(function(count:int):void {
                                    if (count == 16) { trail += "d";  async.done(); }
                                });
                            }
                        ],
                        success: function():void { trail += "s1"; },
                        anyway: function():void {
                            trail += "e";
                        }
                    },
                    function(async:Async):void {
                        onTickHandlers.push(function(count:int):void {
                            if (count == 8) { trail += "f";  async.done(); }
                        });
                    }
                ],
                success: function():void { trail += "s2"; },
                anyway: function():void {
                    trail += "g";
                }
            });
            async.go(function():void {
                trail += "h";
            });

            for (var i:int = 0;  i < 20;  ++i) {
                for each (var handler:Function in onTickHandlers) {
                    handler(i);
                }
            }

            assertThat("cafds1ebs2gh", equalTo(trail));
        }

        [Test]
        public function test_parallel_fail_1():void {
            var trail:String = "";
            var onTickHandlers:Array = [];

            var async:Async = new Async({
                parallel: [
                    function(async:Async):void {
                        onTickHandlers.push(function(count:int):void {
                            if (count == 7) { trail += "a";  async.done(); }
                        });
                    },
                    function(async:Async):void {
                        onTickHandlers.push(function(count:int):void {
                            if (count == 18) { trail += "b";  async.done(); }
                        });
                    },
                    {
                        parallel: [
                            function(async:Async):void {
                                onTickHandlers.push(function(count:int):void {
                                    if (count == 4) { trail += "c";  async.done(); }
                                });
                            },
                            function(async:Async):void {
                                onTickHandlers.push(function(count:int):void {
                                    if (count == 16) { trail += "d";  async.fail(); }
                                });
                            }
                        ],
                        success: function():void { trail += "s1"; },
                        error: function():void {
                            trail += "E1";
                        },
                        anyway: function():void {
                            trail += "e";
                        }
                    },
                    function(async:Async):void {
                        onTickHandlers.push(function(count:int):void {
                            if (count == 8) { trail += "f";  async.done(); }
                        });
                    }
                ],
                success: function():void { trail += "s2"; },
                error: function():void {
                    trail += "E2";
                },
                anyway: function():void {
                    trail += "g";
                }
            });
            async.go(function():void {
                trail += "h";
            });

            for (var i:int = 0;  i < 20;  ++i) {
                for each (var handler:Function in onTickHandlers) {
                    handler(i);
                }
            }

            assertThat("cafdE1eE2ghb", equalTo(trail));
        }

        [Test]
        public function test_parallel_fail_2():void {
            var trail:String = "";
            var onTickHandlers:Array = [];

            var async:Async = new Async({
                parallel: [
                    function(async:Async):void {
                        onTickHandlers.push(function(count:int):void {
                            if (count == 3) { trail += "a";  async.done(); }
                        });
                    },
                    function(async:Async):void {
                        onTickHandlers.push(function(count:int):void {
                            if (count == 19) { trail += "b";  async.done(); }
                        });
                    },
                    {
                        parallel: [
                            function(async:Async):void {
                                onTickHandlers.push(function(count:int):void {
                                    if (count == 15) { trail += "c";  async.fail(); }
                                });
                            },
                            function(async:Async):void {
                                onTickHandlers.push(function(count:int):void {
                                    if (count == 6) { trail += "d";  async.fail(); }
                                });
                            }
                        ],
                        success: function():void { trail += "s1"; },
                        error : function():void { trail += "E1"; },
                        anyway: function():void { trail += "e"; }
                    },
                    function(async:Async):void {
                        onTickHandlers.push(function(count:int):void {
                            if (count == 9) { trail += "f";  async.done(); }
                        });
                    }
                ],
                success: function():void { trail += "s2"; },
                error : function():void { trail += "E2"; },
                anyway: function():void { trail += "g"; }
            });
            async.go(function():void {
                trail += "h";
            });

            for (var i:int = 0;  i < 20;  ++i) {
                for each (var handler:Function in onTickHandlers) {
                    handler(i);
                }
            }

            assertThat("adE1eE2ghfcb", equalTo(trail));
        }

        [Test]
        public function test_serial_and_parallel_1():void {
            var trail:String = "";
            var onTickHandlers:Array = [];

            /**
             *             |3 -------->|
             *             |           |
             *   1 -> 2 -> |4 --->.....| -> 7 -> anyway
             *             |           |
             *             |5 -> 6 ->..|
             */
            var async:Async = new Async({
                serial: [
                    function(async:Async):void {
                        trail += "1";  async.done();
                    },
                    function(async:Async):void {
                        trail += "2";  async.done();
                    },
                    {
                        parallel: [
                            function(async:Async):void {
                                onTickHandlers.push(function(count:int):void {
                                    if (count == 9) { trail += "3";  async.done(); }
                                });
                            },
                            function(async:Async):void {
                                onTickHandlers.push(function(count:int):void {
                                    if (count == 5) { trail += "4";  async.done(); }
                                });
                            },
                            {
                                serial: [
                                    function(async:Async):void {
                                        onTickHandlers.push(function(count:int):void {
                                            if (count == 3) { trail += "5";  async.done(); }
                                        });
                                    },
                                    function(async:Async):void {
                                        trail += "_";
                                        onTickHandlers.push(function(count:int):void {
                                            if (count == 7) { trail += "6";  async.done(); }
                                        });
                                    }
                                ]
                            }
                        ]
                    },
                    function(async:Async):void {
                        trail += "7";  async.done();
                    }
                ],
                anyway: function():void {
                    trail += "a";
                }
            });
            async.go(function():void {
                trail += "!";
            });

            for (var i:int = 0;  i < 10;  ++i) {
                for each (var handler:Function in onTickHandlers) {
                    handler(i);
                }
            }

            assertThat("125_4637a!", equalTo(trail));
        }

        [Test]
        public function test_serial_and_parallel_1_fail():void {
            var trail:String = "";
            var onTickHandlers:Array = [];

            /**
             *             |3 -------->|
             *             |           |
             *   1 -> 2 -> |4 ---[!]...| -> 7 -> anyway
             *             |           |
             *             |5 -> 6 ->..|
             */
            var async:Async = new Async({
                serial: [
                    function(async:Async):void {
                        trail += "1";  async.done();
                    },
                    function(async:Async):void {
                        trail += "2";  async.done();
                    },
                    {
                        parallel: [
                            function(async:Async):void {
                                onTickHandlers.push(function(count:int):void {
                                    if (count == 9) { trail += "3";  async.done(); }
                                });
                            },
                            function(async:Async):void {
                                onTickHandlers.push(function(count:int):void {
                                    if (count == 5) { trail += "4";  async.fail(); }
                                });
                            },
                            {
                                serial: [
                                    function(async:Async):void {
                                        onTickHandlers.push(function(count:int):void {
                                            if (count == 3) { trail += "5";  async.done(); }
                                        });
                                    },
                                    function(async:Async):void {
                                        trail += "_";
                                        onTickHandlers.push(function(count:int):void {
                                            if (count == 7) { trail += "6";  async.done(); }
                                        });
                                    }
                                ]
                            }
                        ],
                        error: function():void {
                            trail += "E1";
                        }
                    },
                    function(async:Async):void {
                        trail += "7";  async.done();
                    }
                ],
                error: function():void {
                    trail += "E2";
                },
                anyway: function():void {
                    trail += "a";
                }
            });
            async.go(function():void {
                trail += "!";
            });

            for (var i:int = 0;  i < 10;  ++i) {
                for each (var handler:Function in onTickHandlers) {
                    handler(i);
                }
            }

            assertThat("125_4E1E2a!63", equalTo(trail));
        }

        [Test]
        public function test_serial_and_parallel_2():void {
            var trail:String = "";
            var onTickHandlers:Array = [];

            /**
             *   1 -> 2 -> |3 --->.....| -> 6
             *             |           |
             *             |4 -> 5 ->..|
             */
            var async:Async = new Async([
                function(async:Async):void {
                    trail += "1";  async.done();
                },
                function(async:Async):void {
                    trail += "2";  async.done();
                },
                {
                    parallel: [
                        function(async:Async):void {
                            onTickHandlers.push(function(count:int):void {
                                if (count == 9) { trail += "3";  async.done(); }
                            });
                        },
                        [
                            function(async:Async):void {
                                trail += "4";  async.done();
                            },
                            function(async:Async):void {
                                trail += "5";  async.done();
                            }
                        ]
                    ]
                },
                function(async:Async):void {
                    trail += "6";  async.done();
                }
            ]);
            async.go();

            for (var i:int = 0;  i < 10;  ++i) {
                for each (var handler:Function in onTickHandlers) {
                    handler(i);
                }
            }

            assertThat("124536", equalTo(trail));
        }

        [Test]
        public function test_serial_and_parallel_2_fail():void {
            var trail:String = "";
            var onTickHandlers:Array = [];

            /**
             *   1 -> 2 -> |3 -------[!] | -> 6
             *             |             |
             *             |4 -> 5 ->....|
             */
            var async:Async = new Async({
                serial: [
                    function(async:Async):void { trail += "1";  async.done(); },
                    function(async:Async):void { trail += "2";  async.done(); },
                    {
                        parallel: [
                            function(async:Async):void {
                                onTickHandlers.push(function(count:int):void {
                                    if (count == 9) { trail += "3";  async.fail(); }
                                });
                            },
                            {
                                serial: [
                                    function(async:Async):void { trail += "4";  async.done(); },
                                    function(async:Async):void { trail += "5";  async.done(); }
                                ],
                                success: function():void { trail += "s1"; },
                                error: function():void { trail += "E1"; }
                            }
                        ],
                        success: function():void { trail += "s2"; },
                        error: function():void { trail += "E2"; }
                    },
                    function(async:Async):void {
                        trail += "6";  async.done();
                    }
                ],
                success: function():void { trail += "s3"; },
                error: function():void { trail += "E3"; }
            });
            async.go();

            for (var i:int = 0;  i < 10;  ++i) {
                for each (var handler:Function in onTickHandlers) {
                    handler(i);
                }
            }

            assertThat("1245s13E2E3", equalTo(trail));
        }

        [Test]
        public function test_serial_and_parallel_with_class():void {
            var trail:Array = [];
            var onTickHandlers:Array = [];

            /**
             *             |3 -------->|
             *             |           |
             *   1 -> 2 -> |4 --->.....| -> 7 -> anyway
             *             |           |
             *             |5 -> 6 ->..|
             */
            var async:Async = new Async({
                serial: [
                    function(async:Async):void {
                        trail.push("1");  async.done();
                    },
                    function(async:Async):void {
                        trail.push("2");  async.done();
                    },

                    new MyAsync(onTickHandlers, trail),

                    function(async:Async):void {
                        trail.push("7");  async.done();
                    }
                ],
                anyway: function():void {
                    trail.push("a");
                }
            });
            async.go(function():void {
                trail.push("!");
            });

            for (var i:int = 0;  i < 10;  ++i) {
                for each (var handler:Function in onTickHandlers) {
                    handler(i);
                }
            }

            assertThat("12[5]_[4][6][3]7a!", equalTo(trail.join('')));
        }

        [Test]
        public function test_with_knife():void {
            var trail:Array = [];
            var onTickHandlers:Array = [];

            /**
             *             |3 -------->|
             *             |           |
             *   1 -> 2 -> |4 --->.....| -> 7 -> anyway
             *             |           |
             *             |5 -> 6 ->..|
             */
            knife.async({
                serial: [
                    function(async:Async):void {
                        trail.push("1");  async.done();
                    },
                    function(async:Async):void {
                        trail.push("2");  async.done();
                    },

                    new MyAsync(onTickHandlers, trail),

                    function(async:Async):void {
                        trail.push("7");  async.done();
                    }
                ],
                anyway: function():void {
                    trail.push("a");
                }
            }, function():void {
                trail.push("!!!");
            });

            for (var i:int = 0;  i < 10;  ++i) {
                for each (var handler:Function in onTickHandlers) {
                    handler(i);
                }
            }

            assertThat("12[5]_[4][6][3]7a!!!", equalTo(trail.join('')));
        }

    }
}



import dessert_knife.tools.Async;

class MyAsync extends Async {
    public function MyAsync(onTickHandlers:Array, trail:Array) {
        super({
            parallel: [
                function(async:Async):void {
                    onTickHandlers.push(function(count:int):void {
                        if (count == 9) { trail.push("[3]");  async.done(); }
                    });
                },
                function(async:Async):void {
                    onTickHandlers.push(function(count:int):void {
                        if (count == 5) { trail.push("[4]");  async.done(); }
                    });
                },
                {
                    serial: [
                        function(async:Async):void {
                            onTickHandlers.push(function(count:int):void {
                                if (count == 3) { trail.push("[5]");  async.done(); }
                            });
                        },
                        function(async:Async):void {
                            trail.push("_");
                            onTickHandlers.push(function(count:int):void {
                                if (count == 7) { trail.push("[6]");  async.done(); }
                            });
                        }
                    ]
                }
            ]
        });
    }
}
