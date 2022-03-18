# ``ExampleScreen``

This mmodule contains example of "average" application screen.

## Overview

Each screen contains:

``Assembler`` --> [``Controller`` <-> ``Presenter`` <--> `MessageBus` <--> ``Service``]

You can use this module as a reference for writing your own modules.

Also it's allowed to split a component on more components. For example you can split ``Presenter`` on 2 or more classes to enrich SRP
