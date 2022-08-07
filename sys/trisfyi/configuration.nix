{ pkgs, ... }:

{
  imports = [
    ./generated.nix
    ../modules/common.nix

    # FIXME - make amethyst work as flake and bring back in
    # "${amethyst}/module.nix"
  ];

  networking.hostName = "trisfyi";
  time.timeZone = "Etc/UTC";

  # GRUB is bootloader - FIXME -> modules/server.nix
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";

  # Networking - static addressing
  networking.nameservers = [
    "2001:4860:4860::8888"
    "2001:4860:4860::8844"
    "199.195.255.68"
    "199.195.255.69"
  ];

  networking.interfaces.ens3 = {
    useDHCP = false;

    ipv4 = {
      addresses = [{
        address = "198.98.62.59";
        prefixLength = 24;
      }];
      routes = [{
        address = "0.0.0.0";
        prefixLength = 0;
        via = "198.98.62.1";
      }];
    };

    ipv6 = {
      addresses = [{
        address = "2605:6400:10:0ed9::1";
        prefixLength = 48;
      }];
      routes = [{
        address = "::";
        prefixLength = 0;
        via = "2605:6400:10::1";
      }];
    };
  };

  # Amethyst configuration
  # services.amethyst = {
  #   enable = true;
  #   hosts = [
  #     {
  #       name = "gemini.tris.fyi";
  #       paths."/" = {
  #         type = "redirect";
  #         to = "gemini://tris.fyi";
  #       };
  #     }
  #     {
  #       name = "tris.fyi";
  #       paths = {
  #         "/" = {
  #           root = "/var/gemini";
  #           autoindex = true;
  #           cgi = false;
  #         };
  #         "/cgi-bin/" = {
  #           root = "/var/gemini/cgi-bin";
  #           autoindex = false;
  #           cgi = true;
  #         };
  #         "/pydoc/".type = "pydoc";
  #       };
  #     }
  #   ];
  # };

  # systemd.services.amethyst.path = [
  #   (pkgs.python39.withPackages (p: with p; [
  #     requests
  #   ]))
  # ];

  # Web server configuration
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "acme-admin@tris.fyi";

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;

    virtualHosts."tris.fyi" = {
      forceSSL = true;
      enableACME = true;
      serverAliases = [ "www.tris.fyi" ];
      locations."/" = {
        root = "/var/www";
      };
    };
    virtualHosts."f.tris.fyi" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        root = "/var/www/f";
      };
    };

    virtualHosts."grocy.tris.fyi" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://[fdee:d21b:6b8b:ef00::2]";
      };
    };

    virtualHosts."wordgame.ircpuzzles.org" = {
      forceSSL = false;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8082";
      };
    };
  };

  # XMPP
  security.acme.certs.xmpp = {
    domain = "tris.fyi";
    extraDomainNames = [
      "conference.xmpp.tris.fyi"
      "upload.xmpp.tris.fyi"
    ];

    dnsProvider = "route53";
    credentialsFile = "/var/lib/secrets/route53";

    group = "prosody";
  };

  services.prosody = let
    ssl = {
      cert = "/var/lib/acme/xmpp/fullchain.pem";
      key = "/var/lib/acme/xmpp/key.pem";
    };
  in {
    enable = true;
    admins = [ "tris@tris.fyi" ];

    inherit ssl;

    virtualHosts."tris.fyi" = {
      enabled = true;
      domain = "tris.fyi";

      inherit ssl;
    };

    muc = [{
      domain = "conference.xmpp.tris.fyi";
    }];

    uploadHttp = {
      domain = "upload.xmpp.tris.fyi";
    };
  };

  # Grocy
  containers.grocy = {
    autoStart = true;

    privateNetwork = true;
    hostAddress6 = "fdee:d21b:6b8b:ef00::1";
    localAddress6 = "fdee:d21b:6b8b:ef00::2";

    bindMounts."/var/lib/grocy" =  {
      hostPath = "/srv/container/grocy/grocy";
      isReadOnly = false;
    };

    config = { config, pkgs, ... }: {
      services.grocy = {
        enable = true;
        hostName = "grocy.tris.fyi";
        nginx.enableSSL = false;
        phpfpm.settings = {
          "pm" = "dynamic";
          "php_admin_value[error_log]" = "stderr";
          "php_admin_flag[log_errors]" = true;
          "listen.owner" = "nginx";
          "catch_workers_output" = true;
          "pm.max_children" = "32";
          "pm.start_servers" = "2";
          "pm.min_spare_servers" = "2";
          "pm.max_spare_servers" = "4";
          "pm.max_requests" = "500";
          "php_admin_value[date.timezone]" = "America/Chicago";
        };

      };
      system.stateVersion = "21.11";
    };
  };

  # taskd
  services.taskserver = {
    enable = true;
    fqdn = "taskserver.trisfyi.tris.fyi";
    listenHost = "0.0.0.0";
    organisations.trisfyi.users = [ "tris" ];
  };

  # Firewall configuration
  networking.firewall.allowedTCPPorts = [
    80    # HTTP
    443   # HTTPS
    1965  # Gemini
    53589 # taskd

    5000 5222 5269 5280 5281 # XMPP services
  ];

  system.stateVersion = "21.11";
}
