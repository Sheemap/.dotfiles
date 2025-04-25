{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.openobserve-otel-agent;

  otel-cfg = pkgs.writeTextFile {
    name = "otel-config.yml";
    text = ''
      receivers:
        journald:
          directory: /var/log/journal
        filelog/std:
          include: [ /var/log/**log ]
          # start_at: beginning
        hostmetrics:
          root_path: /
          collection_interval: 30s
          scrapers:
            cpu:
            disk:
            filesystem:
            load:
            memory:
            network:
            paging:          
            processes:
            # process: # a bug in the process scraper causes the collector to throw errors so disabling it for now
      processors:
        resourcedetection/system:
          detectors: ["system"]
          system:
            hostname_sources: ["os"]
        memory_limiter:
          check_interval: 1s
          limit_percentage: 75
          spike_limit_percentage: 15
        batch:
          send_batch_size: 10000
          timeout: 10s

      extensions:
        zpages: {}

      # Put this part in /etc/nixos/openobserve-otel.yml
      # Dont have nix secrets setup still, and dont wanna commit secrets
      # exporters:
      #   otlphttp/openobserve:
      #     endpoint: $URL
      #     headers:
      #       Authorization: "Basic $AUTH_KEY"
      #   otlphttp/openobserve_journald:
      #     endpoint: $URL
      #     headers:
      #       Authorization: "Basic $AUTH_KEY"
      #       stream-name: journald

      service:
        extensions: [zpages]
        pipelines:
          metrics:
            receivers: [hostmetrics]
            processors: [resourcedetection/system, memory_limiter, batch]
            exporters: [otlphttp/openobserve]
          logs:
            receivers: [filelog/std]
            processors: [resourcedetection/system, memory_limiter, batch]
            exporters: [otlphttp/openobserve]
          logs/journald:
            receivers: [journald]
            processors: [resourcedetection/system, memory_limiter, batch]
            exporters: [otlphttp/openobserve_journald]
    '';

  };

in
{
  options = {
    openobserve-otel-agent.enable = lib.mkEnableOption "Enable Module";

    openobserve-otel-agent.extraConfigFile = lib.mkOption {
      type = lib.types.path;
      default = "/etc/nixos/openobserve-otel.yml";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.opentelemetry-collector = {
      enable = true;

      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.opentelemetry-collector-contrib}/bin/otelcol-contrib --config=file:${otel-cfg} --config=file:${cfg.extraConfigFile}";
        DynamicUser = true;
        Restart = "always";
        ProtectSystem = "full";
        DevicePolicy = "closed";
        NoNewPrivileges = true;
        WorkingDirectory = "%S/opentelemetry-collector";
        StateDirectory = "opentelemetry-collector";
        SupplementaryGroups = [
          # allow to read the systemd journal for opentelemetry-collector
          "systemd-journal"
        ];
      };

      restartIfChanged = true;
    };
  };
}
