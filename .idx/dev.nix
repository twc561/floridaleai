
# To learn more about how to use Nix to configure your environment
# see: https://firebase.google.com/docs/studio/customize-workspace
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-24.05"; # or "unstable"
  # Use https://search.nixos.org/packages to find packages
  packages = [
    pkgs.jdk21
    pkgs.unzip
    pkgs.typesense
    pkgs.android-sdk
  ];
  # Sets environment variables in the workspace
  env = {
    TYPESENSE_API_KEY = "xyz";
    TYPESENSE_HOST = "localhost";
    TYPESENSE_PORT = "8108";
  };
  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      "Dart-Code.flutter"
      "Dart-Code.dart-code"
    ];
    workspace = {
      # Runs when a workspace is first created with this `dev.nix` file
      onCreate = {
        # Download the statutes data
        download-statutes = "wget -O statutes.jsonl.gz https://github.com/typesense/showcase-law-search/raw/master/data/statutes.jsonl.gz && gunzip statutes.jsonl.gz";
      };
      # To run something each time the workspace is (re)started, use the `onStart` hook
      onStart = {
        # Start the typesense server
        typesense = "typesense-server --data-dir .typesense-data --api-key=$TYPESENSE_API_KEY --listen-port=$TYPESENSE_PORT &";
      };
    };
    # Enable previews and customize configuration
    previews = {
      enable = true;
      previews = {
        web = {
          command = ["flutter" "run" "--machine" "-d" "web-server" "--web-hostname" "0.0.0.0" "--web-port" "$PORT"];
          manager = "flutter";
        };
        android = {
          command = ["flutter" "run" "--machine" "-d" "android" "-d" "localhost:5555"];
          manager = "flutter";
        };
      };
    };
  };
}
