# Marshal state machines

## `marshal`

```mermaid
{{#include state-machine-diagrams/marshal-main.mmd}}
```

{{#state-machine-spec ../../../ox/nodes/marshal/main.yue marshal}}

## `resource_orchestrator`

```mermaid
{{#include state-machine-diagrams/marshal-resource_orchestrator.mmd}}
```

{{#state-machine-spec ../../../ox/nodes/marshal/resource_orchestrator/main.yue resource_orchestrator}}

## `scheduler`

```mermaid
{{#include state-machine-diagrams/marshal-scheduler.mmd}}
```

{{#state-machine-spec ../../../ox/nodes/marshal/resource_orchestrator/scheduler.yue scheduler}}

## `schedule_generator`

```mermaid
{{#include state-machine-diagrams/marshal-schedule_generator.mmd}}
```

{{#state-machine-spec ../../../ox/nodes/marshal/resource_orchestrator/scheduler.yue schedule_generator}}

## `schedule_generator_impl`

```mermaid
{{#include state-machine-diagrams/marshal-schedule_generator_impl.mmd}}
```

{{#state-machine-spec ../../../ox/nodes/marshal/resource_orchestrator/scheduler.yue schedule_generator_impl}}

## `upgrade_listener`

```mermaid
{{#include state-machine-diagrams/upgrade_listener.mmd}}
```

{{#state-machine-spec ../../../ox/upgrade/listener.yue upgrade_listener}}

## `config_listener`

```mermaid
{{#include state-machine-diagrams/config_listener.mmd}}
```

{{#state-machine-spec ../../../ox/configurator/listener.yue config_listener}}
