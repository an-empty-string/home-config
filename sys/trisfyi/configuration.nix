{ pkgs, ... }:

{
  imports = [
    ./generated.nix
    ../modules/common.nix
    ../modules/server.nix

    # FIXME - make amethyst work as flake and bring back in
    # "${amethyst}/module.nix"
  ];

  networking.hostName = "trisfyi";
  time.timeZone = "Etc/UTC";

  # GRUB is bootloader - FIXME -> modules/server.nix
  boot.loader.grub.enable = true;
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

  virtualisation.docker.enable = true;

  services.postgresql = {
    enable = true;
    dataDir = "/data/postgres/15";
    package = pkgs.postgresql_15;
    enableTCPIP = true;
    ensureDatabases = [ "maps" ];
    ensureUsers = [{
      name = "tris";
      ensureClauses.superuser = true;
    }];
    extraPlugins = [
      pkgs.postgresql_15.pkgs.postgis
    ];
    authentication = ''
      host all tris 100.64.0.0/10 md5
      host all ally 100.64.0.0/10 md5
    '';
  };

  # Amethyst configuration
  services.amethyst = {
    enable = true;
    hosts = [
      {
        name = "tris.fyi";
        tls = "auto";
        paths = {
          "/" = {
            root = "/var/gemini";
            cgi = true;
          };
        };
      }
    ];
  # };

  systemd.services.amethyst.path = [
    (pkgs.python311.withPackages (p: with p; [
      requests
    ]))
  ];

  # Web server configuration
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "acme-admin@tris.fyi";

  services.nginx = {
    enable = true;
    clientMaxBodySize = "64m";
    proxyTimeout = "300s";
    recommendedTlsSettings = true;
    recommendedProxySettings = true;

    virtualHosts."maps.swaynefor55.com" = {
      forceSSL = true;
      enableACME = true;

      locations."/" = {
        root = "/var/www/d55-map";
      };

      locations."/districts/" = {
        proxyPass = "http://127.0.0.1:8089/v1/";
        extraConfig = ''
          if ($request_method = 'OPTIONS') {
            add_header 'Access-Control-Allow-Origin' '*';
            add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
            add_header 'Access-Control-Max-Age' 1728000;
            return 204;
         }

        add_header X-Clacks-Overhead "GNU Kathryn Jeannette Wilson";
        add_header 'Access-Control-Allow-Origin' '*';
        add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
        '';
      };

    };

    virtualHosts."tris.fyi" = {
      forceSSL = true;
      enableACME = true;
      serverAliases = [ "www.tris.fyi" ];
      extraConfig = ''
        add_header X-Clacks-Overhead "GNU Kathryn Jeannette Wilson";
      '';
      locations."/" = {
        root = "/var/www";
      };

      locations."/districts/" = {
        proxyPass = "http://127.0.0.1:8089/v1/";
        extraConfig = ''
          if ($request_method = 'OPTIONS') {
            add_header 'Access-Control-Allow-Origin' '*';
            add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
            add_header 'Access-Control-Max-Age' 1728000;
            return 204;
         }

        add_header X-Clacks-Overhead "GNU Kathryn Jeannette Wilson";
        add_header 'Access-Control-Allow-Origin' '*';
        add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
        '';
      };

      locations."/content" = {
        extraConfig = ''
          dav_methods PUT;
          dav_access user:rw group:rw all:r;

          limit_except GET {
            deny all;

            auth_basic_user_file /etc/content.htpasswd;
            auth_basic "authenticate to upload content";
          }
        '';
      };
    };

    virtualHosts."f.tris.fyi" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        root = "/var/www/f";
      };
    };

    virtualHosts."districts.socialism.gay" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8089";
        extraConfig = ''
          if ($request_method = 'OPTIONS') {
            add_header 'Access-Control-Allow-Origin' '*';
            add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
            add_header 'Access-Control-Max-Age' 1728000;
            return 204;
         }

        add_header X-Clacks-Overhead "GNU Kathryn Jeannette Wilson";
        add_header 'Access-Control-Allow-Origin' '*';
        add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
        '';
      };
    };

    virtualHosts."walk.tris.fyi" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "https://127.0.0.1:3030";
      };
    };

    virtualHosts."wiki.tris.fyi" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://[fdee:d21b:6b8b:ef01::2]:4567";
      };
      locations."/FieldNotes/LegalName" = {
        extraConfig = ''
          return 302 https://tris.fyi/legal_name.html;
        '';
      };
    };

    virtualHosts."social.tris.fyi" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8000";
        extraConfig = ''
          proxy_set_header X-Forwarded-Proto "https";
        '';
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

  security.acme.certs.mqtt = {
    domain = "mqtt.tris.fyi";

    dnsProvider = "route53";
    credentialsFile = "/var/lib/secrets/route53";

    group = "mosquitto";
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

  containers.wiki = {
    autoStart = true;
    privateNetwork = true;
    hostAddress6 = "fdee:d21b:6b8b:ef01::1";
    localAddress6 = "fdee:d21b:6b8b:ef01::2";

    bindMounts."/var/lib/gollum" = {
      hostPath = "/var/www/wiki";
      isReadOnly = false;
    };

    config = { config, pkgs, lib, ... }: {
      services.gollum.enable = true;

      systemd.services.gollum.serviceConfig.ExecStart =
        lib.mkForce ''
          ${pkgs.gollum}/bin/gollum \
            --port 4567 --host :: --ref main \
            --no-edit --emoji --css --h1-title --mathjax \
            /var/lib/gollum
        '';

      systemd.services.gollum.path = [
        pkgs.git
        pkgs.python310Packages.pygments
      ];

      networking.firewall.allowedTCPPorts = [ 4567 ];

      system.stateVersion = "22.05";
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
    22    # SSH
    80    # HTTP
    443   # HTTPS
    1965  # Gemini
    8883  # MQTT
    53589 # taskd

    5000 5222 5269 5280 5281 # XMPP services
  ];

  # MQTT service
  services.mosquitto.listeners = [
    {
      port = 8883;
      settings = {
        certfile = "/var/lib/acme/mqtt/fullchain.pem";
        keyfile = "/var/lib/acme/mqtt/key.pem";
      };
      users.tris = {
        hashedPassword = "$7$101$/jCzIEtktLk/BM4Z$uZDPCk1Uh8U5w5F3mJPzboC/CrQoWY63PpfF6O4kBPtklsv8/U3R4itREKAFjEc+t/vwdrh8J5eQnAV1IBKcRA==";
        acl = [ "readwrite #" ];
      };
    }
  ];

  system.stateVersion = "21.11";
}
