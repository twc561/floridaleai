# Flutter + Android Emulator + Typesense for Firebase Studio Cloud
{ pkgs, ... }: {

  packages = [
    pkgs.jdk21
    pkgs.unzip
    pkgs.typesense
    pkgs.flutter
    pkgs.android-tools      # adb, fastboot
    pkgs.emscripten         # web build
    pkgs.wget
  ];

  env = {
    TYPESENSE_API_KEY = "xyz";
    TYPESENSE_HOST = "localhost";
    TYPESENSE_PORT = "8108";
    # no ANDROID_SDK_ROOT here, avoids conflict
  };

  idx = {
    extensions = [
      "Dart-Code.flutter"
      "Dart-Code.dart-code"
    ];

    workspace = {
      onCreate = {
        flutter-doctor = "flutter doctor -v";

        download-statutes = "wget -O statutes.jsonl.gz https://github.com/typesense/showcase-law-search/raw/master/data/statutes.jsonl.gz && gunzip statutes.jsonl.gz";

        setup-android = ''
          export ANDROID_HOME=$HOME/android-sdk
          mkdir -p $ANDROID_HOME/cmdline-tools
          cd $ANDROID_HOME
          wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O cmdline-tools.zip
          unzip cmdline-tools.zip -d $ANDROID_HOME/cmdline-tools
          mv $ANDROID_HOME/cmdline-tools/cmdline-tools $ANDROID_HOME/cmdline-tools/bin
          rm cmdline-tools.zip

          export PATH=$ANDROID_HOME/cmdline-tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH

          yes | $ANDROID_HOME/cmdline-tools/bin/sdkmanager --licenses
          $ANDROID_HOME/cmdline-tools/bin/sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0" "emulator" "system-images;android-34;google_apis;x86_64"

          echo "no" | $ANDROID_HOME/cmdline-tools/bin/avdmanager create avd -n flutter_emulator -k "system-images;android-34;google_apis;x86_64" --device "pixel"
        '';
      };

      onStart = {
        typesense = "typesense-server --data-dir .typesense-data --api-key=$TYPESENSE_API_KEY --listen-port=$TYPESENSE_PORT &";
        emulator = ''
          export ANDROID_HOME=$HOME/android-sdk
          export PATH=$ANDROID_HOME/cmdline-tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH
          nohup $ANDROID_HOME/emulator/emulator -avd flutter_emulator -no-snapshot -no-window -gpu swiftshader_indirect & adb wait-for-device
        '';
      };
    };

    previews = {
      enable = true;
      previews = {
        web = {
          command = ["flutter" "run" "--machine" "-d" "web-server" "--web-hostname" "0.0.0.0" "--web-port" "$PORT"];
          manager = "flutter";
        };
        android = {
          command = ["flutter" "run" "--machine" "-d" "emulator-5554"];
          manager = "flutter";
        };
      };
    };
  };
}